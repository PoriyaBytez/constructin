part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();
}

class TaskInitial extends TaskState {
  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TaskSuccess extends TaskState {
  TaskModel taskModel;

  TaskSuccess({required this.taskModel});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TaskFailure extends TaskState {
  final String error;

  const TaskFailure({required this.error});

  @override
  List<Object> get props => [error];
}
