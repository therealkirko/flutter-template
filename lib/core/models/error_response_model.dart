/// Error response model
class ErrorResponse {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ErrorResponse({
    this.success,
    this.message,
    this.errors,
    this.statusCode,
  });

  /// Create from JSON
  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      errors: json['errors'] as Map<String, dynamic>?,
      statusCode: json['status_code'] as int?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'errors': errors,
      'status_code': statusCode,
    };
  }

  /// Get detailed error message including all validation errors
  String getDetailedMessage() {
    if (errors == null || errors!.isEmpty) {
      return message ?? 'An error occurred';
    }

    // Combine all error messages
    final errorMessages = <String>[];

    errors!.forEach((key, value) {
      if (value is List) {
        errorMessages.addAll(value.map((e) => e.toString()));
      } else {
        errorMessages.add(value.toString());
      }
    });

    return errorMessages.isNotEmpty
        ? errorMessages.join('\n')
        : message ?? 'An error occurred';
  }
}
