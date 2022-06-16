part of 'team_member_list_bloc.dart';

abstract class TeamMemberListState extends Equatable {
  const TeamMemberListState();
}

class TeamMemberListInitial extends TeamMemberListState {
  @override
  List<Object> get props => [];
}
class TeamMemberListLoading extends TeamMemberListState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TeamMemberListSuccess extends TeamMemberListState {
  TeamModel? teamModel;

  TeamMemberListSuccess({this.teamModel});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class TeamMemberListFailure extends TeamMemberListState {
  final String error;

  const TeamMemberListFailure({required this.error});

  @override
  List<Object> get props => [error];
}
