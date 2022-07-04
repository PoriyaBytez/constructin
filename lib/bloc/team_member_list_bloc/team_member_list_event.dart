part of 'team_member_list_bloc.dart';

abstract class TeamMemberListEvent extends Equatable {
  const TeamMemberListEvent();
}

class TeamMemberListPressed extends TeamMemberListEvent {
  int projectId, projectRights;

  TeamMemberListPressed(this.projectRights, this.projectId);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
