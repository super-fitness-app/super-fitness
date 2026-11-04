import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';

sealed class TestEvent {
  const TestEvent();
}

final class SubmitAction extends TestEvent {
  final String payload;
  const SubmitAction(this.payload);
}

class TestCubit extends BaseCubit<int, BaseEvent> {
  TestCubit() : super(0);

  Object? lastReceivedEvent;

  @override
  void doEvent(Object event) {
    lastReceivedEvent = event;
    if (event is SubmitAction) {
      emit(state + 1);
      emitEvent(DisplaySuccess(event.payload));
    }
  }
}

void main() {
  group('BaseCubit Tests', () {
    late TestCubit cubit;

    setUp(() {
      cubit = TestCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initialState is correct', () {
      expect(cubit.state, 0);
    });

    test('doEvent handles event, updates state and emits UI event', () async {
      final emittedEvents = <BaseEvent>[];
      final subscription = cubit.eventStream.listen(emittedEvents.add);

      cubit.doEvent(const SubmitAction('Item saved'));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.lastReceivedEvent, isA<SubmitAction>());
      expect(cubit.state, 1);
      expect(emittedEvents.length, 1);
      expect(emittedEvents.first, isA<DisplaySuccess>());
      expect((emittedEvents.first as DisplaySuccess).successMsg, 'Item saved');

      await subscription.cancel();
    });

    test('emitEvent throws StateError when cubit is closed', () async {
      await cubit.close();

      expect(
        () => cubit.emitEvent(const DisplaySuccess('After close')),
        throwsStateError,
      );
    });
  });
}
