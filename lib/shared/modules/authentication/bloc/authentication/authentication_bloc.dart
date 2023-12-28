import 'package:bloc/bloc.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/current_user_data.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/resources/authentication_repository.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_state.dart';

import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/token.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/user_data.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationService =
      AuthenticationRepository();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AppLoadedup>(_mapAppSignUpLoadedState);
    on<UserSignUp>(_mapUserSignupToState);
    on<UserLogin>(_mapUserLoginState);
    on<UserLogOut>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      sharedPreferences.clear();
      await ApiSdk().logout();
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
      // a simulated delay
      await Future.delayed(const Duration(milliseconds: 500));
      await ApiSdk().initializeAsync();

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
}
