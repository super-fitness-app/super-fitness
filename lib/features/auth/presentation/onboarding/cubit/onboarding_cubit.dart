import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_intent.dart';

@injectable
class OnboardingCubit extends BaseCubit<BaseState<int>, BaseEvent> {
  final StorageService _storageService;

  OnboardingCubit(this._storageService) : super(BaseState.success(0));

  @override
  void doEvent(Object event) {
    switch (event) {
      case PageChangedIntent(:final pageIndex):
        _onPageChanged(pageIndex);
      case SkipOnboardingIntent():
        _finishOnboarding();
      case CompleteOnboardingIntent():
        _finishOnboarding();
      case _:
        break;
    }
  }

  void _onPageChanged(int index) {
    emit(BaseState.success(index));
  }

  Future<void> _finishOnboarding() async {
    await _storageService.save(AppConstants.hasSeenOnboardingKey, 'true');
    emitEvent(const NavigateEvent(AppRoutes.login));
  }
}
