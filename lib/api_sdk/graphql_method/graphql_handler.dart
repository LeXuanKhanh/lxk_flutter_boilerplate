import 'dart:async';

import '/api_sdk/graphql_method/graphql_operation/mutations/mutations.dart'
    as mutations;
import '/api_sdk/graphql_method/graphql_operation/queries/readRepositories.dart'
    as queries;
import 'package:gql/language.dart';
import 'package:graphql/client.dart';

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

    return await client.query(options);
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

    return await client.mutate(options);
  }
}
