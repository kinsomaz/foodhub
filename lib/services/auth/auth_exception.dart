// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class UpdateIsEmailVerifiedException implements Exception {}

// phone registration exception
class PhoneAlreadyLinkedAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}

class CredentialAlreadyInUseAuthException implements Exception {}

class InvalidPhoneNumberAuthException implements Exception {}

class SMSQuotaExceededAuthException implements Exception {}
