abstract final class AppStrings {
  // Register Header
  static const String heyThere = 'Hey There';
  static const String createAnAccount = 'CREATE AN ACCOUNT';

  // Register Form
  static const String register = 'Register';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String email = 'Email';
  static const String password = 'Password';

  // Validation Messages
  static const String firstNameRequired = 'First name is required';
  static const String lastNameRequired = 'Last name is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordMinLength =
      'Password must be at least 8 characters';

  // Social Auth
  static const String or = 'Or';

  // Footer & Links
  static const String alreadyHaveAnAccount = 'Already Have An Account ? ';
  static const String login = 'Login';

  // Forget Password
  static const String forgetPassword = 'Forget Password';

  // Registration Flow Status Messages
  static const String registeredSuccessfully = 'Registered successfully';
  static const String missingRegistrationData =
      'Please fill all required registration details';

  // Common
  static const String emptyString = '';

  // Social Auth Errors & Status Messages
  static const String googleAccountIdMissing =
      'Google account ID is missing. Please try again.';
  static const String googleAccountConnected =
      'Google account connected. Complete your profile.';
  static const String signInCancelled = 'Sign-in cancelled';
  static const String firebaseUserNotFoundCode = 'user-not-found';
  static const String firebaseUserCreationFailed =
      'Firebase user creation failed after Google authentication';
  static const String facebookNotImplemented =
      'Facebook sign in is not implemented yet';

  // Firebase Auth Error Messages
  static const String accountDisabled = 'This account has been disabled.';
  static const String invalidGoogleCredentials = 'Invalid Google credentials.';
  static const String googleSignInNotEnabled =
      'Google sign-in is not enabled.';
  static const String accountExistsWithDifferentCredential =
      'An account already exists with the same email address.';
  static const String googleAuthFailed = 'Google authentication failed.';

  // Complete Registration Flow (Multi-step Onboarding)
  static const String tellUsAboutYourself = 'TELL US ABOUT YOURSELF!';
  static const String weNeedToKnowYourGender = 'We Need To Know Your Gender';
  static const String male = 'Male';
  static const String female = 'Female';
  static const String next = 'Next';

  static const String howOldAreYou = 'HOW OLD ARE YOU ?';
  static const String personalizedPlanSubtitle =
      'This Helps Us Create Your Personalized Plan';
  static const String year = 'Year';

  static const String whatIsYourWeight = 'WHAT IS YOUR WEIGHT ?';
  static const String kg = 'Kg';
  static const String done = 'Done';

  static const String whatIsYourHeight = 'WHAT IS YOUR HIGHT ?';
  static const String cm = 'CM';

  static const String whatIsYourGoal = 'WHAT IS YOUR GOAL ?';
  static const String gainWeight = 'Gain Weight';
  static const String loseWeight = 'Lose Weight';
  static const String getFitter = 'Get Fitter';
  static const String gainMoreFlexible = 'Gain More Flexible';
  static const String learnTheBasic = 'Learn The Basic';

  static const String activityLevelTitle =
      'YOUR REGULAR PHYSICAL\nACTIVITY LEVEL ?';
  static const String rookie = 'Rookie';
  static const String beginner = 'Beginner';
  static const String intermediate = 'Intermediate';
  static const String advance = 'Advance';
  static const String trueBeast = 'True Beast';
}
