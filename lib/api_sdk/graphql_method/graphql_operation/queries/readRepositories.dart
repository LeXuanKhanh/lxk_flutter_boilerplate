const String readRepositories = r'''
query ReadRepositories($first: Int!, $cursor: String) {
    viewer {
      repositories(first: $first, after: $cursor) {
        totalCount
        edges {
          cursor
          node {
            __typename
            id
            name
            viewerHasStarred
            url
            stargazerCount
            isFork
            forkCount
            createdAt
          }
        }
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }
  }
''';

const String testSubscription = r'''
		subscription test {
	    deviceChanged(id: 2) {
        id
        name
      }
		} 
''';

const String userInfo = r'''
query {
  viewer {
    login
    avatarUrl
    email
    name
  }
}
''';
