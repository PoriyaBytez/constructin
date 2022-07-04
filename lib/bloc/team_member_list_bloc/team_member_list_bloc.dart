import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/team_model.dart';
import '../../utils/api_services.dart';

part 'team_member_list_event.dart';

part 'team_member_list_state.dart';

class TeamMemberListBloc
    extends Bloc<TeamMemberListEvent, TeamMemberListState> {
  TeamMemberListBloc() : super(TeamMemberListInitial()) {
    on<TeamMemberListPressed>((event, emit) async {
      emit(TeamMemberListLoading());
      try {
        TeamModel teamModel =
            await ApiServices.getTeamMemberList(event.projectId);
        emit(TeamMemberListSuccess(teamModel: teamModel));
      } catch (e) {
        emit(TeamMemberListFailure(error: e.toString()));
      }
    });
  }
}
