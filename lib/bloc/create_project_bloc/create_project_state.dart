part of 'create_project_bloc.dart';

abstract class CreateProjectState extends Equatable {
  const CreateProjectState();
}

class CreateProjectInitial extends CreateProjectState {
  @override
  List<Object> get props => [];
}

class CreateProjectLoading extends CreateProjectState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CreateProjectSuccess extends CreateProjectState {
  ProjectDetail? projectDetail;

  CreateProjectSuccess({this.projectDetail});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CreateProjectFailure extends CreateProjectState {
  final String error;

  const CreateProjectFailure({required this.error});

  @override
  List<Object> get props => [error];
}
