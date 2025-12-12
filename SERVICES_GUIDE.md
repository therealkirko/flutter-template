# Services Guide

This guide explains how to create and use services in your modules.

## Overview

Services handle all API communication and business logic related to data fetching. All module services should extend `BaseService` which provides common HTTP methods (GET, POST, PUT, PATCH, DELETE) and file upload support.

## Service Architecture

```
lib/
├── core/
│   └── services/
│       ├── base_service.dart      # Base class for all services
│       ├── api_service.dart       # Low-level HTTP client
│       ├── token_service.dart     # Token management
│       └── storage_service.dart   # Local storage
│
└── modules/
    └── your_module/
        └── services/
            └── your_module_service.dart  # Module-specific service
```

## Creating a Service

### Step 1: Create Service Class

Create a service that extends `BaseService`:

```dart
import 'package:get/get.dart';
import '../../../core/services/base_service.dart';

class ProductService extends BaseService {
  // Your service methods here
}
```

### Step 2: Implement Service Methods

#### Simple GET Request

```dart
Future<List<Product>> getProducts({int page = 1}) async {
  final response = await get('/products', query: {'page': page});

  final data = extractData<List>(response, 'data');
  return data?.map((json) => Product.fromJson(json)).toList() ?? [];
}
```

#### POST Request

```dart
Future<Product> createProduct({
  required String name,
  required double price,
}) async {
  final response = await post(
    '/products',
    body: {
      'name': name,
      'price': price,
    },
  );

  return Product.fromJson(response.body);
}
```

#### PUT Request

```dart
Future<Product> updateProduct({
  required String id,
  required String name,
  required double price,
}) async {
  final response = await put(
    '/products/$id',
    body: {
      'name': name,
      'price': price,
    },
  );

  return Product.fromJson(response.body);
}
```

#### PATCH Request (Partial Update)

```dart
Future<Product> updateProductPrice({
  required String id,
  required double price,
}) async {
  final response = await patch(
    '/products/$id',
    body: {'price': price},
  );

  return Product.fromJson(response.body);
}
```

#### DELETE Request

```dart
Future<void> deleteProduct(String id) async {
  await delete('/products/$id');
}
```

### Step 3: File Upload Support

#### Single File Upload

```dart
import 'dart:io';

Future<Product> uploadProductImage({
  required String productId,
  required File image,
}) async {
  final response = await postWithFile(
    '/products/$productId/image',
    files: {
      'image': image,
    },
    data: {
      'product_id': productId,
    },
  );

  return Product.fromJson(response.body);
}
```

#### Multiple Files Upload

```dart
Future<Gallery> uploadGalleryImages({
  required List<File> images,
  required String galleryName,
}) async {
  final response = await postWithFiles(
    '/gallery/upload',
    files: {
      'images': images,  // Multiple files for same field
    },
    data: {
      'name': galleryName,
    },
  );

  return Gallery.fromJson(response.body);
}
```

#### Update with File

```dart
Future<User> updateProfileWithAvatar({
  required File avatar,
  String? name,
  String? bio,
}) async {
  final response = await putWithFile(
    '/user/profile',
    files: {
      'avatar': avatar,
    },
    data: {
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
    },
  );

  return User.fromJson(response.body);
}
```

### Step 4: Register Service in Binding

```dart
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../services/product_service.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // Register service
    Get.lazyPut<ProductService>(() => ProductService());

    // Register controller
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
```

### Step 5: Use Service in Controller

```dart
import 'package:get/get.dart';
import '../../../core/utils/state_handler_mixin.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

class ProductController extends GetxController with StateHandlerMixin {
  final ProductService _productService = Get.find<ProductService>();

  final products = <Product>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;

      final result = await _productService.getProducts();
      products.value = result;

    } catch (e) {
      handleState('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProduct(String name, double price) async {
    try {
      isLoading.value = true;

      final product = await _productService.createProduct(
        name: name,
        price: price,
      );

      products.add(product);
      showSuccess('Product created successfully!');

    } catch (e) {
      handleState('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
```

## BaseService Methods

### HTTP Methods

| Method | Description | Use Case |
|--------|-------------|----------|
| `get()` | GET request | Fetch data |
| `post()` | POST request | Create new resource |
| `put()` | PUT request | Update entire resource |
| `patch()` | PATCH request | Partial update |
| `delete()` | DELETE request | Delete resource |

### File Upload Methods

| Method | Description | Use Case |
|--------|-------------|----------|
| `postWithFile()` | POST with single file | Upload avatar, document |
| `putWithFile()` | PUT with single file | Update with file |
| `postWithFiles()` | POST with multiple files | Upload gallery, multiple documents |

### Helper Methods

| Method | Description | Return Type |
|--------|-------------|-------------|
| `handleResponse()` | Validates response and throws errors | `T` |
| `extractData()` | Extracts data from standard API response | `T?` |

