import 'package:equatable/equatable.dart';

sealed class MainLayoutIntent extends Equatable {
  const MainLayoutIntent();

  @override
  List<Object?> get props => [];
}

final class ChangeTabIntent extends MainLayoutIntent {
  final int targetIndex;

  const ChangeTabIntent(this.targetIndex);

  @override
  List<Object?> get props => [targetIndex];
}
