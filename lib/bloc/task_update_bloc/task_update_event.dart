part of 'task_update_bloc.dart';

abstract class TaskUpdateEvent extends Equatable {
  const TaskUpdateEvent();
}

class TaskUpdatePressed extends TaskUpdateEvent {
  int taskId;
  String date;

  TaskUpdatePressed({required this.taskId, required this.date});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
