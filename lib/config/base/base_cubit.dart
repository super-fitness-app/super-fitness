import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';

abstract class BaseCubit<State, E extends BaseEvent> extends Cubit<State> {
  BaseCubit(super.initialState);

  final StreamController<E> _eventController = StreamController<E>.broadcast();

  Stream<E> get eventStream => _eventController.stream;

  void doEvent(Object event);

  void emitEvent(E event) {
    if (_eventController.isClosed) {
      throw StateError('Cannot emit new events after calling close');
    }
    _eventController.add(event);
  }

  @override
  Future<void> close() {
    _eventController.close();
    return super.close();
  }
}
