# Flutter Module Generator (fmg)

A powerful CLI tool to scaffold modular Flutter modules with GetX state management, following best practices and clean architecture principles.

## Features

- 🚀 **Quick Module Generation**: Create complete modules in seconds
- 📦 **GetX Integration**: Built-in GetX state management
- 🏗️ **Clean Architecture**: Follows SOLID principles and best practices
- 🔧 **BaseService Support**: All services extend BaseService with file upload capabilities
- 🎯 **Type-Safe**: Generates type-safe models with JSON serialization
- 📝 **Well-Documented**: Auto-generated documentation for each module
- ⚡ **Error Handling**: Built-in StateHandlerMixin for consistent error handling
- 🔄 **Loading States**: Pre-configured loading and refresh states

## Installation

### Global Installation (Recommended)

```bash
dart pub global activate flutter_module_generator
```

### Local Installation

```bash
# Clone the repository
git clone https://github.com/therealkirko/flutter-template.git

# Navigate to the CLI tool
cd flutter-template/tools/flutter_module_generator

# Install dependencies
dart pub get

# Activate globally
dart pub global activate --source path .
```

## Usage

### Create a New Module

```bash
fmg create <module_name>
```

### Examples

```bash
# Create a products module
fmg create products

# Create a user profile module
fmg create user_profile

# Create an orders module
fmg create orders
```

### Show Help

```bash
fmg help
# or
fmg --help
# or
fmg -h
```

### Show Version

```bash
fmg --version
# or
fmg -v
```

## What Gets Generated?

When you run `fmg create products`, it generates:

```
lib/modules/products/
├── controllers/
│   └── products_controller.dart       # Business logic
├── views/
│   └── products_view.dart             # UI screen
├── bindings/
│   └── products_binding.dart          # Dependency injection
├── services/
│   └── products_service.dart          # API service
├── models/
│   └── products_model.dart            # Data model
├── widgets/                            # Module-specific widgets (empty)
└── README.md                           # Module documentation
```

### Generated Files Include:

#### Controller (`products_controller.dart`)
- Extends `GetxController` with `StateHandlerMixin`
- Pre-configured loading states
- Error handling
- Refresh functionality
- Service integration

#### Binding (`products_binding.dart`)
- Dependency injection for controller and service
- Lazy loading with `Get.lazyPut()`

#### View (`products_view.dart`)
- GetView implementation
- Loading widget integration
- Pull to refresh
- Error states
- Responsive design

#### Service (`products_service.dart`)
- Extends `BaseService`
- CRUD operations (Create, Read, Update, Delete)
- File upload ready
- Type-safe responses

#### Model (`products_model.dart`)
- JSON serialization (`fromJson`, `toJson`)
- CopyWith method
- Equality operators
- ToString override

## After Module Creation

### Step 1: Add Route

Add the route to `lib/core/routes/app_routes.dart`:

```dart
class AppRoutes {
  // ... existing routes
  static const String products = '/products';
}
```

### Step 2: Register Page

Add the page to `lib/core/routes/app_pages.dart`:

```dart
import '../../modules/products/bindings/products_binding.dart';
import '../../modules/products/views/products_view.dart';

class AppPages {
  static final routes = [
    // ... existing routes
    GetPage(
      name: AppRoutes.products,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
    ),
  ];
}
```

### Step 3: Navigate

Navigate to your module:

```dart
Get.toNamed(AppRoutes.products);
```

## Generated Module Structure Explained

### Controller
- **Purpose**: Handles business logic and state management
- **Features**:
  - Observable state with `.obs`
  - StateHandlerMixin for error/success messages
  - Service integration
  - Lifecycle methods (onInit, onClose)

### Service
- **Purpose**: Handles all API calls
- **Features**:
  - Extends BaseService
  - HTTP methods (GET, POST, PUT, PATCH, DELETE)
  - File upload support
  - Type-safe responses

### Model
- **Purpose**: Represents data structure
- **Features**:
  - JSON serialization
  - CopyWith for immutability
  - Equality operators
  - ToString for debugging

### View
- **Purpose**: UI presentation
- **Features**:
  - GetView for automatic controller injection
  - Loading states
  - Error handling
  - Pull to refresh
  - Responsive design

### Binding
- **Purpose**: Dependency injection
- **Features**:
  - Lazy loading
  - Service and controller registration
  - Clean dependency management

## Module Naming Conventions

The CLI automatically handles naming conventions:

| Input | Controller | View | Service | Model | Route |
|-------|------------|------|---------|-------|-------|
| `products` | ProductsController | ProductsView | ProductsService | ProductsModel | /products |
| `user_profile` | UserProfileController | UserProfileView | UserProfileService | UserProfileModel | /user-profile |
| `order_items` | OrderItemsController | OrderItemsView | OrderItemsService | OrderItemsModel | /order-items |

## Customization

After generation, you can customize each file:

### Controller
```dart
Future<void> loadProducts() async {
  try {
    isLoading.value = true;
    final products = await _service.getAll();
    // Handle products
  } catch (e) {
    handleState('error', e.toString());
  } finally {
    isLoading.value = false;
  }
}
```

### Service
```dart
Future<List<ProductsModel>> getProducts({String? category}) async {
  final response = await get(
    '/products',
    query: {
      if (category != null) 'category': category,
    },
  );
  return (response.body as List)
      .map((e) => ProductsModel.fromJson(e))
      .toList();
}
```

### Model
```dart
class ProductsModel {
  final String id;
  final String name;
  final double price;
  final String? description;

  // Add more fields as needed
}
```

## Requirements

- Dart SDK >= 2.17.0
- Flutter project with GetX
- Recommended: Project using the flutter-template structure

## Best Practices

1. **Run from project root**: Always run `fmg create` from your Flutter project root
2. **Meaningful names**: Use descriptive module names (e.g., `user_management` instead of `um`)
3. **Follow conventions**: Use snake_case for module names (e.g., `user_profile`)
4. **Customize after generation**: Generated files are templates - customize them for your needs
5. **Service implementation**: Implement actual API endpoints in the service
6. **Model fields**: Add/modify fields in the model to match your API response

## Troubleshooting

### "Not a Flutter project" Error
- Make sure you're in the root directory of your Flutter project
- Check that `pubspec.yaml` exists and contains `flutter:` dependency

### "Module already exists" Error
- The module name is already taken
- Choose a different name or delete the existing module

### Module not showing
- Make sure you added the route to `app_routes.dart`
- Make sure you added the page to `app_pages.dart`
- Restart your app

## Examples

### E-commerce App

```bash
fmg create products
fmg create categories
fmg create cart
fmg create orders
fmg create checkout
fmg create user_profile
```

### Social Media App

```bash
fmg create posts
fmg create comments
fmg create likes
fmg create followers
fmg create messages
fmg create notifications
```

### Business App

```bash
fmg create dashboard
fmg create reports
fmg create analytics
fmg create settings
fmg create team_members
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- GitHub Issues: https://github.com/therealkirko/flutter-template/issues
- Documentation: https://github.com/therealkirko/flutter-template

## Credits

Created by [therealkirko](https://github.com/therealkirko)

## Changelog

### v1.0.0 (2025-01-15)
- Initial release
- Module generation with controller, binding, view, service, and model
- BaseService integration
- StateHandlerMixin support
- File upload ready services
- Comprehensive documentation
