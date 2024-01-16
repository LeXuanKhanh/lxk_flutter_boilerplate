import 'package:equatable/equatable.dart';

abstract class GithubRepoEvent extends Equatable {
  const GithubRepoEvent();

  @override
  List<Object> get props => [];
}

class GithubRepoDataLoadingEvent extends GithubRepoEvent {}

class GithubConnect extends GithubRepoEvent {}

class GithubGetUserInfo extends GithubRepoEvent {}

class GithubLogOut extends GithubRepoEvent {}

class RefreshListRepo extends GithubRepoEvent {}

class LoadMoreListRepo extends GithubRepoEvent {}
