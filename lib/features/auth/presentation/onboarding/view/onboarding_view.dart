import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_intent.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/models/onboarding_item_model.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_background.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_character_section.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_content.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_top_bar.dart';

class OnboardingView extends StatefulWidget {
  final OnboardingCubit? cubit;

  const OnboardingView({super.key, this.cubit});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with BaseViewMixin<OnboardingView, OnboardingCubit, BaseEvent> {
  late final OnboardingCubit _cubit;
  late final PageController _pageController;

  static final List<OnboardingItemModel> _items = [
    OnboardingItemModel(
      image: AppImages.onboarding1,
      titleBuilder: (l10n) => l10n.onboardingTitle1,
      subtitleBuilder: (l10n) => l10n.onboardingSubtitle1,
    ),
    OnboardingItemModel(
      image: AppImages.onboarding2,
      titleBuilder: (l10n) => l10n.onboardingTitle2,
      subtitleBuilder: (l10n) => l10n.onboardingSubtitle2,
    ),
    OnboardingItemModel(
      image: AppImages.onboarding3,
      titleBuilder: (l10n) => l10n.onboardingTitle3,
      subtitleBuilder: (l10n) => l10n.onboardingSubtitle3,
    ),
  ];

  @override
  OnboardingCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? _resolveCubit();
    _pageController = PageController();
    super.initState();
  }

  OnboardingCubit _resolveCubit() {
    if (getIt.isRegistered<OnboardingCubit>()) {
      return getIt<OnboardingCubit>();
    }
    final storage = getIt.isRegistered<StorageService>()
        ? getIt<StorageService>()
        : _FallbackStorageService();
    return OnboardingCubit(storage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    if (widget.cubit == null) {
      _cubit.close();
    }
    super.dispose();
  }

  void _nextPage() {
    final currentIndex = _cubit.state.data ?? 0;
    if (currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    final currentIndex = _cubit.state.data ?? 0;
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OnboardingCubit, BaseState<int>>(
      bloc: cubit,
      builder: (context, state) {
        final currentIndex = state.data ?? 0;
        final currentItem = _items[currentIndex];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              const OnboardingBackground(),
              OnboardingCharacterSection(
                imagePath: currentItem.image,
                index: currentIndex,
              ),
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) =>
                    cubit.doEvent(PageChangedIntent(index)),
                itemCount: _items.length,
                itemBuilder: (context, index) => const SizedBox.expand(),
              ),
              if (currentIndex != _items.length - 1)
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: OnboardingTopBar(
                    onSkip: () => cubit.doEvent(const SkipOnboardingIntent()),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: OnboardingContent(
                  title: currentItem.getTitle(l10n),
                  subtitle: currentItem.getSubtitle(l10n),
                  currentIndex: currentIndex,
                  totalPages: _items.length,
                  onNext: _nextPage,
                  onBack: _previousPage,
                  onFinish: () =>
                      cubit.doEvent(const CompleteOnboardingIntent()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FallbackStorageService implements StorageService {
  @override
  Future<void> save(String key, String value) async {}
  @override
  Future<String> get(String key) async => '';
  @override
  Future<void> delete(String key) async {}
}
