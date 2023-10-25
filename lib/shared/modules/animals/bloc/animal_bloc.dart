import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import '/shared/modules/animals/bloc/animal_event.dart';
import '/shared/modules/animals/bloc/animal_state.dart';
import '/shared/modules/animals/models/Animal.dart';
import '/shared/modules/animals/resources/animal_repository.dart';

class AnimalBloc extends Bloc<AnimalEvent, AnimalState> {
  final AnimalRepository animalRepo = AnimalRepository();

  int page = 1;
  final int limit = 15;
  List<Animal> animals = [];
  bool canLoadMore = true;
  Animal? currentAnimal;

  AnimalBloc() : super(AnimalInitial()) {
    on<RefreshAnimalList>(_refreshListAnimal);
    on<LoadMoreAnimalList>(_loadMoreListAnimal);
    on<CreateAnimal>(_createAnimal);
    on<EditAnimal>(_editAnimal);
    on<DeleteAnimal>(_deleteAnimal);
  }

  void _refreshListAnimal(RefreshAnimalList event, Emitter<AnimalState> emit) async {
    emit(AnimalLoading(animals: animals, canLoadMore: canLoadMore));
    page = 1;
    canLoadMore = true;
    final res = await animalRepo.getAnimals(page, limit);
    final list = animalListFromJsonList(res); //animalListFromJson(res);
    animals = [];
    if (list.isNotEmpty) {
      canLoadMore = true;
      page++;
      animals.addAll(list);
    } else {
      canLoadMore = false;
    }

    emit(NewAnimalListData(animals: animals, canLoadMore: canLoadMore));
    // try {
    //   final res = await animalRepo.getAnimals(page, limit);
    //   final list = animalListFromJsonList(res); //animalListFromJson(res);
    //   animals = list;
    //   if (list.isNotEmpty) {
    //     canLoadMore = true;
    //     page++;
    //     animals.addAll(list);
    //   } else {
    //     canLoadMore = false;
    //   }
    //
    //   emit(NewAnimalListData(animals: animals, canLoadMore: canLoadMore));
    // } catch (e,stackTrace) {
    //   debugPrintStack(stackTrace: stackTrace);
    //   emit(AnimalFailure(message: e.toString()));
    // }
  }

  void _loadMoreListAnimal(LoadMoreAnimalList event, Emitter<AnimalState> emit) async {
    emit(AnimalLoading(animals: animals, canLoadMore: canLoadMore));
    try {
      final data = await animalRepo.getAnimals(page, limit);
      final list = animalListFromJsonList(data);
      if (list.isNotEmpty) {
        canLoadMore = true;
        page++;
        animals.addAll(list);
      } else {
        canLoadMore = false;
      }

      emit(NewAnimalListData(animals: animals, canLoadMore: canLoadMore));
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      emit(AnimalFailure(
          message: e.toString(),
          animals: animals,
          canLoadMore: canLoadMore));
    }
  }

  void _createAnimal(CreateAnimal event, Emitter<AnimalState> emit) async {
    emit(AnimalLoading(animals: animals, canLoadMore: canLoadMore));
    try {
      var newAnimal = event.animal;
      final data = await animalRepo.createAnimal(newAnimal.toJson());
      newAnimal = Animal.fromJson(data);
      emit(NewAnimalData(animal: newAnimal, animals: animals, canLoadMore: canLoadMore));
      add(RefreshAnimalList());
    } catch (e, stacktrace) {
      debugPrintStack(label: e.toString(), stackTrace: stacktrace);
      emit(AnimalFailure(
          message: e.toString(),
          animals: animals,
          canLoadMore: canLoadMore));
    }
  }

  void _editAnimal(EditAnimal event, Emitter<AnimalState> emit) async {
    emit(AnimalLoading(animals: animals, canLoadMore: canLoadMore));
    try {
      var editAnimal = event.animal.copyWith();
      final data = await animalRepo.editAnimal(event.id, editAnimal.toJson());
      final newAnimal = Animal.fromJson(data);
      emit(NewAnimalData(animal: newAnimal, animals: animals, canLoadMore: canLoadMore));
      add(RefreshAnimalList());
      //final newAnimal = Animal.fromJson(data);
      // var editIndex = animals.indexWhere((element) => element.id == newAnimal.id);
      // animals[editIndex] = newAnimal;
      // emit(NewAnimalListData(animals: animals, canLoadMore: canLoadMore));
    } catch (e, stacktrace) {
      debugPrintStack(label: e.toString(), stackTrace: stacktrace);
      emit(AnimalFailure(
          message: e.toString(),
          animals: animals,
          canLoadMore: canLoadMore));
    }
  }

  void _deleteAnimal(DeleteAnimal event, Emitter<AnimalState> emit) async {
    emit(AnimalLoading(animals: animals, canLoadMore: canLoadMore));
    try {
      await animalRepo.deleteAnimal(event.id);
      add(RefreshAnimalList());
    } catch (e) {
      emit(AnimalFailure(
          message: e.toString(),
          animals: animals,
          canLoadMore: canLoadMore));
    }
  }

}