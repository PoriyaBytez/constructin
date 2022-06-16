part of 'team_member_bloc.dart';

abstract class TeamMemberState extends Equatable {
  const TeamMemberState();
}

class TeamMemberInitial extends TeamMemberState {
  @override
  List<Object> get props => [];
}
class TeamMemberLoading extends TeamMemberState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TeamMemberSuccess extends TeamMemberState {
  TeamModel? teamModel;

  TeamMemberSuccess({this.teamModel});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TeamMemberFailure extends TeamMemberState {
  final String error;

  const TeamMemberFailure({required this.error});

  @override
  List<Object> get props => [error];
}