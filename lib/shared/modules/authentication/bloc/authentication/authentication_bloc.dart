import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_state.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/resources/authentication_repository.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import 'package:lxk_flutter_boilerplate/src/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationService =
      AuthenticationRepository();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  AuthenticationBloc() : super(const AuthenticationState()) {
    on<AppLoadedup>(_mapAppSignUpLoadedState);
    on<UserSignUp>(_mapUserSignupToState);
    on<UserLogin>(_mapUserLoginState);
    on<UserLogOut>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      sharedPreferences.clear();
      if (globalContext.mounted) {
        globalContext.read<GithubRepoBloc>().add(GithubLogOut());
      }
      emit(state.copyWith(status: AuthenticationStatus.logout));
    });
    on<UserTokenExpired>((event, emit) async {
      emit(state.copyWith(status: AuthenticationStatus.tokenExpired));
    });
    on<GetUserData>((event, emit) async {
      emit(state.toStateLoading());
      final SharedPreferences sharedPreferences = await prefs;
      int? currentUserId = sharedPreferences.getInt('userId');
      if (currentUserId != null) {
        final data = await authenticationService.getUserData(currentUserId);
        emit(state.copyWith(
            status: AuthenticationStatus.newUserData, userData: data));
      } else {
        emit(state.toStateError(message: 'User ID not found'));
      }
    });
  }

  void _mapAppSignUpLoadedState(
      AppLoadedup event, Emitter<AuthenticationState> emit) async {
    emit(state.toStateLoading());
    try {
      // a simulated delay
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiSdk().initializeAsync();

      final SharedPreferences sharedPreferences = await prefs;
      if (sharedPreferences.getString('authtoken') != null) {
        emit(state.copyWith(status: AuthenticationStatus.authenticated));
      } else {
        emit(state.copyWith(status: AuthenticationStatus.notLogin));
      }
    } catch (e) {
      emit(state.toStateError(message: e.toString()));
    }
  }

  void _mapUserLoginState(
      UserLogin event, Emitter<AuthenticationState> emit) async {
    final SharedPreferences sharedPreferences = await prefs;
    emit(state.toStateLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // a simulated delay
      final userData = await authenticationService.loginWithEmailAndPassword(
          event.email, event.password);
      sharedPreferences.setString('authtoken', userData.token);
      sharedPreferences.setInt('userId', 4);
      emit(state.copyWith(status: AuthenticationStatus.authenticated));
    } catch (e) {
      emit(state.toStateError(message: e.toString()));
    }
  }

  void _mapUserSignupToState(
      UserSignUp event, Emitter<AuthenticationState> emit) async {
    final SharedPreferences sharedPreferences = await prefs;
    emit(state.toStateLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // a simulated delay
      final userData = await authenticationService.signUpWithEmailAndPassword(
          event.email, event.password);
      sharedPreferences.setString('authtoken', userData.token);
      sharedPreferences.setInt('userId', 4);
      emit(state.copyWith(status: AuthenticationStatus.authenticated));
    } catch (e) {
      emit(state.toStateError(message: e.toString()));
    }
  }
}
