import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_state.dart';
import 'package:lxk_flutter_boilerplate/src/routes/routes.dart';
import 'package:lxk_flutter_boilerplate/src/utils/extension/text_widget+extension.dart';

class GithubRepoListScreen extends StatefulWidget {
  const GithubRepoListScreen({super.key});

  @override
  _GithubRepoListScreenState createState() => _GithubRepoListScreenState();
}

class _GithubRepoListScreenState extends State<GithubRepoListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GithubRepoBloc, GithubRepoState>(
        listener: (context, state) {
      if (state.status == GithubStatus.error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      }
    }, builder: (BuildContext context, GithubRepoState state) {
      debugPrint(state.toString());
      if (state.status == GithubStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.repositoryData.length,
        itemBuilder: (BuildContext context, int index) {
          final item = state.repositoryData[index];
          return Column(
            children: [
              InkWell(
                onTap: () => Navigator.pushNamed(
                    context, RouteName.webView.path,
                    arguments: item.url),
                child: ListTile(
                  title: Text(
                    item.name.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.star,
                              color: Colors.amberAccent, size: 20),
                          const SizedBox(width: 4),
                          Text('${item.stargazerCount}')
                        ]),
                      ],),
                      Column(
                        children: [
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.star,
                                color: Colors.amberAccent, size: 20),
                            const SizedBox(width: 4),
                            Text('${item.stargazerCount}')
                          ]),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.merge, size: 20),
                            const SizedBox(width: 4),
                            Text('${item.forkCount}')
                          ]),
                          const SizedBox(height: 4),
                          Visibility(
                              visible: item.isFork,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Forked Project'))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 10.0,
              )
            ],
          );
        },
      );
    });
  }

  @override
  void initState() {
    context.read<GithubRepoBloc>().add(GithubRepoDataLoadingEvent());
    context.read<GithubRepoBloc>().add(GithubGetUserInfo());
    super.initState();
  }
}
