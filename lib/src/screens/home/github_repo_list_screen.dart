import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_state.dart';
import 'package:lxk_flutter_boilerplate/src/routes/routes.dart';
import 'package:lxk_flutter_boilerplate/src/widgets/lazy_load_list_view/base_lazy_load_list_view.dart';

class GithubRepoListScreen extends StatefulWidget {
  const GithubRepoListScreen({super.key});

  @override
  _GithubRepoListScreenState createState() => _GithubRepoListScreenState();
}

class _GithubRepoListScreenState extends State<GithubRepoListScreen> {
  final GlobalKey<BaseLazyLoadListViewState> _listViewKey =
      GlobalKey<BaseLazyLoadListViewState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GithubRepoBloc, GithubRepoState>(
        listener: (context, state) {
      if (state.status == GithubStatus.error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      }
      if (state.status == GithubStatus.userDataLoaded) {
        _listViewKey.currentState!.showRefresh();
      }
    }, builder: (BuildContext context, GithubRepoState state) {
      // debugPrint(state.status.toString());
      return BaseLazyLoadListView(
        key: _listViewKey,
        padding: const EdgeInsets.only(top: 8),
        onRefresh: () {
          context.read<GithubRepoBloc>().add(RefreshListRepo());
          return context.read<GithubRepoBloc>().stream.firstWhere((element) {
            return element.status == GithubStatus.dataLoaded;
          });
        },
        canLoadMore: state.canLoadMore,
        onLoadMore: () async {
          context.read<GithubRepoBloc>().add(LoadMoreListRepo());
          await context.read<GithubRepoBloc>().stream.firstWhere((element) {
            return element.status == GithubStatus.dataLoaded;
          });
          return Future.value();
        },
        isEmpty: state.repositoryData.isEmpty,
        itemCount: state.repositoryData.length,
        itemBuilder: (BuildContext context, int index) {
          final item = state.repositoryData[index].node;
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Row(children: [
                        const Icon(Icons.start, size: 20),
                        const SizedBox(width: 4),
                        Text(item.createAtDateFormatted)
                      ]),
                      Visibility(
                          visible: item.isFork,
                          child: const Column(
                            children: [
                              SizedBox(height: 4),
                              Text('Forked Project'),
                            ],
                          )),
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
    context.read<GithubRepoBloc>().add(GithubGetUserInfo());
    super.initState();
  }
}
