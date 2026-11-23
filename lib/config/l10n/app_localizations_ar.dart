// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سوبر فيتنس';

  @override
  String get emptyValidationError => 'هذا الحقل مطلوب';

  @override
  String get invalidEmailError => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get invalidPhoneError => 'يرجى إدخال رقم هاتف مصري صحيح';

  @override
  String get nationalIdError => 'يرجى إدخال رقم قومي صحيح';

  @override
  String get weakPasswordError => 'كلمة المرور ضعيفة جداً';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get passwordMustContainUppercase =>
      'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';

  @override
  String get passwordMustContainLowercase =>
      'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل';

  @override
  String get passwordMustContainNumber =>
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';

  @override
  String get passwordMustContainSpecialCharacter =>
      'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل';

  @override
  String get passwordMismatchError => 'كلمتا المرور غير متطابقتين';

  @override
  String get fileRequiredError => 'يرجى رفع الملف المطلوب';

  @override
  String get dropdownRequiredError => 'يرجى اختيار أحد الخيارات';

  @override
  String get generalValidationError => 'إدخال غير صحيح';

  @override
  String get invalidLoginPasswordError =>
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل وتحتوي على حرف كبير ورقم';

  @override
  String get generalErrorMessage =>
      'حدث خطأ ما. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get connectionErrorMessage =>
      'انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get noConnectionErrorMessage =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';

  @override
  String get securityErrorMessage => 'تعذر إنشاء اتصال آمن.';

  @override
  String get cancelErrorMessage => 'تم إلغاء الطلب.';

  @override
  String get code400Message =>
      'طلب غير صالح. يرجى التحقق من بياناتك والمحاولة مرة أخرى.';

  @override
  String get code401Message =>
      'انتهت الجلسة أو بيانات الاعتماد غير صالحة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get code403Message => 'ليس لديك إذن لتنفيذ هذا الإجراء.';

  @override
  String get code404Message => 'المورد المطلوب غير موجود.';

  @override
  String get code409Message => 'الحساب أو المورد موجود بالفعل.';

  @override
  String get code422Message => 'خطأ في التحقق. يرجى التأكد من المدخلات.';

  @override
  String get code429Message =>
      'طلبات كثيرة جداً. يرجى الانتظار لحظة والمحاولة مرة أخرى.';

  @override
  String get code500sMessage =>
      'خطأ في الخادم. يرجى المحاولة مرة أخرى بعد قليل.';

  @override
  String get loginTitle => 'مرحباً بعودتك!';

  @override
  String get alreadyHaveAnAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingBack => 'رجوع';

  @override
  String get onboardingDoIt => 'ابدأ الآن';

  @override
  String get onboardingTitle1 => 'ثمن التميز\nهو الانضباط';

  @override
  String get onboardingSubtitle1 =>
      'النجاح يبدأ بالالتزام اليومي. حافظ على استمرارك وتجاوز حدودك لتحقيق أفضل أداء.';

  @override
  String get onboardingTitle2 => 'اللياقة لم تكن أبداً\nبهذا القدر من المتعة';

  @override
  String get onboardingSubtitle2 =>
      'حوّل تمارينك إلى رحلة ممتعة مع تحديات ملهمة وروتين يحافظ على حماسك.';

  @override
  String get onboardingTitle3 => 'لا مزيد من الأعذار\nابدأ اليوم';

  @override
  String get onboardingSubtitle3 =>
      'لا تنتظر اللحظة المثالية. اتخذ الخطوة اليوم، وتجاوز العقبات، واصنع المستقبل الذي تستحقه.';

  @override
  String get explore => 'استكشف';

  @override
  String get smartCoach => 'المدرب الذكي';

  @override
  String get workouts => 'التمارين';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get heyThere => 'مرحباً';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب بعد؟';

  @override
  String get createAnAccount => 'إنشاء حساب';

  @override
  String get register => 'تسجيل';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get lastNameRequired => 'اسم العائلة مطلوب';

  @override
  String get passwordMinLength =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get or => 'أو';

  @override
  String get forgetPassword => 'نسيت كلمة المرور';

  @override
  String get registeredSuccessfully => 'تم التسجيل بنجاح';

  @override
  String get missingRegistrationData =>
      'يرجى إكمال جميع بيانات التسجيل المطلوبة';

  @override
  String get googleAccountIdMissing =>
      'معرف حساب Google مفقود. يرجى المحاولة مرة أخرى.';

  @override
  String get googleAccountConnected => 'تم ربط حساب Google. أكمل ملفك الشخصي.';

  @override
  String get facebookAccountIdMissing =>
      'معرف حساب Facebook مفقود. يرجى المحاولة مرة أخرى.';

  @override
  String get facebookAccountConnected =>
      'تم ربط حساب Facebook. أكمل ملفك الشخصي.';

  @override
  String get accountNotFoundRegisterFirst =>
      'الحساب غير موجود. يرجى إنشاء حساب أولاً.';

  @override
  String get tellUsAboutYourself => 'أخبرنا عن نفسك!';

  @override
  String get weNeedToKnowYourGender => 'نحتاج إلى معرفة جنسك';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get howOldAreYou => 'كم عمرك؟';

  @override
  String get personalizedPlanSubtitle => 'هذا يساعدنا في إنشاء خطتك المخصصة';

  @override
  String get year => 'سنة';

  @override
  String get whatIsYourWeight => 'ما هو وزنك؟';

  @override
  String get kg => 'كجم';

  @override
  String get whatIsYourHeight => 'ما هو طولك؟';

  @override
  String get cm => 'سم';

  @override
  String get whatIsYourGoal => 'ما هو هدفك؟';

  @override
  String get gainWeight => 'زيادة الوزن';

  @override
  String get loseWeight => 'خسارة الوزن';

  @override
  String get getFitter => 'تحسين اللياقة';

  @override
  String get gainMoreFlexible => 'زيادة المرونة';

  @override
  String get learnTheBasic => 'تعلم الأساسيات';

  @override
  String get activityLevelTitle => 'ما هو مستوى نشاطك\nالبدني المعتاد؟';

  @override
  String get rookie => 'مبتدئ جداً';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advance => 'متقدم';

  @override
  String get trueBeast => 'محترف رياضي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get selectLanguage => 'اختيار اللغة: ';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get security => 'الأمان';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get help => 'المساعدة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get yourWeight => 'وزنك';

  @override
  String get yourGoal => 'هدفك';

  @override
  String get yourActivityLevel => 'مستوى نشاطك';

  @override
  String get tapToEdit => 'اضغط للتعديل';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get kgUnit => 'كجم';

  @override
  String editWeight(String unit) {
    return 'تعديل الوزن ($unit)';
  }

  @override
  String enterWeight(String unit) {
    return 'أدخل الوزن بـ $unit';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get completeRequiredFields => 'يرجى إكمال جميع الحقول المطلوبة.';

  @override
  String get invalidWeight => 'أدخل وزنًا صحيحًا.';

  @override
  String get selectGoal => 'اختر الهدف';

  @override
  String get selectActivityLevel => 'اختر مستوى النشاط';

  @override
  String get maintainWeight => 'الحفاظ على الوزن';

  @override
  String get createNewPassword => 'إنشاء كلمة مرور جديدة';

  @override
  String get makeSurePasswordIs8Characters =>
      'تأكد من أن كلمة المرور 8 أحرف أو أكثر';

  @override
  String get oldPassword => 'كلمة المرور القديمة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordChangedSuccessfully => 'تم تغيير كلمة المرور بنجاح';

  @override
  String smartCoachGreeting(String userName) {
    return 'مرحباً $userName ،';
  }

  @override
  String get hiAhmed => 'مرحباً أحمد ،';

  @override
  String hiWithName(String name) {
    return 'مرحباً $name ،';
  }

  @override
  String get smartCoachSubtitle => 'أنا مدربك الذكي';

  @override
  String get smartCoachWelcomeAssist => 'كيف يمكنني مساعدتك\nاليوم ؟';

  @override
  String get smartCoachGetStarted => 'ابدأ الآن';

  @override
  String get smartCoachInputHint => 'اسألني أي شيء عن اللياقة والتغذية...';

  @override
  String get smartCoachThinking => 'المدرب الذكي يفكر...';

  @override
  String get smartCoachExerciseCardSets => 'المجموعات والتكرارات';

  @override
  String get smartCoachExerciseCardMuscle => 'العضلة المستهدفة';

  @override
  String get smartCoachNutritionCalories => 'السعرات الحرارية';

  @override
  String get smartCoachNutritionProtein => 'البروتين';

  @override
  String get smartCoachNutritionCarbs => 'الكربوهيدرات';

  @override
  String get smartCoachNutritionFat => 'الدهون';

  @override
  String get smartCoachClearChat => 'مسح المحادثة';

  @override
  String get smartCoachClearChatConfirm =>
      'هل أنت متأكد من رغبتك في مسح المحادثة؟';

  @override
  String get smartCoachClear => 'مسح';

  @override
  String get smartCoachCancel => 'إلغاء';

  @override
  String smartCoachTokenWarning(int tokens) {
    return 'المحادثة تقترب من حد الذاكرة ($tokens/3000 رمز). ابدأ محادثة جديدة قريباً.';
  }

  @override
  String get smartCoachTokenLocked =>
      'وصلت هذه المحادثة إلى حد 3000 رمز. يرجى بدء محادثة جديدة للمتابعة.';

  @override
  String get smartCoachStartNewChat => 'محادثة جديدة';

  @override
  String get smartCoachPreviousConversations => 'المحادثات السابقة';

  @override
  String get smartCoachNoPreviousChats => 'لا توجد محادثات سابقة';

  @override
  String get smartCoachEmptyTitle => 'كيف يمكنني مساعدتك اليوم؟';

  @override
  String get smartCoachEmptySubtitle =>
      'اسألني عن جداول التمارين المخصصة، أو الماكروز، أو تصحيح الأداء الحركي.';

  @override
  String get smartCoachPromptWorkout => '🏋️ صمم لي جدول تمارين 3 أيام';

  @override
  String get smartCoachPromptNutrition => '🥗 أفكار لوجبات عالية البروتين';

  @override
  String get smartCoachPromptForm => '🔥 كيف أحسن أداء تمرين الاسكوات؟';

  @override
  String get smartCoachDeleteChatTitle => 'حذف المحادثة؟';

  @override
  String get smartCoachDeleteChatConfirm =>
      'هل أنت متأكد من رغبتك في حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get smartCoachDelete => 'حذف';

  @override
  String get letsStartYourDay => 'لنبدأ يومك';

  @override
  String get category => 'الفئات';

  @override
  String get gym => 'جيم';

  @override
  String get fitness => 'لياقة بدنية';

  @override
  String get yoga => 'يوغا';

  @override
  String get aerobics => 'تمارين هوائية';

  @override
  String get trainer => 'مدرب';

  @override
  String get recommendationToday => 'توصيات اليوم';

  @override
  String get jogging => 'ركض';

  @override
  String get pushUp => 'تمرين الضغط';

  @override
  String get squat => 'سكوات';

  @override
  String get upcomingWorkouts => 'التمارين القادمة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get fullBody => 'كامل الجسم';

  @override
  String get chest => 'الصدر';

  @override
  String get arm => 'الذراع';

  @override
  String get shoulder => 'الكتف';

  @override
  String get back => 'الظهر';

  @override
  String get legs => 'الأرجل';

  @override
  String get arms => 'الذراعين';

  @override
  String get recommendationForYou => 'موصى به لك';

  @override
  String get breakfast => 'فطور';

  @override
  String get lunch => 'غداء';

  @override
  String get dinner => 'عشاء';

  @override
  String get popularTraining => 'التدريبات الشائعة';

  @override
  String get exercisesThatStrengthenYourChest => 'تمارين لتقوية عضلات الصدر';

  @override
  String get exercisesThatStrengthenYourBack => 'تمارين لتقوية عضلات الظهر';

  @override
  String tasksCount(int count) {
    return '$count تمرين';
  }

  @override
  String get foodRecommendation => 'توصيات الطعام';

  @override
  String get noMealsFound => 'لم يتم العثور على وجبات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get failedToLoadMeals => 'فشل في تحميل الوجبات';

  @override
  String get foodDetails => 'تفاصيل الوجبة';

  @override
  String get ingredients => 'المكونات';

  @override
  String get energy => 'طاقة';

  @override
  String get protein => 'بروتين';

  @override
  String get carbs => 'كربوهيدرات';

  @override
  String get fat => 'دهون';

  @override
  String get failedToLoadMealDetails => 'فشل في تحميل تفاصيل الوجبة';

  @override
  String get playVideo => 'تشغيل الفيديو';

  @override
  String get noIngredientsAvailable => 'لا توجد مكونات متوفرة';

  @override
  String durationMinutes(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String calories(int calories) {
    return '$calories سعرة حرارية';
  }

  @override
  String get advanced => 'متقدم';

  @override
  String get failedToLoadExercises => 'فشل تحميل التمارين';

  @override
  String get noExercisesFound => 'لم يتم العثور على تمارين';

  @override
  String get chestExercise => 'تمارين الصدر';

  @override
  String get exerciseDescription => 'ابدأ رحلتك الرياضية مع تمارين الصدر.';
}
