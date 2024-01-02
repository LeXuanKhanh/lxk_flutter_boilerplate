import 'package:bloc/bloc.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/resources/github_repo_resouces.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_state.dart';
import 'package:flutter/widgets.dart';
import 'package:lxk_flutter_boilerplate/src/app.dart';
import 'package:lxk_flutter_boilerplate/src/third_parties/github_sign_in/github_sign_in.dart';
import 'package:lxk_flutter_boilerplate/src/third_parties/github_sign_in/github_sign_in_result.dart';
import 'package:lxk_flutter_boilerplate/config_env.dart' as config;

class GithubRepoBloc extends Bloc<GithubRepoEvent, GithubRepoState> {
  GithubRepoBloc() : super(const GithubRepoState()) {
    on<GithubRepoDataLoadingEvent>(onGithubRepoDataLoadingEvent);
    on<GithubConnect>(onGithubConnectEvent);
    on<GithubLogOut>(onGithubLogOut);
    on<GithubGetUserInfo>(onGithubGetUserInfo);
  }

  onGithubRepoDataLoadingEvent(
      GithubRepoDataLoadingEvent event, Emitter<GithubRepoState> emit) async {
    // ignore: unnecessary_type_check
    if (event is GithubRepoDataLoadingEvent) {
      emit(state.toStateLoading());
      try {
        final fetchedData = await GithubRepoResources.getData();
        emit(state.copyWith(
            status: GithubStatus.dataLoaded, repositoryData: fetchedData));
      } catch (e, stackTrace) {
        debugPrintStack(label: e.toString(), stackTrace: stackTrace);
        emit(state.toStateError(message: e.toString()));
      }
    }
  }

  onGithubConnectEvent(
      GithubConnect event, Emitter<GithubRepoState> emit) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: config.GITHUB_CLIENT_ID,
        clientSecret: config.GITHUB_CLIENT_SECRET,
        redirectUrl: config.GITHUB_REDIRECT_URI,
        title: 'Login with Github');
    final result = await gitHubSignIn.signIn(globalContext);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        debugPrint(result.token);
        emit(state.toStateLoading());
        await Future.delayed(const Duration(milliseconds: 500));

        if (result.token == null || result.token!.isEmpty) {
          emit(state.toStateError(message: 'github token not found'));
          return;
        }

        await ApiSdk().updateGitHubToken(token: result.token!);
        emit(state.copyWith(status: GithubStatus.connected));
        add(GithubGetUserInfo());
        add(GithubRepoDataLoadingEvent());
        break;

      case GitHubSignInResultStatus.cancelled:
      case GitHubSignInResultStatus.failed:
        emit(state.toStateError(message: 'failed to get token from github'));
        break;
    }
  }

  onGithubGetUserInfo(
      GithubGetUserInfo event, Emitter<GithubRepoState> emit) async {
    emit(state.toStateLoading());
    try {
      final data = await GithubRepoResources.getUserInfo();
      emit(state.copyWith(
          status: GithubStatus.userDataLoaded, userData: data));
    } catch (e, stackTrace) {
      debugPrintStack(label: e.toString(), stackTrace: stackTrace);
      emit(state.toStateError(message: e.toString()));
    }
  }

  onGithubLogOut(GithubLogOut event, Emitter<GithubRepoState> emit) async {
    emit(state.toStateLoading());
    await ApiSdk().resetGithubToken();
    emit(const GithubRepoState());
  }
}
