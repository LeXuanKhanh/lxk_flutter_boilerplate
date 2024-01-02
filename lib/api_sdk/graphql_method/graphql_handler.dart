import 'dart:async';

import 'package:lxk_flutter_boilerplate/api_sdk/graphql_method/graphql_operation/mutations/mutations.dart'
    as mutations;
import 'package:lxk_flutter_boilerplate/api_sdk/graphql_method/graphql_operation/queries/readRepositories.dart'
    as queries;
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/rest/api_helpers/api_exception.dart';

class GraphqlQlHandler {
  final GraphQLClient client;

  GraphqlQlHandler({required this.client});

  Future<QueryResult> getRepositories(int numOfRepositories) async {
    final WatchQueryOptions options = WatchQueryOptions(
      document: parseString(queries.readRepositories),
      variables: <String, dynamic>{
        'nRepositories': numOfRepositories,
      },
      pollInterval: const Duration(seconds: 4),
      fetchResults: true,
    );

    final result = await client.query(options);
    if (result.exception != null) {
      throw GraphQLException(result.exception);
    }

    return result;
  }

  Future<QueryResult> toggleRepoStar(dynamic repo) async {
    var document =
        repo.viewerHasStarred ? mutations.removeStar : mutations.addStar;

    final MutationOptions options = MutationOptions(
      document: parseString(document),
      variables: <String, String>{
        'starrableId': repo.id,
      },
    );

    final result = await client.mutate(options);
    if (result.exception != null) {
      throw GraphQLException(result.exception);
    }

    return result;
  }

  Future<QueryResult> getUserInfo() async {
    final WatchQueryOptions options = WatchQueryOptions(
      document: parseString(queries.userInfo),
      pollInterval: const Duration(seconds: 4),
      fetchResults: true,
    );

    final result = await client.query(options);
    if (result.exception != null) {
      throw GraphQLException(result.exception);
    }

    return result;
  }
}
