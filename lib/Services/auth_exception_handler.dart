import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        errorMessage = AppLocalizations.of(error)!.emailMalformed;
        break;
      case ExceptionStatus.weakPassword:
        errorMessage = AppLocalizations.of(error)!.passwordToShort;
        break;
      case ExceptionStatus.wrongPassword:
        errorMessage = AppLocalizations.of(error)!.emailPasswordWrong;
        break;
      case ExceptionStatus.emailAlreadyExists:
        errorMessage = AppLocalizations.of(error)!.emailAlreadyExists;
        break;
      default:
        errorMessage = AppLocalizations.of(error)!.errorOccured;
    }
    return errorMessage;
  }
}
