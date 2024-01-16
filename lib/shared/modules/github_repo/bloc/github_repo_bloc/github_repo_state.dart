import 'package:equatable/equatable.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/current_user_data.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/models/repo.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'github_repo_state.freezed.dart';

enum GithubStatus {
  initial,
  loading,
  error,
  connected,
  dataLoaded,
  userDataLoaded
}

@freezed
class GithubRepoState with _$GithubRepoState {
  const factory GithubRepoState({
    @Default(GithubStatus.initial) GithubStatus status,
    @Default('') String message,
    CurrentUserData? userData,
    @Default([]) List<Repo> repositoryData,
    @Default(1) int page,
    @Default(true) bool canLoadMore,
    String? cursor
  }) = _GithubRepoState;

  const GithubRepoState._();

  bool get isConnected => ApiSdk().isGithubConnected;

  GithubRepoState toStateLoading() {
    return copyWith(status: GithubStatus.loading);
  }

  GithubRepoState toStateError({String message = ''}) {
    return copyWith(status: GithubStatus.error, message: message);
  }
}
