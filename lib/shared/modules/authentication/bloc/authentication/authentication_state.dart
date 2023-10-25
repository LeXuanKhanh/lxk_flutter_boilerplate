import 'package:equatable/equatable.dart';
import '/shared/modules/authentication/models/current_user_data.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AppAutheticated extends AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationStart extends AuthenticationState {}

class AuthenticationShowTokenExpiredDialog extends AuthenticationState {}

class UserLogoutState extends AuthenticationState {}

class SetUserData extends AuthenticationState {
  final CurrentUserData currentUserData;
  const SetUserData({required this.currentUserData});
  @override
  List<Object> get props => [currentUserData];
}

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  const AuthenticationFailure({this.message = ''});

  @override
  List<Object> get props => [message];
}
