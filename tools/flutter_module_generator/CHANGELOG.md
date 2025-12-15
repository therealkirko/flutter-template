# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-15

### Added
- Initial release of Flutter Module Generator (fmg)
- `create` command to generate complete Flutter modules
- Automatic generation of:
  - Controller with StateHandlerMixin
  - Binding with dependency injection
  - View with loading states and pull-to-refresh
  - Service extending BaseService
  - Model with JSON serialization
  - Module-specific README
- Support for snake_case module naming
- Automatic PascalCase class name conversion
- Route generation helpers
- Comprehensive help command
- Version flag
- Validation for module names
- Flutter project detection
- Module existence check
- Directory structure creation
- File upload support in generated services
- Loading and error states in controllers
- GetX state management integration
- Clean architecture patterns
- Best practices documentation

### Features
- Generate complete CRUD operations in service
- Type-safe model generation
- Automatic route suggestions
- Module-specific widget folder
- Comprehensive documentation for each module
- BaseService integration
- StateHandlerMixin for error handling

## [Unreleased]

### Planned Features
- Auto-add routes to app_routes.dart and app_pages.dart
- Generate test files for modules
- Support for custom templates
- Interactive mode for module creation
- Module deletion command
- Module listing command
- Update existing modules
- Generate only specific files (controller, view, etc.)
- Support for different state management solutions
- Custom naming patterns
- Plugin system for custom generators
