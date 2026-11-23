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

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

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

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'CREATE AN ACCOUNT'**
  String get createAnAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

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

  /// No description provided for @facebookAccountIdMissing.
  ///
  /// In en, this message translates to:
  /// **'Facebook account ID is missing. Please try again.'**
  String get facebookAccountIdMissing;

  /// No description provided for @facebookAccountConnected.
  ///
  /// In en, this message translates to:
  /// **'Facebook account connected. Complete your profile.'**
  String get facebookAccountConnected;

  /// No description provided for @accountNotFoundRegisterFirst.
  ///
  /// In en, this message translates to:
  /// **'Account not found. Please register first.'**
  String get accountNotFoundRegisterFirst;

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

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language: '**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @yourWeight.
  ///
  /// In en, this message translates to:
  /// **'Your Weight'**
  String get yourWeight;

  /// No description provided for @yourGoal.
  ///
  /// In en, this message translates to:
  /// **'Your Goal'**
  String get yourGoal;

  /// No description provided for @yourActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Your Activity Level'**
  String get yourActivityLevel;

  /// No description provided for @tapToEdit.
  ///
  /// In en, this message translates to:
  /// **'tap To Edit'**
  String get tapToEdit;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'KG'**
  String get kgUnit;

  /// No description provided for @editWeight.
  ///
  /// In en, this message translates to:
  /// **'Edit Weight ({unit})'**
  String editWeight(String unit);

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter weight in {unit}'**
  String enterWeight(String unit);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @completeRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required fields.'**
  String get completeRequiredFields;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight.'**
  String get invalidWeight;

  /// No description provided for @selectGoal.
  ///
  /// In en, this message translates to:
  /// **'Select Goal'**
  String get selectGoal;

  /// No description provided for @selectActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Select Activity Level'**
  String get selectActivityLevel;

  /// No description provided for @maintainWeight.
  ///
  /// In en, this message translates to:
  /// **'Maintain weight'**
  String get maintainWeight;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @makeSurePasswordIs8Characters.
  ///
  /// In en, this message translates to:
  /// **'Make Sure It\'s 8 Characters Or More'**
  String get makeSurePasswordIs8Characters;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @smartCoachGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {userName} ,'**
  String smartCoachGreeting(String userName);

  /// No description provided for @hiAhmed.
  ///
  /// In en, this message translates to:
  /// **'Hi Ahmed ,'**
  String get hiAhmed;

  /// Greeting with dynamic user name
  ///
  /// In en, this message translates to:
  /// **'Hi {name} ,'**
  String hiWithName(String name);

  /// No description provided for @smartCoachSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I Am Your Smart Coach'**
  String get smartCoachSubtitle;

  /// No description provided for @smartCoachWelcomeAssist.
  ///
  /// In en, this message translates to:
  /// **'How Can I Assist You\nToday ?'**
  String get smartCoachWelcomeAssist;

  /// No description provided for @smartCoachGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get smartCoachGetStarted;

  /// No description provided for @smartCoachInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about fitness...'**
  String get smartCoachInputHint;

  /// No description provided for @smartCoachThinking.
  ///
  /// In en, this message translates to:
  /// **'Smart Coach is thinking...'**
  String get smartCoachThinking;

  /// No description provided for @smartCoachExerciseCardSets.
  ///
  /// In en, this message translates to:
  /// **'Sets & Reps'**
  String get smartCoachExerciseCardSets;

  /// No description provided for @smartCoachExerciseCardMuscle.
  ///
  /// In en, this message translates to:
  /// **'Target Muscle'**
  String get smartCoachExerciseCardMuscle;

  /// No description provided for @smartCoachNutritionCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get smartCoachNutritionCalories;

  /// No description provided for @smartCoachNutritionProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get smartCoachNutritionProtein;

  /// No description provided for @smartCoachNutritionCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get smartCoachNutritionCarbs;

  /// No description provided for @smartCoachNutritionFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get smartCoachNutritionFat;

  /// No description provided for @smartCoachClearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get smartCoachClearChat;

  /// No description provided for @smartCoachClearChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear this conversation?'**
  String get smartCoachClearChatConfirm;

  /// No description provided for @smartCoachClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get smartCoachClear;

  /// No description provided for @smartCoachCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get smartCoachCancel;

  /// No description provided for @smartCoachTokenWarning.
  ///
  /// In en, this message translates to:
  /// **'Conversation approaching memory limit ({tokens}/3000 tokens). Start a new chat soon.'**
  String smartCoachTokenWarning(int tokens);

  /// No description provided for @smartCoachTokenLocked.
  ///
  /// In en, this message translates to:
  /// **'This conversation reached the 3000-token limit. Please start a new chat to continue.'**
  String get smartCoachTokenLocked;

  /// No description provided for @smartCoachStartNewChat.
  ///
  /// In en, this message translates to:
  /// **'Start New Chat'**
  String get smartCoachStartNewChat;

  /// No description provided for @smartCoachPreviousConversations.
  ///
  /// In en, this message translates to:
  /// **'Previous Conversations'**
  String get smartCoachPreviousConversations;

  /// No description provided for @smartCoachNoPreviousChats.
  ///
  /// In en, this message translates to:
  /// **'No previous chats'**
  String get smartCoachNoPreviousChats;

  /// No description provided for @smartCoachEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'How can I help you today?'**
  String get smartCoachEmptyTitle;

  /// No description provided for @smartCoachEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask me about custom workout routines, diet macros, or form checks.'**
  String get smartCoachEmptySubtitle;

  /// No description provided for @smartCoachPromptWorkout.
  ///
  /// In en, this message translates to:
  /// **'🏋️ Design a 3-day workout split'**
  String get smartCoachPromptWorkout;

  /// No description provided for @smartCoachPromptNutrition.
  ///
  /// In en, this message translates to:
  /// **'🥗 High protein meal ideas'**
  String get smartCoachPromptNutrition;

  /// No description provided for @smartCoachPromptForm.
  ///
  /// In en, this message translates to:
  /// **'🔥 How to fix my squat form?'**
  String get smartCoachPromptForm;

  /// No description provided for @smartCoachDeleteChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation?'**
  String get smartCoachDeleteChatTitle;

  /// No description provided for @smartCoachDeleteChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat? This action cannot be undone.'**
  String get smartCoachDeleteChatConfirm;

  /// No description provided for @smartCoachDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get smartCoachDelete;

  /// No description provided for @letsStartYourDay.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start Your Day'**
  String get letsStartYourDay;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @fitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get fitness;

  /// No description provided for @yoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get yoga;

  /// No description provided for @aerobics.
  ///
  /// In en, this message translates to:
  /// **'Aerobics'**
  String get aerobics;

  /// No description provided for @trainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get trainer;

  /// No description provided for @recommendationToday.
  ///
  /// In en, this message translates to:
  /// **'Recommendation To Day'**
  String get recommendationToday;

  /// No description provided for @jogging.
  ///
  /// In en, this message translates to:
  /// **'Jogging'**
  String get jogging;

  /// No description provided for @pushUp.
  ///
  /// In en, this message translates to:
  /// **'Push-Up'**
  String get pushUp;

  /// No description provided for @squat.
  ///
  /// In en, this message translates to:
  /// **'Squat'**
  String get squat;

  /// No description provided for @upcomingWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Workouts'**
  String get upcomingWorkouts;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @fullBody.
  ///
  /// In en, this message translates to:
  /// **'Full Body'**
  String get fullBody;

  /// No description provided for @chest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get chest;

  /// No description provided for @arm.
  ///
  /// In en, this message translates to:
  /// **'Arm'**
  String get arm;

  /// No description provided for @shoulder.
  ///
  /// In en, this message translates to:
  /// **'Shoulder'**
  String get shoulder;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @legs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get legs;

  /// No description provided for @arms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get arms;

  /// No description provided for @recommendationForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommendation For You'**
  String get recommendationForYou;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @popularTraining.
  ///
  /// In en, this message translates to:
  /// **'Popular Training'**
  String get popularTraining;

  /// No description provided for @exercisesThatStrengthenYourChest.
  ///
  /// In en, this message translates to:
  /// **'Exercises That Strengthen Your Chest'**
  String get exercisesThatStrengthenYourChest;

  /// No description provided for @exercisesThatStrengthenYourBack.
  ///
  /// In en, this message translates to:
  /// **'Exercises That Strengthen Your Back'**
  String get exercisesThatStrengthenYourBack;

  /// Task count
  ///
  /// In en, this message translates to:
  /// **'{count} Tasks'**
  String tasksCount(int count);

  /// No description provided for @foodRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Food Recommendation'**
  String get foodRecommendation;

  /// No description provided for @noMealsFound.
  ///
  /// In en, this message translates to:
  /// **'No meals found'**
  String get noMealsFound;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @failedToLoadMeals.
  ///
  /// In en, this message translates to:
  /// **'Failed to load meals'**
  String get failedToLoadMeals;

  /// No description provided for @foodDetails.
  ///
  /// In en, this message translates to:
  /// **'Food Details'**
  String get foodDetails;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @failedToLoadMealDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load meal details'**
  String get failedToLoadMealDetails;

  /// No description provided for @playVideo.
  ///
  /// In en, this message translates to:
  /// **'Play Video'**
  String get playVideo;

  /// No description provided for @noIngredientsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No ingredients available'**
  String get noIngredientsAvailable;

  /// Exercise duration in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} Min'**
  String durationMinutes(int minutes);

  /// Exercise calories
  ///
  /// In en, this message translates to:
  /// **'{calories} Cal'**
  String calories(int calories);

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @failedToLoadExercises.
  ///
  /// In en, this message translates to:
  /// **'Failed to load exercises'**
  String get failedToLoadExercises;

  /// No description provided for @noExercisesFound.
  ///
  /// In en, this message translates to:
  /// **'No exercises found'**
  String get noExercisesFound;

  /// No description provided for @chestExercise.
  ///
  /// In en, this message translates to:
  /// **'Chest Exercise'**
  String get chestExercise;

  /// No description provided for @exerciseDescription.
  ///
  /// In en, this message translates to:
  /// **'Start your fitness journey with chest exercises.'**
  String get exerciseDescription;
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