## Error Handling

Services automatically throw appropriate exceptions based on HTTP status codes:

```dart
Future<void> fetchData() async {
  try {
    final data = await yourService.getData();
    // Handle success
  } on ValidationException catch (e) {
    // Handle validation errors (422)
    showError(e.message);
  } on UnAuthorizedException catch (e) {
    // Handle unauthorized (401)
    Get.offAllNamed(AppRoutes.login);
  } on NotFoundException catch (e) {
    // Handle not found (404)
    showError('Resource not found');
  } on NetworkException catch (e) {
    // Handle network errors
    showError('No internet connection');
  } catch (e) {
    // Handle other errors
    showError(e.toString());
  }
}
```

## Example Services

### 1. AuthService

See: `lib/modules/auth/services/auth_service.dart`

Features:
- Login with email/password
- Register new user
- PIN authentication
- Token refresh
- Password reset
- Email verification

### 2. UserService

See: `lib/modules/profile/services/user_service.dart`

Features:
- CRUD operations for users
- Avatar upload
- Multiple document uploads
- User preferences
- Password change

## Best Practices

### 1. One Service Per Module

```
modules/
├── auth/
│   └── services/
│       └── auth_service.dart
├── products/
│   └── services/
│       └── product_service.dart
└── orders/
    └── services/
        └── order_service.dart
```

### 2. Keep Services Focused

Each service should handle one domain:

```dart
// ✅ Good
class ProductService extends BaseService {
  Future<List<Product>> getProducts() { ... }
  Future<Product> createProduct() { ... }
  Future<Product> updateProduct() { ... }
}

// ❌ Bad - mixing concerns
class ProductService extends BaseService {
  Future<List<Product>> getProducts() { ... }
  Future<User> getUser() { ... }  // Should be in UserService
  Future<Order> createOrder() { ... }  // Should be in OrderService
}
```

### 3. Use Type-Safe Models

Always parse responses into models:

```dart
// ✅ Good
Future<Product> getProduct(String id) async {
  final response = await get('/products/$id');
  return Product.fromJson(response.body);
}

// ❌ Bad - returning dynamic
Future<dynamic> getProduct(String id) async {
  final response = await get('/products/$id');
  return response.body;
}
```

### 4. Handle Errors in Controllers

Don't handle UI logic in services:

```dart
// ✅ Good - Service just fetches data
class ProductService extends BaseService {
  Future<Product> getProduct(String id) async {
    final response = await get('/products/$id');
    return Product.fromJson(response.body);
  }
}

// Controller handles UI
class ProductController extends GetxController {
  Future<void> loadProduct(String id) async {
    try {
      product.value = await productService.getProduct(id);
    } catch (e) {
      showError('Failed to load product');
    }
  }
}
```

### 5. Use Descriptive Method Names

```dart
// ✅ Good
getProducts()
createProduct()
updateProduct()
deleteProduct()
searchProducts()
getProductsByCategory()

// ❌ Bad
fetch()
save()
remove()
find()
```

## API Response Format

Services expect this standard response format:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

For validation errors (422):

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": ["Email is required", "Email must be valid"],
    "password": ["Password is too short"]
  }
}
```

## Testing Services

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late ProductService productService;

  setUp(() {
    // Initialize dependencies
    Get.put(ApiService());
    productService = ProductService();
  });

  test('getProducts returns list of products', () async {
    final products = await productService.getProducts();
    expect(products, isA<List<Product>>());
  });

  tearDown(() {
    Get.reset();
  });
}
```

## Advanced Usage

### Custom Headers

```dart
class ProductService extends BaseService {
  Future<Product> getProduct(String id) async {
    // ApiService automatically adds auth headers
    // But you can customize headers in ApiService if needed
    final response = await get('/products/$id');
    return Product.fromJson(response.body);
  }
}
```

### Query Parameters

```dart
Future<List<Product>> searchProducts({
  String? query,
  String? category,
  double? minPrice,
  double? maxPrice,
  int page = 1,
}) async {
  final response = await get(
    '/products/search',
    query: {
      if (query != null) 'q': query,
      if (category != null) 'category': category,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      'page': page,
    },
  );

  return (response.body['data'] as List)
      .map((json) => Product.fromJson(json))
      .toList();
}
```

### Pagination

```dart
Future<PaginatedResponse<Product>> getProductsPaginated({
  int page = 1,
  int perPage = 20,
}) async {
  final response = await get(
    '/products',
    query: {
      'page': page,
      'per_page': perPage,
    },
  );

  return PaginatedResponse<Product>.fromJson(
    response.body,
    (json) => Product.fromJson(json),
  );
}
```

## Questions?

For more examples, see:
- `lib/modules/auth/services/auth_service.dart`
- `lib/modules/profile/services/user_service.dart`
- `lib/core/services/base_service.dart`
