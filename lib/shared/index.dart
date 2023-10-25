import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/shared/modules/animals/bloc/animal_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'modules/authentication/bloc/authentication/authentication_bloc.dart';
import 'modules/github_repo/bloc/github_repo_bloc/github_repo_bloc.dart';

final List<SingleChildWidget> blocProviders = [
  BlocProvider<AuthenticationBloc>(
    lazy: false,
    create: (BuildContext context) => AuthenticationBloc(),
  ),
  BlocProvider<GithubRepoBloc>(
    create: (BuildContext context) => GithubRepoBloc(),
  ),
  BlocProvider<AnimalBloc>(
    create: (BuildContext context) => AnimalBloc(),
  ),
];
