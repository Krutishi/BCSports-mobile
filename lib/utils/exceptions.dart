class UserNotFoundException implements Exception {
  @override
  toString() => 'No user found for that email.';
}

class WrongPasswordException implements Exception {
  @override
  toString() => 'Wrong password provided for that user.';
}
class WeekPasswordException implements Exception {
  @override
  toString() => 'Wrong password provided for that user.';
}

class AccountAlreadyExistException implements Exception {
  @override
  toString() => 'The account already exists for that email.';
}