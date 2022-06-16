part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
}

class TaskPressed extends TaskEvent {
  int projectId;

  TaskPressed({required this.projectId});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
