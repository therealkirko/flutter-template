import 'ui_helpers.dart';

/// Mixin for handling success/error/info states
/// Use this in controllers to display messages to users
mixin StateHandlerMixin {
  /// Handle state and show appropriate message
  ///
  /// States: 'success', 'error', 'info', 'warning'
  void handleState(String state, String message) {
    switch (state.toLowerCase()) {
      case 'success':
        UiHelpers.showSuccess(message);
        break;
      case 'error':
        UiHelpers.showError(message);
        break;
      case 'info':
        UiHelpers.showInfo(message);
        break;
      case 'warning':
        UiHelpers.showWarning(message);
        break;
      default:
        UiHelpers.showInfo(message);
    }
  }

  /// Show success message
  void showSuccess(String message, {String? title}) {
    UiHelpers.showSuccess(message, title: title);
  }

  /// Show error message
  void showError(String message, {String? title}) {
    UiHelpers.showError(message, title: title);
  }

  /// Show info message
  void showInfo(String message, {String? title}) {
    UiHelpers.showInfo(message, title: title);
  }

  /// Show warning message
  void showWarning(String message, {String? title}) {
    UiHelpers.showWarning(message, title: title);
  }

  /// Show loading dialog
  void showLoading({String? message}) {
    UiHelpers.showLoading(message: message);
  }

  /// Hide loading dialog
  void hideLoading() {
    UiHelpers.hideLoading();
  }
}
