import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/api_constants.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/graphql_method/graphql_handler.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/rest/dio_http_handler.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/bloc/authentication/authentication_event.dart';
import 'package:lxk_flutter_boilerplate/src/app.dart';
import 'package:lxk_flutter_boilerplate/src/storage/index.dart';

class ApiSdk {
  ApiSdk._();

  static final ApiSdk _instance = ApiSdk._();
  factory ApiSdk() => _instance;

  bool get isGithubConnected => _githubToken.isNotEmpty;

  String _githubToken = '';
  late GraphqlQlHandler githubRepository;

  Future<void> initializeAsync() async {
    _githubToken = await localStorage.getGitHubToken();
    GraphQLClient ghClient = gitHubClient(_githubToken);
    githubRepository = GraphqlQlHandler(client: ghClient);
  }

  Future<void> updateGitHubToken({String token = ''}) async {
    await localStorage.setGitHubToken(token);
    _githubToken = token;
    GraphQLClient ghClient = gitHubClient(_githubToken);
    githubRepository = GraphqlQlHandler(client: ghClient);
  }

  Future<void> resetGithubToken() async {
    await updateGitHubToken();
  }

  static simulateTokenExpired() async {
    await Future.delayed(const Duration(seconds: 15));
    if (globalContext.mounted) {
      globalContext.read<AuthenticationBloc>().add(UserTokenExpired());
    }
  }

  static loginWithEmailAndPassword(dynamic body) async {
    final response = await DioHttpHandler()
        .post('${apiConstants["auth"]}/login', data: body);
    return response;
  }

  static signUpWithEmailAndPassword(dynamic body) async {
    final response = await DioHttpHandler()
        .post('${apiConstants["auth"]}/register', data: body);
    return response;
  }

  static getUserData(int id) async {
    final response =
        await DioHttpHandler().get('${apiConstants["auth"]}/users/$id');
    return response;
  }

  getUserInfo() async {
    final response = await githubRepository.getUserInfo();
    return response;
  }

  fetchGithubRepoGraphQl(int numOfRepositories, String? cursor) async {
    final response =
        await githubRepository.getRepositories(numOfRepositories, cursor);
    return response;
  }

  static getAnimals(int page, int limit) async {
    final response = await DioHttpHandler().get('${apiConstants["mock"]}',
        queryParameters: {'page': page, 'limit': limit});
    return response;
  }

  static getAnimal(int id) async {
    final response = await DioHttpHandler().get('${apiConstants["mock"]}/$id');
    return response;
  }

  static addAnimal(body) async {
    final response =
        await DioHttpHandler().post('${apiConstants["mock"]}', data: body);
    return response;
  }

  static editAnimal(int id, body) async {
    final response =
        await DioHttpHandler().put('${apiConstants["mock"]}/$id', data: body);
    return response;
  }

  static deleteAnimal(int id) async {
    final response =
        await DioHttpHandler().delete('${apiConstants["mock"]}/$id');
    return response;
  }
}
