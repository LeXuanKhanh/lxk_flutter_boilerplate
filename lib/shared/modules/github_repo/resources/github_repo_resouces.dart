import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/current_user_data.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/github_repo/models/repo.dart';

class GithubRepoResources {
  static Future<List<Repo>> getData() async {
    final response = await ApiSdk().fetchGithubRepoGraphQl(10);
    final List<dynamic> repos =
        response.data['viewer']['repositories']['nodes'] as List<dynamic>;
    final List<Repo> listOfRepos = repoFromJsonArr(repos);
    return listOfRepos;
  }

  static Future<CurrentUserData> getUserInfo() async {
    final response = await ApiSdk().getUserInfo();
    return CurrentUserData.fromGithubGraphQL(response.data);
  }
}
