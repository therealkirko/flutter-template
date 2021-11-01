class AppException implements Exception {
  final String? type;
  final String? message;

  AppException([this.type, this.message]);
}

class BadRequestException extends AppException{
  BadRequestException([String? type, String? message]) : super(type, message);
}

class FetchDataException extends AppException{
  FetchDataException([String? type, String? message]) : super(type, message);
}

class ApiNotRespondingException extends AppException{
  ApiNotRespondingException([String? type, String? message]) : super(type, message);
}

class UnAuthorizedException extends AppException{
  UnAuthorizedException([String? type, String? message]) : super(type, message);
}