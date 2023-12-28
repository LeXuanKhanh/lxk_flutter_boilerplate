import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/models/repo.dart';

class GithubRepoResources {
  static Future<List<Repo>> getData() async {
    final response = await ApiSdk().fetchGithubRepoGraphQl(10);
    final List<dynamic> repos =
        response.data['viewer']['repositories']['nodes'] as List<dynamic>;

    final List<Repo> listOfRepos = repos
        .map((dynamic e) => Repo(
              id: e['id'] as String,
              name: e['name'] as String,
              viewerHasStarred: e['viewerHasStarred'] as bool,
            ))
        .toList();

    return listOfRepos;
  }

  Future<dynamic> getUserInfo() async {
    final response = await ApiSdk().getUserInfo();
    return response.data;
  }
}
