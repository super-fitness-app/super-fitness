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
}

