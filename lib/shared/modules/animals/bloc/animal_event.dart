import 'package:equatable/equatable.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/models/Animal.dart';

abstract class AnimalEvent extends Equatable {
  const AnimalEvent();

  @override
  List<Object> get props => [];
}

class RefreshAnimalList extends AnimalEvent {}

class LoadMoreAnimalList extends AnimalEvent {}

class GetAnimalDetail extends AnimalEvent {
  final int id;
  const GetAnimalDetail({required this.id});
}

class CreateAnimal extends AnimalEvent {
  final Animal animal;
  const CreateAnimal({required this.animal});
}

class EditAnimal extends AnimalEvent {
  final int id;
  final Animal animal;
  const EditAnimal({required this.id, required this.animal});
}

class DeleteAnimal extends AnimalEvent {
  final int id;
  const DeleteAnimal({required this.id});
}

