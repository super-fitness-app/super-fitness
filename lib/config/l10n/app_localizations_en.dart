// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Super Fitness';

  @override
  String get emptyValidationError => 'This field is required';

  @override
  String get invalidEmailError => 'Please enter a valid email address';

  @override
  String get invalidPhoneError => 'Please enter a valid Egyptian phone number';

  @override
  String get nationalIdError => 'Please enter a valid national ID';

  @override
  String get weakPasswordError => 'Password is too weak';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'Password must be at least 8 characters';

  @override
  String get passwordMustContainUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get passwordMustContainLowercase =>
      'Password must contain at least one lowercase letter';

  @override
  String get passwordMustContainNumber =>
      'Password must contain at least one number';

  @override
  String get passwordMustContainSpecialCharacter =>
      'Password must contain at least one special character';

  @override
  String get passwordMismatchError => 'Passwords do not match';

  @override
  String get fileRequiredError => 'Please upload the required file';

  @override
  String get dropdownRequiredError => 'Please select an option';

  @override
  String get generalValidationError => 'Invalid input';

  @override
  String get invalidLoginPasswordError =>
      'Password must be at least 6 characters with an uppercase letter and a number';

  @override
  String get generalErrorMessage =>
      'Something went wrong. Please try again later.';

  @override
  String get connectionErrorMessage =>
      'Connection timed out. Please check your internet connection.';

  @override
  String get noConnectionErrorMessage =>
      'No internet connection. Please verify your network.';

  @override
  String get securityErrorMessage =>
      'A secure connection could not be established.';

  @override
  String get cancelErrorMessage => 'Request was cancelled.';

  @override
  String get code400Message =>
      'Bad request. Please check your information and try again.';

  @override
  String get code401Message =>
      'Session expired or invalid credentials. Please log in again.';

  @override
  String get code403Message =>
      'You do not have permission to perform this action.';

  @override
  String get code404Message => 'Requested resource not found.';

  @override
  String get code409Message => 'Account or resource already exists.';

  @override
  String get code422Message => 'Validation error. Please verify your inputs.';

  @override
  String get code429Message =>
      'Too many requests. Please wait a moment and try again.';

  @override
  String get code500sMessage =>
      'Server error. Please try again in a few moments.';

  @override
  String get loginTitle => 'Welcome Back!';

  @override
  String get heyThere => 'Hey There';

  @override
  String get welcomeBack => 'WELCOME BACK';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password ?';

  @override
  String get dontHaveAccount => 'Don\'t Have An Account Yet ?';

  @override
  String get register => 'Register';
}
