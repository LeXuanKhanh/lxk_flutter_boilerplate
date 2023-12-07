import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:lxk_flutter_boilerplate/src/app.dart';
import 'package:lxk_flutter_boilerplate/src/third_parties/github_sign_in/github_sign_in.dart';
import 'package:lxk_flutter_boilerplate/src/third_parties/github_sign_in/github_sign_in_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/current_user_data.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/resources/authentication_repository.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_state.dart';

import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/token.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/user_data.dart';
import 'package:lxk_flutter_boilerplate/config_env.dart' as config;

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationService =
      AuthenticationRepository();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AppLoadedup>(_mapAppSignUpLoadedState);
    on<UserSignUp>(_mapUserSignupToState);
    on<UserLogin>(_mapUserLoginState);
    on<GithubLogin>(_githubLogin);
    on<UserLogOut>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      sharedPreferences.clear();
      emit(UserLogoutState());
    });
    on<UserTokenExpired>((event, emit) async {
      emit(AuthenticationShowTokenExpiredDialog());
    });
    on<GetUserData>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      int? currentUserId = sharedPreferences.getInt('userId');
      final data = await authenticationService.getUserData(currentUserId ?? 4);
      final currentUserData = CurrentUserData.fromJson(data);
      emit(SetUserData(currentUserData: currentUserData));
    });
  }

  void _mapAppSignUpLoadedState(
      AppLoadedup event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // a simulated delay
      final SharedPreferences sharedPreferences = await prefs;
      if (sharedPreferences.getString('authtoken') != null) {
        emit(AppAutheticated());
      } else {
        emit(AuthenticationStart());
      }
    } catch (e) {
      emit(AuthenticationFailure(
          message: e.toString()));
    }
  }

  void _mapUserLoginState(
      UserLogin event, Emitter<AuthenticationState> emit) async {
    final SharedPreferences sharedPreferences = await prefs;
    emit(AuthenticationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // a simulated delay
      final data = await authenticationService.loginWithEmailAndPassword(
          event.email, event.password);
      if (data["error"] == null) {
        final currentUser = Token.fromJson(data);
        if (currentUser != null) {
          sharedPreferences.setString('authtoken', currentUser.token);
          emit(AppAutheticated());
        } else {
          emit(AuthenticationNotAuthenticated());
        }
      } else {
        emit(AuthenticationFailure(message: data["error"]));
      }
    } catch (e) {
      emit(AuthenticationFailure(
          message: e.toString()));
    }
  }

  void _mapUserSignupToState(
      UserSignUp event, Emitter<AuthenticationState> emit) async {
    final SharedPreferences sharedPreferences = await prefs;
    emit(AuthenticationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // a simulated delay
      final data = await authenticationService.signUpWithEmailAndPassword(
          event.email, event.password);

      if (data["error"] == null) {
        final currentUser = UserData.fromJson(data);
        if (currentUser != null) {
          sharedPreferences.setString('authtoken', currentUser.token);
          sharedPreferences.setInt('userId', currentUser.id);
          emit(AppAutheticated());
        } else {
          emit(AuthenticationNotAuthenticated());
        }
      } else {
        emit(AuthenticationFailure(message: data["error"]));
      }
    } catch (e) {
      emit(AuthenticationFailure(
          message: e.toString()));
    }
  }

  void _githubLogin(GithubLogin event, Emitter<AuthenticationState> emit) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: config.GITHUB_CLIENT_ID,
        clientSecret: config.GITHUB_CLIENT_SECRET,
        redirectUrl: config.GITHUB_REDIRECT_URI,
        title: 'Login with Github');
    final result = await gitHubSignIn.signIn(globalContext);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        debugPrint(result.token);
        break;

      case GitHubSignInResultStatus.cancelled:
      case GitHubSignInResultStatus.failed:
        debugPrint(result.errorMessage);
        break;
    }
  }
}
