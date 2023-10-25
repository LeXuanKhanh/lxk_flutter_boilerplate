import 'package:equatable/equatable.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/models/Animal.dart';

abstract class AnimalState extends Equatable {
  final List<Animal> animals;
  final bool canLoadMore;

  const AnimalState({required this.animals, required this.canLoadMore});

  @override
  List<Object> get props => [animals, canLoadMore];
}

class AnimalInitial extends AnimalState {
  AnimalInitial() : super(animals: [], canLoadMore: true);
}

class AnimalLoading extends AnimalState {
  const AnimalLoading({required super.animals, required super.canLoadMore});
}

class NewAnimalListData extends AnimalState {
  const NewAnimalListData({required super.animals, required super.canLoadMore});
}

class NewAnimalData extends AnimalState {
  final Animal animal;
  const NewAnimalData({
    required this.animal,
    required super.animals,
    required super.canLoadMore
  });
}

class AnimalFailure extends AnimalState {
  final String message;

  const AnimalFailure({this.message = '',
    required super.animals,
    required super.canLoadMore
  });

  @override
  List<Object> get props => [message];
}