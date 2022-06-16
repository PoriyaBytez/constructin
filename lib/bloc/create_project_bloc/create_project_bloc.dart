import 'package:bloc/bloc.dart';
import 'package:constructin/utils/api_services.dart';
import 'package:equatable/equatable.dart';

import '../../model/project_model.dart';

part 'create_project_event.dart';

part 'create_project_state.dart';


class CreateProjectBloc extends Bloc<CreateProjectEvent, CreateProjectState> {
  CreateProjectBloc() : super(CreateProjectInitial()) {
    on<CreateProjectButtonPressed>((event, emit) async {
      emit(CreateProjectLoading());
      try {
        ProjectDetail projectDetail =
            await ApiServices.postCreateProject(event.projectDetail!);
        emit(CreateProjectSuccess(projectDetail: projectDetail));
      } catch (e) {
        emit(CreateProjectFailure(error: e.toString()));
      }
    });
  }
}
