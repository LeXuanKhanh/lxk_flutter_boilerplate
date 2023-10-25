import 'package:lxk_flutter_boilerplate/api_sdk/api_sdk.dart';

class AnimalRepository {
  Future<dynamic> getAnimals(int page, int limit) async {
    final response = await ApiSdk.getAnimals(page, limit);
    return response;
  }

  Future<dynamic> getAnimal(int id) async {
    final response = await ApiSdk.getAnimal(id);
    return response;
  }

  Future<dynamic> createAnimal(body) async {
    final response = await ApiSdk.addAnimal(body);
    return response;
  }

  Future<dynamic> editAnimal(int id, body) async {
    final response = await ApiSdk.editAnimal(id, body);
    return response;
  }

  Future<dynamic> deleteAnimal(int id) async {
    final response = await ApiSdk.deleteAnimal(id);
    return response;
  }
}