import 'package:firebase_auth/firebase_auth.dart';

enum ExceptionStatus {
  pending,
  dataDeleted,
  reauth,
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class ExceptionHandler {
  static handleAuthException(FirebaseException e) {
    ExceptionStatus status;
    switch (e.code) {
      case "invalid-email":
        status = ExceptionStatus.invalidEmail;
        break;
      case "wrong-password":
        status = ExceptionStatus.wrongPassword;
        break;
      case "weak-password":
        status = ExceptionStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = ExceptionStatus.emailAlreadyExists;
        break;
      default:
        status = ExceptionStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case ExceptionStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case ExceptionStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case ExceptionStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case ExceptionStatus.emailAlreadyExists:
        errorMessage =
            "The email address is already in use by another account.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}
