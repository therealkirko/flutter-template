import 'dart:io';
import 'package:path/path.dart' as path;

class FileUtils {
  /// Check if directory exists
  static bool directoryExists(String dirPath) {
    return Directory(dirPath).existsSync();
  }

  /// Check if file exists
  static bool fileExists(String filePath) {
    return File(filePath).existsSync();
  }

  /// Create directory
  static void createDirectory(String dirPath) {
    Directory(dirPath).createSync(recursive: true);
    print('✓ Created directory: $dirPath');
  }

  /// Create file with content
  static void createFile(String filePath, String content) {
    File(filePath).writeAsStringSync(content);
    print('✓ Created file: $filePath');
  }

  /// Get current directory
  static String getCurrentDirectory() {
    return Directory.current.path;
  }

  /// Check if current directory is a Flutter project
  static bool isFlutterProject() {
    final pubspecPath = path.join(getCurrentDirectory(), 'pubspec.yaml');
    if (!fileExists(pubspecPath)) {
      return false;
    }

    final content = File(pubspecPath).readAsStringSync();
    return content.contains('flutter:');
  }

  /// Check if modules directory exists
  static bool hasModulesDirectory() {
    final modulesPath = path.join(getCurrentDirectory(), 'lib', 'modules');
    return directoryExists(modulesPath);
  }

  /// Get modules directory path
  static String getModulesPath() {
    return path.join(getCurrentDirectory(), 'lib', 'modules');
  }

  /// Get module path
  static String getModulePath(String moduleName) {
    return path.join(getModulesPath(), moduleName);
  }

  /// Check if module already exists
  static bool moduleExists(String moduleName) {
    return directoryExists(getModulePath(moduleName));
  }

  /// Get core routes path
  static String getCoreRoutesPath() {
    return path.join(getCurrentDirectory(), 'lib', 'core', 'routes');
  }

  /// Check if routes directory exists
  static bool hasRoutesDirectory() {
    return directoryExists(getCoreRoutesPath());
  }
}
