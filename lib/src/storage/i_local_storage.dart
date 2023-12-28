abstract class ILocalStorage {
  Future<String> getGitHubToken();
  Future<void> setGitHubToken(String githubToken);
}