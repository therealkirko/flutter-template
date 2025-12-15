class HelpCommand {
  static void show() {
    print('''
Flutter Module Generator (fmg) v1.0.0

A CLI tool to generate modular Flutter modules with GetX state management.

USAGE:
  fmg <command> [arguments]

AVAILABLE COMMANDS:
  create <module_name>    Create a new module with controller, binding, view, service, and model
  help                    Display this help message

OPTIONS:
  -h, --help              Show help
  -v, --version           Show version

EXAMPLES:
  # Create a new module called "products"
  fmg create products

  # Create a module called "user_profile"
  fmg create user_profile

  # Show help
  fmg help

WHAT GETS CREATED:
  When you run "fmg create products", it generates:

  lib/modules/products/
  ├── controllers/
  │   └── products_controller.dart      # Business logic with StateHandlerMixin
  ├── views/
  │   └── products_view.dart            # UI screen with loading states
  ├── bindings/
  │   └── products_binding.dart         # Dependency injection
  ├── services/
  │   └── products_service.dart         # API service extending BaseService
  ├── models/
  │   └── products_model.dart           # Data model with JSON serialization
  ├── widgets/                           # For module-specific widgets
  └── README.md                          # Module documentation

FEATURES:
  ✓ GetX state management
  ✓ BaseService integration for API calls
  ✓ StateHandlerMixin for error handling
  ✓ File upload support ready
  ✓ Loading states
  ✓ Pull to refresh
  ✓ Error handling
  ✓ Clean architecture
  ✓ Best practices included

AFTER CREATION:
  1. Add route to lib/core/routes/app_routes.dart
  2. Add page to lib/core/routes/app_pages.dart
  3. Customize generated files to fit your needs

For more information, visit:
  https://github.com/therealkirko/flutter-template
''');
  }
}
