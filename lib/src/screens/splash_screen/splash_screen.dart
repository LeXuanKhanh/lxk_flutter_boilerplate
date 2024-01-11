import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_state.dart';
import 'package:lxk_flutter_boilerplate/src/config/color_constants.dart';
import 'package:lxk_flutter_boilerplate/src/config/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lxk_flutter_boilerplate/src/routes/nav_observer.dart';
import 'package:lxk_flutter_boilerplate/src/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.secondaryAppColor,
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, AuthenticationState state) {
            if (state is AppAutheticated) {
              // ApiSdk.simulateTokenExpired();
              Navigator.pushNamed(context, RouteName.home.path);
            }
            if (state is AuthenticationStart) {
              Navigator.pushNamed(context, RouteName.auth.path);
            }
            if (state is UserLogoutState) {
              if (NavObserver().routePath.contains(RouteName.home.path)) {
                Navigator.pushNamedAndRemoveUntil(context, RouteName.auth.path,
                    RouteName.splashScreen.modalRoute);
              } else {
                Navigator.popUntil(context, RouteName.auth.modalRoute);
              }
            }
            if (state is AuthenticationShowTokenExpiredDialog) {
              _showSessionExpiredDialog();
            }
          },
          child: Center(child: Image.asset(AllImages().logo)),
        ));
  }

  @override
  void initState() {
    context.read<AuthenticationBloc>().add(AppLoadedup());
    super.initState();
  }

  Future<void> _showSessionExpiredDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your session is expired, please log in again'),
          actions: <Widget>[
            TextButton(
              child: const Text('Log out'),
              onPressed: () {
                context.read<AuthenticationBloc>().add(UserLogOut());
              },
            ),
          ],
        );
      },
    );
  }
}
