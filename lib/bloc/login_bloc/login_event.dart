import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String? countryCode;
  final String? mobile;
  final int? type;
  final String? deviceId;

  const LoginButtonPressed(
      {required this.countryCode,
      required this.mobile,
      required this.type,
      required this.deviceId});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
