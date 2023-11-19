import 'package:equatable/equatable.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/models/repo.dart';

abstract class GithubRepoState extends Equatable {
  final List<Repo> repositoryData;
  const GithubRepoState({required this.repositoryData});

  @override
  List<Object> get props => [repositoryData];
}

class GithubRepoStateInitial extends GithubRepoState {
  GithubRepoStateInitial() : super(repositoryData: []);
}

class GithubRepoStateLoading extends GithubRepoState {
  const GithubRepoStateLoading({required super.repositoryData});
}

class GithubRepoDataLoadedState extends GithubRepoState {
  const GithubRepoDataLoadedState({required super.repositoryData});
}

class GithubRepoStateError extends GithubRepoState {
  final String message;
  const GithubRepoStateError({
    required super.repositoryData,
    this.message = ''});

  @override
  List<Object> get props => [message];
}
