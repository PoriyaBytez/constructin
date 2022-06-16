part of 'team_member_bloc.dart';

abstract class TeamMemberEvent extends Equatable {
  const TeamMemberEvent();
}

class TeamMemberPressed extends TeamMemberEvent {
  int projectId, projectRights;

  TeamMemberPressed(this.projectRights, this.projectId);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
