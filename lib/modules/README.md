# Modules Directory

This directory contains all feature modules for the application. Each module is self-contained and can be developed independently by different teams.

## Module Structure

Each module should follow this standard structure:

```
module_name/
├── controllers/          # GetX controllers (business logic)
├── views/               # UI screens
├── bindings/            # GetX dependency injection
├── models/              # Data models
├── services/            # Module-specific services (optional)
└── widgets/             # Module-specific widgets (optional)
```

## Creating a New Module

### Step 1: Create Module Directory Structure

Create the following directory structure for your module:

```bash
lib/modules/your_module_name/
├── controllers/
├── views/
├── bindings/
├── models/
```

### Step 2: Create Controller

Create a controller in `controllers/your_module_controller.dart`:

```dart
import 'package:get/get.dart';

class YourModuleController extends GetxController {
  // Observable state
  final isLoading = false.obs;
  final data = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      // Your logic here
    } finally {
      isLoading.value = false;
    }
  }
}
```

### Step 3: Create Binding

Create a binding in `bindings/your_module_binding.dart`:

```dart
import 'package:get/get.dart';
import '../controllers/your_module_controller.dart';

class YourModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourModuleController>(() => YourModuleController());
  }
}
```

### Step 4: Create View

Create a view in `views/your_module_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/your_module_controller.dart';

class YourModuleView extends GetView<YourModuleController> {
  const YourModuleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Module'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : YourContent(),
      ),
    );
  }
}
```

### Step 5: Register Routes

Add your routes to `lib/core/routes/app_routes.dart`:

```dart
class AppRoutes {
  // ... existing routes
  static const String yourModule = '/your-module';
  static const String yourModuleDetail = '/your-module/detail';
}
```

Then add the pages to `lib/core/routes/app_pages.dart`:

```dart
import '../../modules/your_module/bindings/your_module_binding.dart';
import '../../modules/your_module/views/your_module_view.dart';

class AppPages {
  static final routes = [
    // ... existing routes
    GetPage(
      name: AppRoutes.yourModule,
      page: () => const YourModuleView(),
      binding: YourModuleBinding(),
    ),
  ];
}
```

## Best Practices

### 1. Module Independence
- Each module should be self-contained
- Avoid direct dependencies between modules
- Use shared services from `lib/core/services/` for cross-module communication

### 2. State Management with GetX
- Use `.obs` for reactive variables
- Use `Obx()` or `GetX<Controller>()` widgets to rebuild UI
- Keep business logic in controllers, not in views

### 3. Dependency Injection
- Use bindings for dependency injection
- Use `Get.lazyPut()` for lazy initialization
- Use `Get.put()` only when immediate initialization is needed

### 4. Navigation
- Use `Get.toNamed(AppRoutes.yourRoute)` for navigation
- Use `Get.offNamed()` to replace current route
- Use `Get.offAllNamed()` to clear navigation stack

### 5. Shared Resources
- Use widgets from `lib/core/widgets/` for consistent UI
- Use `lib/core/utils/ui_helpers.dart` for snackbars and dialogs
- Use `lib/core/utils/validators.dart` for form validation
- Use `lib/core/services/api_service.dart` for API calls

### 6. Models
- Create data models in the `models/` directory
- Implement `fromJson()` and `toJson()` for API serialization
- Implement `copyWith()` for immutable updates

### 7. Error Handling
- Use try-catch blocks in controllers
- Use `UiHelpers.showError()` to display errors
- Log errors for debugging in development

## Example Modules

This template includes three example modules:

1. **Auth Module** (`lib/modules/auth/`)
   - Login and registration functionality
   - Form validation examples
   - GetX state management examples

2. **Home Module** (`lib/modules/home/`)
   - Main dashboard
   - Data loading examples
   - Reactive state examples

3. **Profile Module** (`lib/modules/profile/`)
   - User profile display
   - Data models example
   - Navigation examples

## Team Collaboration

### Git Workflow

When working on a module:

1. Create a feature branch for your module:
   ```bash
   git checkout -b feature/your-module-name
   ```

2. Develop your module independently

3. Test your module thoroughly

4. Create a pull request to merge your module

5. After code review, merge to main branch

### Module Integration

When multiple teams are working on different modules:

1. Each team works on their module in a separate branch
2. Modules are merged to main branch after completion
3. The app routes are updated in `app_pages.dart` to include new modules
4. Integration testing is done after merging

### Avoiding Conflicts

To minimize merge conflicts:

1. Only edit files within your module directory
2. Coordinate with other teams when editing shared files:
   - `lib/core/routes/app_routes.dart`
   - `lib/core/routes/app_pages.dart`
   - `lib/core/config/app_config.dart`
3. Communicate about shared resource changes

## Testing

Each module should include tests:

```
test/modules/your_module/
├── controllers/
├── models/
└── widgets/
```

## Questions?

For more information on GetX, visit: https://pub.dev/packages/get
