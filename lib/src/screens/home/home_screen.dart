// home screen contents
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_state.dart';
import 'package:lxk_flutter_boilerplate/src/routes/routes.dart';
import 'package:lxk_flutter_boilerplate/src/screens/animal/animal_list_screen.dart';
import 'package:lxk_flutter_boilerplate/src/utils/extension/text_widget+extension.dart';
import 'package:provider/provider.dart';

import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:lxk_flutter_boilerplate/src/config/string_constants.dart'
    as string_constants;
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_state.dart';
import 'package:lxk_flutter_boilerplate/src/config/image_constants.dart';
import 'package:lxk_flutter_boilerplate/src/utils/app_state_notifier.dart';
import 'package:lxk_flutter_boilerplate/src/widgets/cache_image_widget.dart';
import 'package:lxk_flutter_boilerplate/src/screens/home/github_repo_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget>? actionOptions(BuildContext context) {
    if (_selectedIndex == 1) {
      return [
        IconButton(
            icon: const Icon(Icons.add, size: 26.0),
            onPressed: () {
              Navigator.pushNamed(context, RouteName.animalDetail.path);
            })
      ];
    }

    return null;
  }

  Widget githubConnectWidget() {
    return BlocBuilder<GithubRepoBloc, GithubRepoState>(
        builder: (BuildContext context, GithubRepoState state) {
      if (!state.isConnected) {
        return ListTile(
            title: InkWell(
                child: Text('Connect To Github',
                    style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {
                  context.read<GithubRepoBloc>().add(GithubConnect());
                }));
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/github-mark.png',
                  fit: BoxFit.contain,
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 16),
                Text('Connected to Github as',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.grey),
          state.userData == null
              ? const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Text('Can\'t get github user info'),
              )
              : Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Column(children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedImage(
                        imageUrl: state.userData!.avatarUrl,
                        fit: BoxFit.contain,
                        errorWidget: Image.network(
                          AllImages().kDefaultImage,
                        ),
                        width: 80,
                        height: 80,
                        placeholder: const CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        state.userData!.name,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(state.userData!.email,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ]),
                ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Colors.grey)
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthenticationBloc>().add(GetUserData());
    return WillPopScope(
        onWillPop: () async => false,
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (BuildContext context, AuthenticationState state) {
          if (state.status == AuthenticationStatus.newUserData) {
            final userData = state.userData!;
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  string_constants.app_bar_title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ).onColorSurface,
                actions: actionOptions(context),
              ),
              body: IndexedStack(
                index: _selectedIndex,
                children: const [GithubRepoListScreen(), AnimalListScreen()],
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.business),
                    label: 'Business',
                  )
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CachedImage(
                              imageUrl: userData.data.avatar,
                              fit: BoxFit.contain,
                              errorWidget: Image.network(
                                AllImages().kDefaultImage,
                              ),
                              width: 80,
                              height: 80,
                              placeholder: const CircularProgressIndicator(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              '${userData.data.firstName} ${userData.data.lastName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white)),
                          const SizedBox(height: 8),
                          Text(userData.data.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                    githubConnectWidget(),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          const Text('Light Mode'),
                          Switch(
                            value: Provider.of<AppStateNotifier>(context)
                                .isDarkMode,
                            onChanged: (value) {
                              Provider.of<AppStateNotifier>(context,
                                      listen: false)
                                  .updateTheme(value);
                            },
                          ),
                          const Text('Dark Mode')
                        ],
                      ),
                    ),
                    ListTile(
                        title: InkWell(
                            child: Text('Log out',
                                style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () {
                              context
                                  .read<AuthenticationBloc>()
                                  .add(UserLogOut());
                            })),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }));
  }
}
