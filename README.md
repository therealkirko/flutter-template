# Flutter Modular Template

A Flutter template with modular architecture and GetX state management, designed for team collaboration.

## Features

- **Modular Architecture**: Self-contained feature modules that can be developed independently
- **GetX State Management**: Reactive state management with minimal boilerplate
- **Clean Architecture**: Separation of concerns with clear folder structure
- **Team-Ready**: Designed for multiple teams working on different modules
- **Best Practices**: Includes examples of forms, validation, navigation, and more

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── core/                          # Core/shared functionality
│   ├── config/                    # App configuration
│   │   ├── app_config.dart       # Environment & API config
│   │   └── app_constants.dart    # App-wide constants
│   ├── routes/                    # Central routing
│   │   ├── app_routes.dart       # Route names
│   │   └── app_pages.dart        # Route definitions
│   ├── themes/                    # App themes
│   │   └── app_theme.dart        # Light & dark themes
│   ├── widgets/                   # Shared widgets
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   └── loading_widget.dart
│   ├── services/                  # Shared services
│   │   ├── api_service.dart      # HTTP client
│   │   └── storage_service.dart  # Local storage
│   └── utils/                     # Utilities
│       ├── app_exception.dart    # Exception classes
│       ├── validators.dart       # Form validators
│       └── ui_helpers.dart       # Snackbars & dialogs
│
└── modules/                       # Feature modules
    ├── auth/                      # Authentication module
    │   ├── controllers/
    │   ├── views/
    │   ├── bindings/
    │   └── models/
    ├── home/                      # Home module
    ├── profile/                   # Profile module
    └── README.md                  # Module creation guide
```

## Getting Started

### Prerequisites

- Flutter SDK (>=2.12.0)
- Dart SDK (>=2.12.0)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutter-template
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Creating a New Module

See the detailed guide in [lib/modules/README.md](lib/modules/README.md)

Quick steps:

1. Create module directory: `lib/modules/your_module/`
2. Create controller, binding, and view
3. Register routes in `lib/core/routes/`
4. Start developing!

## State Management with GetX

This template uses [GetX](https://pub.dev/packages/get) for:

- **State Management**: Reactive programming with `.obs`
- **Dependency Injection**: Controllers and services
- **Route Management**: Navigation with named routes
- **Utils**: Snackbars, dialogs, and more

### Basic Usage

```dart
// Controller
class MyController extends GetxController {
  final count = 0.obs;
  void increment() => count.value++;
}

// View
class MyView extends GetView<MyController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text('Count: ${controller.count}'));
  }
}
```

## Team Collaboration

This template is designed for multiple teams working on different modules:

### Workflow

1. Each team creates a feature branch for their module
2. Teams develop modules independently
3. Modules are merged to main branch after completion
4. Integration testing ensures everything works together

### Avoiding Conflicts

- Each module is self-contained in `lib/modules/module_name/`
- Shared resources are in `lib/core/`
- Coordinate changes to shared files (routes, config)

## Included Modules

### 1. Auth Module
- Login screen with form validation
- Register screen
- Password visibility toggle
- Error handling examples

### 2. Home Module
- Dashboard with sample data
- Counter example
- List rendering
- Pull to refresh

### 3. Profile Module
- User profile display
- Edit profile (template)
- Settings navigation
- Logout functionality

## Customization

### Themes

Edit themes in `lib/core/themes/app_theme.dart`:

```dart
ThemeData get lightTheme {
  return ThemeData(
    primaryColor: Colors.blue,  // Change colors
    // ... customize more
  );
}
```

### Configuration

Update app config in `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  static const String appName = 'Your App Name';
  static const String baseUrl = 'https://your-api.com';
  // ... more config
}
```

### Constants

Add app constants in `lib/core/config/app_constants.dart`

## Shared Resources

### Widgets

Use shared widgets for consistency:

```dart
CustomButton(
  text: 'Submit',
  onPressed: () {},
  isLoading: true,
)

CustomTextField(
  label: 'Email',
  controller: emailController,
  validator: Validators.validateEmail,
)
```

### UI Helpers

```dart
UiHelpers.showSuccess('Operation successful');
UiHelpers.showError('Something went wrong');
UiHelpers.showLoading(message: 'Please wait...');
```

### Validators

```dart
TextFormField(
  validator: Validators.validateEmail,
)
```

### API Service

```dart
final apiService = Get.find<ApiService>();
final response = await apiService.getRequest('/users');
```

## Building for Production

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## Best Practices

1. **Keep modules independent** - Avoid cross-module dependencies
2. **Use GetX reactive state** - Leverage `.obs` for reactive variables
3. **Handle errors gracefully** - Use try-catch and display user-friendly messages
4. **Validate user input** - Use validators from `lib/core/utils/validators.dart`
5. **Follow naming conventions** - Use clear, descriptive names
6. **Write tests** - Test controllers, models, and widgets
7. **Document your code** - Add comments for complex logic

## Common Tasks

### Navigation

```dart
// Navigate to a route
Get.toNamed(AppRoutes.profile);

// Navigate and remove previous route
Get.offNamed(AppRoutes.home);

// Navigate and clear all previous routes
Get.offAllNamed(AppRoutes.login);

// Navigate with arguments
Get.toNamed(AppRoutes.detail, arguments: {'id': 123});
```

### State Management

```dart
// Create observable variable
final count = 0.obs;

// Update value
count.value = 10;

// Listen to changes in UI
Obx(() => Text('${count.value}'));
```

### Dependency Injection

```dart
// Register service
Get.put(MyService());

// Get service
final service = Get.find<MyService>();

// Lazy initialization
Get.lazyPut(() => MyService());
```

## Troubleshooting

### Common Issues

1. **Import errors**: Run `flutter pub get`
2. **Hot reload not working**: Restart the app
3. **GetX controller not found**: Ensure binding is registered in routes

## Contributing

1. Create a feature branch
2. Make your changes
3. Write tests
4. Submit a pull request

## License

This template is provided as-is for your projects.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [GetX Documentation](https://pub.dev/packages/get)
- [Dart Documentation](https://dart.dev/guides)

## Support

For issues and questions, please refer to:
- Flutter: https://flutter.dev/community
- GetX: https://github.com/jonataslaw/getx
