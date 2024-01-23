import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/user_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'authentication_state.freezed.dart';

enum AuthenticationStatus {
  initial,
  loading,
  notLogin,
  authenticated,
  tokenExpired,
  logout,
  newUserData,
  error,
}

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default(AuthenticationStatus.initial) AuthenticationStatus status,
    @Default('') String message,
    UserInfo? userData,
  }) = _AuthenticationState;

  const AuthenticationState._();

  AuthenticationState toStateLoading() {
    return copyWith(status: AuthenticationStatus.loading);
  }

  AuthenticationState toStateError({String message = ''}) {
    return copyWith(status: AuthenticationStatus.error, message: message);
  }
}
