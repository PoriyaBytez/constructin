import 'package:bloc/bloc.dart';
import 'package:constructin/utils/api_services.dart';
import 'package:equatable/equatable.dart';

import '../../model/project_model.dart';

part 'project_list_event.dart';

part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  ProjectListBloc() : super(ProjectListInitial()) {
    on<ProjectListPressed>((event, emit) async {
      emit(ProjectListLoading());
      try {
        ProjectModel? projectModel = await ApiServices.getProjectList();
        print("projectModelsuccess : ${projectModel}");
        emit(ProjectListSuccess(projectModel: projectModel));
      } catch (e) {
        print("projectModelsuccess e: ${e.toString}");
        emit(ProjectListFailure(error: (e.toString())));
      }
    });
  }
}
