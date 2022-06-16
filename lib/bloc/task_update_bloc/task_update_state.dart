part of 'task_update_bloc.dart';

abstract class TaskUpdateState extends Equatable {
  const TaskUpdateState();
}

class TaskUpdateInitial extends TaskUpdateState {
  @override
  List<Object> get props => [];
}

class TaskUpdateLoading extends TaskUpdateState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TaskUpdateSuccess extends TaskUpdateState {
  dynamic taskDate;

  TaskUpdateSuccess({required this.taskDate});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TaskUpdateFailure extends TaskUpdateState {
  final String error;

  const TaskUpdateFailure({required this.error});

  @override
  List<Object> get props => [error];
}
