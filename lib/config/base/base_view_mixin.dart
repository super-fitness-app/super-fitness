import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/extensions/app_failure_extension.dart';

mixin BaseViewMixin<
  T extends StatefulWidget,
  C extends BaseCubit<dynamic, E>,
  E extends BaseEvent
>
    on State<T> {
  StreamSubscription<E>? _eventSubscription;

  C get cubit;

  @override
  void initState() {
    super.initState();
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _eventSubscription = cubit.eventStream.listen((event) {
      if (!mounted) return;
      _handleEvent(event);
    });
  }

  void _handleEvent(E event) {
    switch (event) {
      case DisplayError(:final errorMsg, :final failure):
        final message = failure?.toLocalizedMessage(context) ?? errorMsg;
        if (message != null && message.isNotEmpty) {
          showErrorSnackBar(message);
        }
      case DisplaySuccess(:final successMsg):
        showSuccessSnackBar(successMsg);
      case NavigateEvent(:final routeName, :final extra):
        context.push(routeName, extra: extra);

      case _:
        onCustomEvent(event);
    }
  }

  void onCustomEvent(E event) {}

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }
}
