part of 'create_project_bloc.dart';

abstract class CreateProjectEvent extends Equatable {
  const CreateProjectEvent();
}

class CreateProjectButtonPressed extends CreateProjectEvent {
  final ProjectDetail? projectDetail;

  const CreateProjectButtonPressed({required this.projectDetail});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
