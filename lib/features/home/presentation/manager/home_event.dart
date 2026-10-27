part of 'home_cubit.dart';

abstract base class HomeEvent extends FeatureEvent {
  const HomeEvent();
}

final class GetHomeDataEvent extends HomeEvent {
  const GetHomeDataEvent();
}

