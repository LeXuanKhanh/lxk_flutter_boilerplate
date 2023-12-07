import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/modules/authentication/bloc/authentication/authentication_bloc.dart';
import '../../../shared/modules/authentication/bloc/authentication/authentication_event.dart';
import '../../../shared/modules/authentication/bloc/authentication/authentication_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
            return state is AuthenticationLoading
                ? CircularProgressIndicator(
                    backgroundColor:
                        Theme.of(context).textTheme.bodyLarge?.color)
                : Text('Login', style: Theme.of(context).textTheme.bodyLarge);
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
          ElevatedButton(child:
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (BuildContext context, AuthenticationState state) {
            return state is AuthenticationLoading
                ? CircularProgressIndicator(
                    backgroundColor:
                        Theme.of(context).textTheme.bodyLarge?.color)
                : Text('Login with Github', style: Theme.of(context).textTheme.bodyLarge);
          }), onPressed: () {
            if (_key.currentState!.validate()) {
              context.read<AuthenticationBloc>().add(GithubLogin());
            } else {}
          })
        ],
      ),
    );
  }
}
