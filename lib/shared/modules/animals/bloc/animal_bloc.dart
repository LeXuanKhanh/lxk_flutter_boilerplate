import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/bloc/animal_event.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/bloc/animal_state.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/models/Animal.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/resources/animal_repository.dart';

class AnimalBloc extends Bloc<AnimalEvent, AnimalState> {
  final AnimalRepository animalRepo = AnimalRepository();
  final int limit = 15;

  AnimalBloc() : super(const AnimalState()) {
    on<RefreshAnimalList>(_refreshListAnimal);
    on<LoadMoreAnimalList>(_loadMoreListAnimal);
    on<CreateAnimal>(_createAnimal);
    on<EditAnimal>(_editAnimal);
    on<DeleteAnimal>(_deleteAnimal);
  }

  void _refreshListAnimal(RefreshAnimalList event,
      Emitter<AnimalState> emit) async {
    emit(state.toStateLoading());
    try {
      const int page = 1;
      bool canLoadMore = true;
      final res = await animalRepo.getAnimals(page, limit);
      final newList = animalListFromJsonList(res); //animalListFromJson(res);
      final List<Animal> totalList = [];
      if (newList.length < limit) {
        canLoadMore = false;
      } else if (newList.isNotEmpty) {
        totalList.addAll(newList);
      }

      emit(state.copyWith(
          status: AnimalStatus.newList,
          animals: totalList,
          page: page,
          canLoadMore: canLoadMore
      ));
    } catch (e, stacktrace) {
      debugPrintStack(label: e.toString(), stackTrace: stacktrace);
      emit(state.toStateError(message: e.toString()));
    }
  }

  void _loadMoreListAnimal(LoadMoreAnimalList event,
      Emitter<AnimalState> emit) async {
    emit(state.toStateLoading());
    try {
      final int page = state.page + 1;
      bool canLoadMore = true;
      final totalList = List<Animal>.from(state.animals);
      final data = await animalRepo.getAnimals(page, limit);
      final newList = animalListFromJsonList(data);
      if (newList.length < limit) {
        canLoadMore = false;
      } else if (newList.isNotEmpty) {
        totalList.addAll(newList);
      }

      emit(state.copyWith(
          status: AnimalStatus.newList,
          animals: totalList,
          page: page,
          canLoadMore: canLoadMore
      ));
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      emit(state.toStateError(message: e.toString()));
    }
  }

  void _createAnimal(CreateAnimal event, Emitter<AnimalState> emit) async {
    emit(state.toStateLoading());
    try {
      var newAnimal = event.animal;
      final data = await animalRepo.createAnimal(newAnimal.toJson());
      newAnimal = Animal.fromJson(data);
      emit(state.copyWith(
        status: AnimalStatus.newData,
        animal: newAnimal,
      ));
      add(RefreshAnimalList());
    } catch (e, stacktrace) {
      debugPrintStack(label: e.toString(), stackTrace: stacktrace);
      emit(state.toStateError(message: e.toString()));
    }
  }

  void _editAnimal(EditAnimal event, Emitter<AnimalState> emit) async {
    emit(state.toStateLoading());
    try {
      var editAnimal = event.animal.copyWith();
      final data = await animalRepo.editAnimal(event.id, editAnimal.toJson());
      final newAnimal = Animal.fromJson(data);
      emit(state.copyWith(
        status: AnimalStatus.newData,
        animal: newAnimal,
      ));
      add(RefreshAnimalList());
      //final newAnimal = Animal.fromJson(data);
      // var editIndex = animals.indexWhere((element) => element.id == newAnimal.id);
      // animals[editIndex] = newAnimal;
      // emit(NewAnimalListData(animals: animals, canLoadMore: canLoadMore));
    } catch (e, stacktrace) {
      debugPrintStack(label: e.toString(), stackTrace: stacktrace);
      emit(state.toStateError(message: e.toString()));
    }
  }

  void _deleteAnimal(DeleteAnimal event, Emitter<AnimalState> emit) async {
    emit(state.toStateLoading());
    try {
      await animalRepo.deleteAnimal(event.id);
      add(RefreshAnimalList());
    } catch (e) {
      emit(state.toStateError(message: e.toString()));
    }
  }
}