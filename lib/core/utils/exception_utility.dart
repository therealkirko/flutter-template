class ExceptionUtility implements Exception {
  final String? type;
  final String? message;

  ExceptionUtility(this.type, this.message);

  @override
  String toString() => message ?? 'An error occurred';
}

class ValidationException extends ExceptionUtility {
  ValidationException([super.type, super.message]);
}

class ResourceNotFoundException extends ExceptionUtility {
  ResourceNotFoundException([super.type, super.message]);
}

class UnAuthorizedException extends ExceptionUtility{
  UnAuthorizedException([super.type, super.message]);
}

class DuplicateRequestException extends ExceptionUtility{
  DuplicateRequestException([super.type, super.message]);
}

class BadRequestException extends ExceptionUtility{
  BadRequestException([super.type, super.message]);
}

class PendingActionException extends ExceptionUtility{
  PendingActionException([super.type, super.message]);
}

class UnauthorizedException extends ExceptionUtility{
  UnauthorizedException([super.type, super.message]);
}

class ForbiddenException extends ExceptionUtility{
  ForbiddenException([super.type, super.message]);
}

class NotFoundException extends ExceptionUtility{
  NotFoundException([super.type, super.message]);
}

class ServerException extends ExceptionUtility{
  ServerException([super.type, super.message]);
}

// Add these new ones
class NetworkException extends ExceptionUtility{
  NetworkException([super.type, super.message]);
}

class RateLimitException extends ExceptionUtility{
  RateLimitException([super.type, super.message]);
}