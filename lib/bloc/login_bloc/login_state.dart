import 'package:equatable/equatable.dart';

import '../../model/user_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoginSuccess extends LoginState {
  UserModel? userModel;

  LoginSuccess({this.userModel});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}
