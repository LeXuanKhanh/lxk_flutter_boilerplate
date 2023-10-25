import 'package:bloc/bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/resources/github_repo_resouces.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_state.dart';


class GithubRepoBloc extends Bloc<GithubRepoEvent, GithubRepoState> {
  GithubRepoBloc() : super(GithubRepoStateInitial()) {
    on<GithubRepoDataLoadingEvent>(onGithubRepoDataLoadingEvent);
  }

  onGithubRepoDataLoadingEvent(
      GithubRepoDataLoadingEvent event, Emitter<GithubRepoState> emit) async {
    // ignore: unnecessary_type_check
    if (event is GithubRepoDataLoadingEvent) {
      emit(GithubRepoStateLoading());
      var fetchedData = await GithubRepoResources.getData();
      emit(GithubRepoDataLoadedState(repositoryData: fetchedData));
    }
  }
}
