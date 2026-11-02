import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// App Name
  ///
  /// In en, this message translates to:
  /// **'Super Fitness'**
  String get appName;

  /// No description provided for @emptyValidationError.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get emptyValidationError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmailError;

  /// No description provided for @invalidPhoneError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Egyptian phone number'**
  String get invalidPhoneError;

  /// No description provided for @nationalIdError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid national ID'**
  String get nationalIdError;

  /// No description provided for @weakPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPasswordError;

  /// No description provided for @passwordMustBeAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBeAtLeast8Characters;

  /// No description provided for @passwordMustContainUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordMustContainUppercase;

  /// No description provided for @passwordMustContainLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordMustContainLowercase;

  /// No description provided for @passwordMustContainNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordMustContainNumber;

  /// No description provided for @passwordMustContainSpecialCharacter.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get passwordMustContainSpecialCharacter;

  /// No description provided for @passwordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatchError;

  /// No description provided for @fileRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please upload the required file'**
  String get fileRequiredError;

  /// No description provided for @dropdownRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please select an option'**
  String get dropdownRequiredError;

  /// No description provided for @generalValidationError.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get generalValidationError;

  /// No description provided for @invalidLoginPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters with an uppercase letter and a number'**
  String get invalidLoginPasswordError;

  /// No description provided for @generalErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get generalErrorMessage;

  /// No description provided for @connectionErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please check your internet connection.'**
  String get connectionErrorMessage;

  /// No description provided for @noConnectionErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please verify your network.'**
  String get noConnectionErrorMessage;

  /// No description provided for @securityErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'A secure connection could not be established.'**
  String get securityErrorMessage;

  /// No description provided for @cancelErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled.'**
  String get cancelErrorMessage;

  /// No description provided for @code400Message.
  ///
  /// In en, this message translates to:
  /// **'Bad request. Please check your information and try again.'**
  String get code400Message;

  /// No description provided for @code401Message.
  ///
  /// In en, this message translates to:
  /// **'Session expired or invalid credentials. Please log in again.'**
  String get code401Message;

  /// No description provided for @code403Message.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get code403Message;

  /// No description provided for @code404Message.
  ///
  /// In en, this message translates to:
  /// **'Requested resource not found.'**
  String get code404Message;

  /// No description provided for @code409Message.
  ///
  /// In en, this message translates to:
  /// **'Account or resource already exists.'**
  String get code409Message;

  /// No description provided for @code422Message.
  ///
  /// In en, this message translates to:
  /// **'Validation error. Please verify your inputs.'**
  String get code422Message;

  /// No description provided for @code429Message.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get code429Message;

  /// No description provided for @code500sMessage.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again in a few moments.'**
  String get code500sMessage;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get loginTitle;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already Have An Account ? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingDoIt.
  ///
  /// In en, this message translates to:
  /// **'Do IT'**
  String get onboardingDoIt;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'The Price Of Excellence\nIs Discipline'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Success starts with daily commitment. Stay consistent and push your limits to achieve peak performance.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Fitness Has Never Been So\nMuch Fun'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Turn workouts into an exciting journey with engaging challenges and routines that keep you motivated.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'NO MORE EXCUSES\nDo It Now'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Stop waiting for the perfect moment. Take action today, break through barriers, and build the future you deserve.'**
  String get onboardingSubtitle3;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @smartCoach.
  ///
  /// In en, this message translates to:
  /// **'Smart Coach'**
  String get smartCoach;

  /// No description provided for @workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @heyThere.
  ///
  /// In en, this message translates to:
  /// **'Hey There'**
  String get heyThere;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'WELCOME BACK'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password ?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have An Account Yet ?'**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'CREATE AN ACCOUNT'**
  String get createAnAccount;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @registeredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Registered successfully'**
  String get registeredSuccessfully;

  /// No description provided for @missingRegistrationData.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required registration details'**
  String get missingRegistrationData;

  /// No description provided for @googleAccountIdMissing.
  ///
  /// In en, this message translates to:
  /// **'Google account ID is missing. Please try again.'**
  String get googleAccountIdMissing;

  /// No description provided for @googleAccountConnected.
  ///
  /// In en, this message translates to:
  /// **'Google account connected. Complete your profile.'**
  String get googleAccountConnected;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'TELL US ABOUT YOURSELF!'**
  String get tellUsAboutYourself;

  /// No description provided for @weNeedToKnowYourGender.
  ///
  /// In en, this message translates to:
  /// **'We Need To Know Your Gender'**
  String get weNeedToKnowYourGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @howOldAreYou.
  ///
  /// In en, this message translates to:
  /// **'HOW OLD ARE YOU ?'**
  String get howOldAreYou;

  /// No description provided for @personalizedPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This Helps Us Create Your Personalized Plan'**
  String get personalizedPlanSubtitle;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @whatIsYourWeight.
  ///
  /// In en, this message translates to:
  /// **'WHAT IS YOUR WEIGHT ?'**
  String get whatIsYourWeight;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get kg;

  /// No description provided for @whatIsYourHeight.
  ///
  /// In en, this message translates to:
  /// **'WHAT IS YOUR HIGHT ?'**
  String get whatIsYourHeight;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'CM'**
  String get cm;

  /// No description provided for @whatIsYourGoal.
  ///
  /// In en, this message translates to:
  /// **'WHAT IS YOUR GOAL ?'**
  String get whatIsYourGoal;

  /// No description provided for @gainWeight.
  ///
  /// In en, this message translates to:
  /// **'Gain Weight'**
  String get gainWeight;

  /// No description provided for @loseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get loseWeight;

  /// No description provided for @getFitter.
  ///
  /// In en, this message translates to:
  /// **'Get Fitter'**
  String get getFitter;

  /// No description provided for @gainMoreFlexible.
  ///
  /// In en, this message translates to:
  /// **'Gain More Flexible'**
  String get gainMoreFlexible;

  /// No description provided for @learnTheBasic.
  ///
  /// In en, this message translates to:
  /// **'Learn The Basic'**
  String get learnTheBasic;

  /// No description provided for @activityLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'YOUR REGULAR PHYSICAL\nACTIVITY LEVEL ?'**
  String get activityLevelTitle;

  /// No description provided for @rookie.
  ///
  /// In en, this message translates to:
  /// **'Rookie'**
  String get rookie;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advance.
  ///
  /// In en, this message translates to:
  /// **'Advance'**
  String get advance;

  /// No description provided for @trueBeast.
  ///
  /// In en, this message translates to:
  /// **'True Beast'**
  String get trueBeast;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
