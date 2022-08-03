import 'package:bloc/bloc.dart';
import 'package:constructin/utils/api_services.dart';
import 'package:equatable/equatable.dart';

part 'task_update_event.dart';

part 'task_update_state.dart';

class TaskUpdateBloc extends Bloc<TaskUpdateEvent, TaskUpdateState> {
  TaskUpdateBloc() : super(TaskUpdateInitial()) {
    on<TaskUpdatePressed>((event, emit) async {
      emit(TaskUpdateLoading());
      try {
        dynamic data = await ApiServices.getDetails(event.taskId, event.date);
        emit(TaskUpdateSuccess(taskDate: data));
      } catch (e) {
        emit(TaskUpdateFailure(error: e.toString()));
      }
    });
  }
}
