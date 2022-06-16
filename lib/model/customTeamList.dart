import 'package:constructin/model/team_model.dart';

class CustomTeamList {
  TeamData teamDataList;

  bool isChecked;

  CustomTeamList({
    required this.teamDataList,
    this.isChecked = false,
  });
}
