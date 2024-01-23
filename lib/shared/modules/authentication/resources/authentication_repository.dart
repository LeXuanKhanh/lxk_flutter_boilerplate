import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/rest/api_helpers/api_exception.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/user_info.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/authentication/models/user_data.dart';

class AuthenticationRepository {
  Future<UserData> signUpWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate a network delay
    final response = await ApiSdk.signUpWithEmailAndPassword(
        {'email': email, 'password': password});
    if (response["error"] != null) {
      throw FetchDataException('There is an error in request: ${response["error"]}');
    } else {
      final currentUser = UserData.fromJson(response);
      return currentUser;
    }
  }

  Future<UserData> loginWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate a network delay
    final response = await ApiSdk.loginWithEmailAndPassword(
        {'email': email, 'password': password});
    if (response["error"] != null) {
      throw FetchDataException('There is an error in request: ${response["error"]}');
    } else {
      final currentUser = UserData.fromJson(response);
      return currentUser;
    }
  }

  Future<UserInfo> getUserData(int id) async {
    final response = await ApiSdk.getUserData(id);
    final currentUserData = UserInfo.fromJson(response);
    return currentUserData;
  }
}
