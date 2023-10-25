import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_bloc.dart';
import '/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import '/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_state.dart';


class GithubRepoListScreen extends StatefulWidget {
  const GithubRepoListScreen({super.key});

  @override
  _GithubRepoListScreenState createState() => _GithubRepoListScreenState();
}

class _GithubRepoListScreenState extends State<GithubRepoListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GithubRepoBloc, GithubRepoState>(
        builder: (BuildContext context, GithubRepoState state) {
          if (state is GithubRepoStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GithubRepoDataLoadedState) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.repositoryData.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        state.repositoryData[index].name.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: state.repositoryData[index].viewerHasStarred
                          ? const Icon(Icons.star)
                          : const SizedBox(),
                    ),
                    const Divider(
                      height: 10.0,
                    )
                  ],
                );
              },
            );
          }
          return const SizedBox();
        });
  }

  @override
  void initState() {
    context.read<GithubRepoBloc>().add(GithubRepoDataLoadingEvent());
    super.initState();
  }
}
