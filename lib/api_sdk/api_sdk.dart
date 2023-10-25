import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/api_constants.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/graphql_method/graphql_handler.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/rest/dio_http_handler.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_event.dart';
import 'package:lxk_flutter_boilerplate/src/app.dart';
import 'package:lxk_flutter_boilerplate/src/utils/extension/build_context+extension.dart';

class ApiSdk {

  static simulateTokenExpired() async {
    await Future.delayed(const Duration(seconds: 15));
    if (globalContext.mounted) {
      globalContext.read<AuthenticationBloc>().add(UserTokenExpired());
    }
  }

  static loginWithEmailAndPassword(dynamic body) async {
    final response = await DioHttpHandler().post(
        '${apiConstants["auth"]}/login', data: body);
    return response;
  }

  static signUpWithEmailAndPassword(dynamic body) async {
    final response = await DioHttpHandler().post(
        '${apiConstants["auth"]}/register', data: body);
    return response;
  }

  static getUserData(int id) async {
    final response = await DioHttpHandler().get(
        '${apiConstants["auth"]}/users/$id');
    return response;
  }

  static fetchGithubRepoGraphQl(numOfRepositories) async {
    final GraphqlQlHandler githubRepository =
        GraphqlQlHandler(client: client());
    final response = await githubRepository.getRepositories(numOfRepositories);
    return response;
  }

  static getAnimals(int page, int limit) async {
    final response = await DioHttpHandler().get(
        '${apiConstants["mock"]}',
        queryParameters: { 'page': page, 'limit': limit });
    return response;
  }
  
  static getAnimal(int id) async {
    final response = await DioHttpHandler().get('${apiConstants["mock"]}/$id');
    return response;
  }

  static addAnimal(body) async {
    final response = await DioHttpHandler().post(
        '${apiConstants["mock"]}',
        data: body
    );
    return response;
  }

  static editAnimal(int id, body) async {
    final response = await DioHttpHandler().put(
        '${apiConstants["mock"]}/$id',
        data: body
    );
    return response;
  }

  static deleteAnimal(int id) async {
    final response = await DioHttpHandler().delete(
        '${apiConstants["mock"]}/$id'
    );
    return response;
  }

}
