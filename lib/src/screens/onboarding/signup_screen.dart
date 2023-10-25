import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shared/modules/authentication/bloc/authentication/authentication_bloc.dart';
import '../../../shared/modules/authentication/bloc/authentication/authentication_event.dart';
import '../../../shared/modules/authentication/bloc/authentication/authentication_state.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

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
              if (value == null || value.isEmpty) {
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
              if (value == null || value.isEmpty) {
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
                    return state is AuthenticationLoading ?
                    CircularProgressIndicator(
                        backgroundColor: Theme.of(context).textTheme.bodyLarge?.color
                    ) :
                    Text('Sign Up', style: Theme.of(context).textTheme.bodyLarge);
              }),
              onPressed: () {
                if (_key.currentState!.validate()) {
                  context.read<AuthenticationBloc>().add(UserSignUp(
                    email: _emailController.text,
                    password: _passwordController.text));
                } else {
                  print('Form not validated');
                }
          })
        ],
      ),
    );
  }
}
