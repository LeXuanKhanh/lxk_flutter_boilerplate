import 'package:equatable/equatable.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/models/repo.dart';

class GithubRepoDataLoadedState extends GithubRepoState {
  final List<Repo> repositoryData;
  const GithubRepoDataLoadedState({required this.repositoryData});
  @override
  List<Object> get props => [repositoryData];
}

abstract class GithubRepoState extends Equatable {
  const GithubRepoState();

  @override
  List<Object> get props => [];
}

class GithubRepoStateInitial extends GithubRepoState {}

class GithubRepoStateLoading extends GithubRepoState {}
