// home screen contents
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/routes/index.dart';
import '/src/screens/animal/animal_list_screen.dart';
import 'package:provider/provider.dart';

import '/shared/modules/authentication/bloc/authentication/authentication_bloc.dart';
import '/src/config/string_constants.dart'
    as string_constants;
import '/shared/modules/authentication/bloc/authentication/authentication_event.dart';
import '/shared/modules/authentication/bloc/authentication/authentication_state.dart';
import '/src/config/image_constants.dart';
import '/src/utils/app_state_notifier.dart';
import '/src/widgets/cache_image_widget.dart';
import '/src/screens/home/github_repo_list_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

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
              Navigator.pushNamed(
                  context, RouteName.animalDetail.path);
            })
      ];
    }

    return null;
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
          if (state is SetUserData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  string_constants.app_bar_title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                child: CachedImage(
                                  imageUrl: state.currentUserData.data.avatar,
                                  fit: BoxFit.fitWidth,
                                  errorWidget: Image.network(
                                    AllImages().kDefaultImage,
                                  ),
                                  width: 80,
                                  height: 80,
                                  placeholder:
                                      const CircularProgressIndicator(),
                                ),
                              ),
                              Switch(
                                value: Provider.of<AppStateNotifier>(context)
                                    .isDarkMode,
                                onChanged: (value) {
                                  Provider.of<AppStateNotifier>(context,
                                          listen: false)
                                      .updateTheme(value);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                          '${state.currentUserData.data.firstName} ${state.currentUserData.data.lastName}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    ListTile(
                      title: Text(state.currentUserData.data.email,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    // ListTile(
                    //   title: Text(state.currentUserData.ad.company,
                    //       style: Theme.of(context).textTheme.bodyMedium),
                    // ),
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
