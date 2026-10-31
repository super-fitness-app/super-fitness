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
  String get alreadyHaveAnAccount => 'Already Have An Account ? ';

  @override
  String get login => 'Login';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingDoIt => 'Do IT';

  @override
  String get onboardingTitle1 => 'The Price Of Excellence\nIs Discipline';

  @override
  String get onboardingSubtitle1 =>
      'Success starts with daily commitment. Stay consistent and push your limits to achieve peak performance.';

  @override
  String get onboardingTitle2 => 'Fitness Has Never Been So\nMuch Fun';

  @override
  String get onboardingSubtitle2 =>
      'Turn workouts into an exciting journey with engaging challenges and routines that keep you motivated.';

  @override
  String get onboardingTitle3 => 'NO MORE EXCUSES\nDo It Now';

  @override
  String get onboardingSubtitle3 =>
      'Stop waiting for the perfect moment. Take action today, break through barriers, and build the future you deserve.';

  @override
  String get explore => 'Explore';

  @override
  String get smartCoach => 'Smart Coach';

  @override
  String get workouts => 'Workouts';

  @override
  String get profile => 'Profile';

  @override
  String get heyThere => 'Hey There';

  @override
  String get createAnAccount => 'CREATE AN ACCOUNT';

  @override
  String get register => 'Register';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get or => 'Or';

  @override
  String get forgetPassword => 'Forget Password';

  @override
  String get registeredSuccessfully => 'Registered successfully';

  @override
  String get missingRegistrationData =>
      'Please fill all required registration details';

  @override
  String get googleAccountIdMissing =>
      'Google account ID is missing. Please try again.';

  @override
  String get googleAccountConnected =>
      'Google account connected. Complete your profile.';

  @override
  String get tellUsAboutYourself => 'TELL US ABOUT YOURSELF!';

  @override
  String get weNeedToKnowYourGender => 'We Need To Know Your Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get howOldAreYou => 'HOW OLD ARE YOU ?';

  @override
  String get personalizedPlanSubtitle =>
      'This Helps Us Create Your Personalized Plan';

  @override
  String get year => 'Year';

  @override
  String get whatIsYourWeight => 'WHAT IS YOUR WEIGHT ?';

  @override
  String get kg => 'Kg';

  @override
  String get whatIsYourHeight => 'WHAT IS YOUR HIGHT ?';

  @override
  String get cm => 'CM';

  @override
  String get whatIsYourGoal => 'WHAT IS YOUR GOAL ?';

  @override
  String get gainWeight => 'Gain Weight';

  @override
  String get loseWeight => 'Lose Weight';

  @override
  String get getFitter => 'Get Fitter';

  @override
  String get gainMoreFlexible => 'Gain More Flexible';

  @override
  String get learnTheBasic => 'Learn The Basic';

  @override
  String get activityLevelTitle =>
      'YOUR REGULAR PHYSICAL\nACTIVITY LEVEL ?';

  @override
  String get rookie => 'Rookie';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advance => 'Advance';

  @override
  String get trueBeast => 'True Beast';
}
