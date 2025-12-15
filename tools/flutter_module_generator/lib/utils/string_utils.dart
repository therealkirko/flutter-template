import 'package:recase/recase.dart';

class StringUtils {
  /// Convert string to PascalCase
  /// Example: user_profile -> UserProfile
  static String toPascalCase(String input) {
    return ReCase(input).pascalCase;
  }

  /// Convert string to camelCase
  /// Example: user_profile -> userProfile
  static String toCamelCase(String input) {
    return ReCase(input).camelCase;
  }

  /// Convert string to snake_case
  /// Example: UserProfile -> user_profile
  static String toSnakeCase(String input) {
    return ReCase(input).snakeCase;
  }

  /// Convert string to kebab-case
  /// Example: UserProfile -> user-profile
  static String toKebabCase(String input) {
    return ReCase(input).paramCase;
  }

  /// Pluralize a word
  /// Example: product -> products
  static String pluralize(String word) {
    if (word.endsWith('y')) {
      return '${word.substring(0, word.length - 1)}ies';
    } else if (word.endsWith('s') ||
        word.endsWith('x') ||
        word.endsWith('ch') ||
        word.endsWith('sh')) {
      return '${word}es';
    } else {
      return '${word}s';
    }
  }

  /// Validate module name
  /// Returns true if valid, false otherwise
  static bool isValidModuleName(String name) {
    // Module name should only contain letters, numbers, and underscores
    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
    return regex.hasMatch(name);
  }

  /// Get route name from module name
  /// Example: user_profile -> /user-profile
  static String getRouteName(String moduleName) {
    return '/${toKebabCase(moduleName)}';
  }
}
