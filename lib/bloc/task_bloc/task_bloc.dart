import 'package:bloc/bloc.dart';
import 'package:constructin/utils/api_services.dart';
import 'package:equatable/equatable.dart';

import '../../model/task_model.dart';

part 'task_event.dart';

part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<TaskPressed>((event, emit) async {
      emit(TaskLoading());
      try {
        TaskModel taskModel = await ApiServices.getTaskList(event.projectId);
        emit(TaskSuccess(taskModel: taskModel));
      } catch (e) {
        emit(TaskFailure(error: e.toString()));
      }
    });
  }
}
