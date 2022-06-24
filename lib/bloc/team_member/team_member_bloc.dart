import 'package:bloc/bloc.dart';
import 'package:constructin/utils/api_services.dart';
import 'package:equatable/equatable.dart';

import '../../model/team_model.dart';

part 'team_member_event.dart';

part 'team_member_state.dart';

class TeamMemberBloc extends Bloc<TeamMemberEvent, TeamMemberState> {
  TeamMemberBloc() : super(TeamMemberInitial()) {
    on<TeamMemberPressed>((event, emit) async {
      emit(TeamMemberLoading());
      try {
        TeamModel teamModel = await ApiServices.getTeamMemberList(event.projectId);
        emit(TeamMemberSuccess(teamModel: teamModel));
      } catch (e) {
        emit(TeamMemberFailure(error: e.toString()));
      }
    });
  }
}
