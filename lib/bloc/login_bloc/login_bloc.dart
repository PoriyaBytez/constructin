import 'package:bloc/bloc.dart';
import 'package:constructin/utils/api_services.dart';

import '../../model/user_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        UserModel userModel = await ApiServices.loginUser(
            event.countryCode, event.mobile, event.type, event.deviceId);
        emit(LoginSuccess(userModel: userModel));
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
