import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/models/github_user.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/models/repo.dart';

class GithubRepoResources {
  static Future<List<Repo>> getData({int limit = 10, String? cursor}) async {
    final response = await ApiSdk().fetchGithubRepoGraphQl(limit, cursor);
    final List<dynamic> repos =
        response.data['viewer']['repositories']['edges'] as List<dynamic>;
    final List<Repo> listOfRepos = repoFromJsonArr(repos);
    return listOfRepos;
  }

  static Future<GithubUser> getUserInfo() async {
    final response = await ApiSdk().getUserInfo();
    return GithubUser.fromJson(response.data['viewer']);
  }
}
