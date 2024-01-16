import 'package:bloc/bloc.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/models/repo.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/resources/github_repo_resouces.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_state.dart';
import 'package:flutter/widgets.dart';
import 'package:lxk_flutter_boilerplate/src/app.dart';
import 'package:lxk_flutter_boilerplate/src/third_parties/github_sign_in/github_sign_in.dart';
import 'package:lxk_flutter_boilerplate/src/third_parties/github_sign_in/github_sign_in_result.dart';
import 'package:lxk_flutter_boilerplate/src/config/config_env.dart' as config;

class GithubRepoBloc extends Bloc<GithubRepoEvent, GithubRepoState> {
  final int limit = 10;

  GithubRepoBloc() : super(const GithubRepoState()) {
    on<GithubRepoDataLoadingEvent>(onGithubRepoDataLoadingEvent);
    on<GithubConnect>(onGithubConnectEvent);
    on<GithubLogOut>(onGithubLogOut);
    on<GithubGetUserInfo>(onGithubGetUserInfo);
    on<RefreshListRepo>(_refreshListRepo);
    on<LoadMoreListRepo>(_loadMoreListRepo);
  }

  Future<void> onGithubRepoDataLoadingEvent(
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

  Future<void> onGithubConnectEvent(
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
        break;

      case GitHubSignInResultStatus.cancelled:
      case GitHubSignInResultStatus.failed:
        emit(state.toStateError(message: 'failed to get token from github'));
        break;
    }
  }

  Future<void>onGithubGetUserInfo(
      GithubGetUserInfo event, Emitter<GithubRepoState> emit) async {
    emit(state.toStateLoading());
    try {
      final data = await GithubRepoResources.getUserInfo();
      emit(state.copyWith(status: GithubStatus.userDataLoaded, userData: data));
    } catch (e, stackTrace) {
      debugPrintStack(label: e.toString(), stackTrace: stackTrace);
      emit(state.toStateError(message: e.toString()));
    }
  }

  Future<void> onGithubLogOut(GithubLogOut event, Emitter<GithubRepoState> emit) async {
    emit(state.toStateLoading());
    await ApiSdk().resetGithubToken();
    emit(const GithubRepoState());
  }

  Future<void> _refreshListRepo(
      RefreshListRepo event, Emitter<GithubRepoState> emit) async {
    emit(state.toStateLoading());
    try {
      // await Future.delayed(const Duration(seconds: 1));
      const int page = 1;
      bool canLoadMore = true;
      String? lastCursor;
      final list = await GithubRepoResources.getData(limit: limit);
      if (list.length < limit) {
        canLoadMore = false;
      } else if (list.isNotEmpty) {
        lastCursor = list.last.cursor;
      }

      emit(state.copyWith(
          status: GithubStatus.dataLoaded,
          repositoryData: list,
          page: page,
          canLoadMore: canLoadMore,
          cursor: lastCursor));
    } catch (e, stacktrace) {
      debugPrintStack(label: e.toString(), stackTrace: stacktrace);
      emit(state.toStateError(message: e.toString()));
    }
  }

  Future<void> _loadMoreListRepo(
      LoadMoreListRepo event, Emitter<GithubRepoState> emit) async {
    emit(state.toStateLoading());
    try {
      int page = state.page + 1;
      bool canLoadMore = true;
      String? lastCursor;
      final newList = List<Repo>.from(state.repositoryData);
      final list =
          await GithubRepoResources.getData(limit: limit, cursor: state.cursor);
      if (list.length < limit) {
        canLoadMore = false;
      } else if (list.isNotEmpty) {
        newList.addAll(list);
        lastCursor = list.last.cursor;
      }

      emit(state.copyWith(
          status: GithubStatus.dataLoaded,
          repositoryData: newList,
          page: page,
          canLoadMore: canLoadMore,
          cursor: lastCursor));
    } catch (e, stacktrace) {
      debugPrintStack(label: e.toString(), stackTrace: stacktrace);
      emit(state.toStateError(message: e.toString()));
    }
  }
}
