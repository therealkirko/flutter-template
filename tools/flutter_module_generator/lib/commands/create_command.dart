import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import '../utils/file_utils.dart';
import '../utils/string_utils.dart';
import '../templates/controller_template.dart';
import '../templates/binding_template.dart';
import '../templates/view_template.dart';
import '../templates/service_template.dart';
import '../templates/model_template.dart';

class CreateCommand {
  static Future<void> execute(ArgResults results) async {
    // Get module name from arguments
    if (results.rest.isEmpty) {
      print('Error: Module name is required');
      print('Usage: fmg create <module_name>');
      exit(1);
    }

    final moduleName = results.rest[0];

    // Validate module name
    if (!StringUtils.isValidModuleName(moduleName)) {
      print('Error: Invalid module name "$moduleName"');
      print('Module name must start with a letter and contain only letters, numbers, and underscores');
      exit(1);
    }

    // Check if in Flutter project
    if (!FileUtils.isFlutterProject()) {
      print('Error: Not a Flutter project');
      print('Please run this command from the root of your Flutter project');
      exit(1);
    }

    // Check if modules directory exists
    if (!FileUtils.hasModulesDirectory()) {
      print('Error: lib/modules directory not found');
      print('Creating modules directory...');
      FileUtils.createDirectory(FileUtils.getModulesPath());
    }

    // Check if module already exists
    if (FileUtils.moduleExists(moduleName)) {
      print('Error: Module "$moduleName" already exists');
      exit(1);
    }

    print('\n🚀 Creating module: $moduleName\n');

    // Create module structure
    await _createModuleStructure(moduleName);

    print('\n✅ Module created successfully!\n');
    print('📁 Module location: lib/modules/$moduleName');
    print('\n📝 Next steps:');
    print('1. Add route to lib/core/routes/app_routes.dart');
    print('2. Add page to lib/core/routes/app_pages.dart');
    print('3. Customize the generated files to fit your needs');
    print('\n💡 Tip: Check SERVICES_GUIDE.md for service implementation examples\n');
  }

  static Future<void> _createModuleStructure(String moduleName) async {
    final modulePath = FileUtils.getModulePath(moduleName);

    // Generate class names
    final pascalCase = StringUtils.toPascalCase(moduleName);
    final controllerClass = '${pascalCase}Controller';
    final bindingClass = '${pascalCase}Binding';
    final viewClass = '${pascalCase}View';
    final serviceClass = '${pascalCase}Service';
    final modelClass = '${pascalCase}Model';

    // Create directories
    final directories = [
      'controllers',
      'views',
      'bindings',
      'services',
      'models',
      'widgets',
    ];

    for (var dir in directories) {
      FileUtils.createDirectory(path.join(modulePath, dir));
    }

    // Create controller
    final controllerPath = path.join(modulePath, 'controllers', '${moduleName}_controller.dart');
    FileUtils.createFile(
      controllerPath,
      ControllerTemplate.generate(moduleName, controllerClass),
    );

    // Create binding
    final bindingPath = path.join(modulePath, 'bindings', '${moduleName}_binding.dart');
    FileUtils.createFile(
      bindingPath,
      BindingTemplate.generate(moduleName, bindingClass, controllerClass, serviceClass),
    );

    // Create view
    final viewPath = path.join(modulePath, 'views', '${moduleName}_view.dart');
    FileUtils.createFile(
      viewPath,
      ViewTemplate.generate(moduleName, viewClass, controllerClass),
    );

    // Create service
    final servicePath = path.join(modulePath, 'services', '${moduleName}_service.dart');
    FileUtils.createFile(
      servicePath,
      ServiceTemplate.generate(moduleName, serviceClass, modelClass),
    );

    // Create model
    final modelPath = path.join(modulePath, 'models', '${moduleName}_model.dart');
    FileUtils.createFile(
      modelPath,
      ModelTemplate.generate(moduleName, modelClass),
    );

    // Create README
    final readmePath = path.join(modulePath, 'README.md');
    FileUtils.createFile(
      readmePath,
      _generateReadme(moduleName, pascalCase),
    );

    // Print route examples
    print('\n📋 Add these to your routes:\n');
    _printRouteExamples(moduleName, pascalCase, bindingClass, viewClass);
  }

  static String _generateReadme(String moduleName, String pascalCase) {
    final routeName = StringUtils.getRouteName(moduleName);

    return '''# $pascalCase Module

This module was generated using Flutter Module Generator (fmg).

## Structure

```
$moduleName/
├── controllers/
│   └── ${moduleName}_controller.dart   # Business logic
├── views/
│   └── ${moduleName}_view.dart         # UI screens
├── bindings/
│   └── ${moduleName}_binding.dart      # Dependency injection
├── services/
│   └── ${moduleName}_service.dart      # API calls
├── models/
│   └── ${moduleName}_model.dart        # Data models
└── widgets/                             # Module-specific widgets
```

## Setup

1. Add route to `lib/core/routes/app_routes.dart`:
```dart
static const String $moduleName = '$routeName';
```

2. Add page to `lib/core/routes/app_pages.dart`:
```dart
GetPage(
  name: AppRoutes.$moduleName,
  page: () => const ${pascalCase}View(),
  binding: ${pascalCase}Binding(),
),
```

## Usage

Navigate to this module:
```dart
Get.toNamed(AppRoutes.$moduleName);
```

## Customize

- **Controller**: Implement your business logic in `${moduleName}_controller.dart`
- **View**: Design your UI in `${moduleName}_view.dart`
- **Service**: Add API calls in `${moduleName}_service.dart`
- **Model**: Define your data structure in `${moduleName}_model.dart`
''';
  }

  static void _printRouteExamples(String moduleName, String pascalCase, String bindingClass, String viewClass) {
    final routeName = StringUtils.getRouteName(moduleName);

    print('// Add to lib/core/routes/app_routes.dart:');
    print('static const String $moduleName = \'$routeName\';');
    print('');
    print('// Add to lib/core/routes/app_pages.dart:');
    print('import \'../../modules/$moduleName/bindings/${moduleName}_binding.dart\';');
    print('import \'../../modules/$moduleName/views/${moduleName}_view.dart\';');
    print('');
    print('GetPage(');
    print('  name: AppRoutes.$moduleName,');
    print('  page: () => const $viewClass(),');
    print('  binding: $bindingClass(),');
    print('),');
  }
}
