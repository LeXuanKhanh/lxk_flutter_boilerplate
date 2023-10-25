//For the graphql.
import 'package:graphql/client.dart';

Map<String, String> apiConstants = {
  "auth": "https://reqres.in/api",
  'mock': 'https://64e6d4b2b0fd9648b78ef0d0.mockapi.io/api/v1/animals'
};
GraphQLCache cache = GraphQLCache(
  dataIdFromObject: (object) {
    if (object is Map<String, Object> &&
        object.containsKey('__typename') &&
        object.containsKey('id')) {
      return "${object['__typename']}/${object['id']}";
    }
    return null;
  },
);

//For the rest.
GraphQLClient client() {
  final HttpLink httpLink = HttpLink(
    'https://api.github.com/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () => 'Bearer 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',
  );

  final Link link = authLink.concat(httpLink);

  return GraphQLClient(
    cache: cache,
    link: link,
  );
}
