import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState, BaseEvent> {
  final HomeRepo? _homeRepo;

  HomeCubit([this._homeRepo]) : super(const BaseState<HomeData>.initial());

  @override
  void doEvent(Object event) {
    switch (event) {
      case GetHomeDataEvent():
        _onGetHomeData(event);
      default:
        break;
    }
  }

  void _onGetHomeData(GetHomeDataEvent event) {}
}
