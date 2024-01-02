import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/current_user_data.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/user_data.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/models/repo.dart';

enum GithubStatus {
  initial,
  loading,
  error,
  connected,
  dataLoaded,
  userDataLoaded
}

class GithubRepoState extends Equatable {
  final List<Repo> repositoryData;
  final String message;
  final CurrentUserData? userData;
  final GithubStatus status;

  bool get isConnected => ApiSdk().isGithubConnected;

  const GithubRepoState({
    this.status = GithubStatus.initial,
    this.repositoryData = const [],
    this.message = '',
    this.userData,
  });

  GithubRepoState copyWith({GithubStatus? status, List<Repo>? repositoryData,
      String? message, CurrentUserData? userData}) {
    return GithubRepoState(
      status: status ?? this.status,
      repositoryData: repositoryData ?? this.repositoryData,
      message: message ?? this.message,
      userData: userData ?? this.userData,
    );
  }

  GithubRepoState toStateLoading() {
    return copyWith(status: GithubStatus.loading);
  }

  GithubRepoState toStateError({String message = ''})  {
    return copyWith(status: GithubStatus.error, message: message);
  }

  @override
  List<Object?> get props =>
      [status, repositoryData, message, userData];
}
