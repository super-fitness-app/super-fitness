import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_intent.dart';

@injectable
class MainLayoutCubit extends BaseCubit<BaseState<int>, BaseEvent> {
  static const int tabCount = 4;

  MainLayoutCubit() : super(BaseState.success(0));

  @override
  void doEvent(Object event) {
    switch (event) {
      case ChangeTabIntent(:final targetIndex):
        _onTabChanged(targetIndex);
      case _:
        break;
    }
  }

  void _onTabChanged(int index) {
    if (index >= 0 && index < tabCount && index != (state.data ?? 0)) {
      emit(BaseState.success(index));
    }
  }
}
