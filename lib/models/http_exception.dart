class HttpException implements Exception {
  final String message;

  HttpException(this.message);
  @override
  String toString() {
    return message;
  }

  static String errorMessageFromAuthException(String errorText,
      [String? defaultMessage]) {
    switch (errorText) {
      case 'EMAIL_EXISTS':
        return 'This email address is already in use';
      case 'INVALID_PASSWORD':
        return 'Invalid password';
      case 'WEAK_PASSWORD':
        return 'This password is too weak';
      case 'EMAIL_NOT_FOUND':
        return 'Email does not exist!';
      case 'INVALID_EMAIL':
        return 'This is not a valid email address.';
      case 'USER_NOT_FOUND':
        return '';
      case 'OPERATION_NOT_ALLOWED':
        return 'Could not be authenticated';
      case 'TOO_MANY_ATTEMPTS_TRY_LATER':
        return 'Too many attempt. Try again later';
      case 'USER_DISABLED':
        return 'User not allowed';
      default:
        return defaultMessage ?? 'An error occurred!';
    }
  }
}
