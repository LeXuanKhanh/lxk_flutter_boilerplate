import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lxk_flutter_boilerplate/src/screens/authentication/signup_screen.dart';

import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_state.dart';
import 'package:lxk_flutter_boilerplate/src/screens/authentication/login_screen.dart';
import 'package:lxk_flutter_boilerplate/src/utils/extension/text_widget+extension.dart';


class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool showLoginForm = true;
  @override
  Widget build(BuildContext context) {
    void _showError(String error) async {
      await Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return Scaffold(
        body: WillPopScope(
        onWillPop: () async => false,
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: context.read<AuthenticationBloc>(),
        listener: (context, state) {
          if (state is AuthenticationFailure) {
            _showError(state.message);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (BuildContext context, AuthenticationState state) {
              return SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Center(
                              child: Text(
                            showLoginForm ? 'LOGIN' : 'SIGN UP',
                            style: Theme.of(context).textTheme.displayMedium,
                          )),
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: showLoginForm
                                ? const LoginForm()
                                : const SignUpForm(),
                          ),
                          !showLoginForm
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(
                                        height: 38,
                                      ),
                                      const Text('Don\'t have an account ?'),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      ElevatedButton(
                                          child: Text(
                                            'Sign Up',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ).onColorSurface,
                                          onPressed: () {
                                            setState(() {
                                              showLoginForm = false;
                                            });
                                          })
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                    showLoginForm
                        ? const SizedBox()
                        : Positioned(
                            left: 6,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 32,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  showLoginForm = true;
                                });
                              },
                            ),
                          )
                  ],
                ),
              );
            }),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
  }
}
