const String readRepositories = r'''
  query ReadRepositories($nRepositories: Int!) {
    viewer {
      repositories(last: $nRepositories) {
        nodes {
          __typename
          id
          name
          viewerHasStarred
          url
          stargazerCount
          isFork
          forkCount
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
