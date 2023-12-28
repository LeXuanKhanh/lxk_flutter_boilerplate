import 'package:bloc/bloc.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/resources/github_repo_resouces.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_state.dart';
import 'package:flutter/widgets.dart';
import 'package:lxk_flutter_boilerplate/src/app.dart';
import 'package:lxk_flutter_boilerplate/src/storage/index.dart';
import 'package:lxk_flutter_boilerplate/src/third_parties/github_sign_in/github_sign_in.dart';
import 'package:lxk_flutter_boilerplate/src/third_parties/github_sign_in/github_sign_in_result.dart';
import 'package:lxk_flutter_boilerplate/config_env.dart' as config;

class GithubRepoBloc extends Bloc<GithubRepoEvent, GithubRepoState> {

  bool get isConnected => ApiSdk().isGithubConnected;

  GithubRepoBloc() : super(GithubRepoStateInitial()) {
    on<GithubRepoDataLoadingEvent>(onGithubRepoDataLoadingEvent);
    on<GithubConnect>(onGithubConnectEvent);
  }

  onGithubRepoDataLoadingEvent(
      GithubRepoDataLoadingEvent event, Emitter<GithubRepoState> emit) async {
    // ignore: unnecessary_type_check
    if (event is GithubRepoDataLoadingEvent) {
      emit(const GithubRepoStateLoading(repositoryData: []));
      try {
        final fetchedData = await GithubRepoResources.getData();
        emit(GithubRepoDataLoadedState(repositoryData: fetchedData));
      } catch (e, stackTrace){
        debugPrintStack(label: e.toString(), stackTrace: stackTrace);
        emit(GithubRepoStateError(repositoryData: const [], message: e.toString()));
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
        emit(const GithubRepoStateLoading(repositoryData: []));
        await Future.delayed(const Duration(milliseconds: 500));

        if (result.token == null || result.token!.isEmpty) {
          emit(const GithubRepoStateError(repositoryData: [], message: 'github token not found'));
          return;
        }

        await localStorage.setGitHubToken(result.token!);
        await ApiSdk().updateGitHubToken();
        emit(GithubConnectSuccess());
        break;

      case GitHubSignInResultStatus.cancelled:
      case GitHubSignInResultStatus.failed:
        emit(const GithubRepoStateError(repositoryData: [], message: 'failed to get token from github'));
        break;
    }
  }
}
