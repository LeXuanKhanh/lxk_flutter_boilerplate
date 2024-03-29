import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/bloc/github_repo_bloc/github_repo_state.dart';

import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_state.dart';
import 'package:lxk_flutter_boilerplate/src/config/color_constants.dart';
import 'package:lxk_flutter_boilerplate/src/utils/extension/text_widget+extension.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final email = 'eve.holt@reqres.in';
  final pw = 'pistol';

  @override
  void initState() {
    super.initState();
    _emailController.text = email;
    _passwordController.text = pw;
  }

  List<Widget> nameAndPasswordLoginWidgets() {
    return [
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Email address',
          filled: true,
          isDense: true,
        ),
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        validator: (value) {
          if (value == null || (value.isEmpty)) {
            return 'Email is required.';
          }
          return null;
        },
      ),
      const SizedBox(
        height: 12,
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Password',
          filled: true,
          isDense: true,
        ),
        obscureText: true,
        controller: _passwordController,
        validator: (value) {
          if (value == null || (value.isEmpty)) {
            return 'Password is required.';
          }
          return null;
        },
      ),
      const SizedBox(
        height: 16,
      ),
      ElevatedButton(child:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (BuildContext context, AuthenticationState state) {
        return state.status == AuthenticationStatus.loading
            ? CircularProgressIndicator(
                backgroundColor: ColorConstants.onColorSurfaceColor)
            : Text('Login', style: Theme.of(context).textTheme.bodyLarge).onColorSurface;
      }), onPressed: () {
        if (_key.currentState!.validate()) {
          context.read<AuthenticationBloc>().add(UserLogin(
              email: _emailController.text,
              password: _passwordController.text));
        } else {}
      }),
      const SizedBox(
        height: 16,
      ),
    ];
  }

  Widget elevatedButtonChild(GithubRepoState state, BuildContext context) {
    if (state.status == GithubStatus.loading) {
      return CircularProgressIndicator(
          backgroundColor: Theme.of(context).textTheme.bodyLarge?.color);
    }

    if (state.isConnected) {
      return Text('Connected with Github',
              style: Theme.of(context).textTheme.bodyLarge).color(Theme.of(context).primaryColor);
    }

    return Text('Login with Github',
            style: Theme.of(context).textTheme.bodyLarge)
        .onColorSurface;
  }

  void onTapGithubButton() {
    if (context.read<GithubRepoBloc>().state.status == GithubStatus.loading) {
      return;
    }

    context.read<GithubRepoBloc>().add(GithubConnect());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...nameAndPasswordLoginWidgets(),
          BlocBuilder<GithubRepoBloc, GithubRepoState>(
              builder: (BuildContext context, GithubRepoState state) {
            return ElevatedButton(
                onPressed: state.isConnected ? null : onTapGithubButton,
                child: elevatedButtonChild(state, context));
          }),
        ],
      ),
    );
  }
}
