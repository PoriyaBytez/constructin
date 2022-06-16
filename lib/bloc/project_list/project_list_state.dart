part of 'project_list_bloc.dart';

abstract class ProjectListState extends Equatable {
  const ProjectListState();
}

class ProjectListInitial extends ProjectListState {
  @override
  List<Object> get props => [];
}

class ProjectListLoading extends ProjectListState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ProjectListSuccess extends ProjectListState {
  ProjectModel? projectModel;

  ProjectListSuccess({this.projectModel});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ProjectListFailure extends ProjectListState {
  final String error;

  const ProjectListFailure({required this.error});

  @override
  List<Object> get props => [error];
}
