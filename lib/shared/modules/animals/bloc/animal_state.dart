import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lxk_flutter_boilerplate/shared/modules/animals/models/Animal.dart';
import 'package:flutter/foundation.dart';

part 'animal_state.freezed.dart';

enum AnimalStatus {
  initial,
  loading,
  error,
  newList,
  newData,
}

@freezed
class AnimalState with _$AnimalState {
  const factory AnimalState({
    @Default(AnimalStatus.initial) AnimalStatus status,
    @Default([]) List<Animal> animals,
    Animal? animal,
    @Default(1) int page,
    @Default(true) bool canLoadMore,
    @Default('') String message,
  }) = _AnimalState;

  const AnimalState._();

  AnimalState toStateLoading() {
    return copyWith(status: AnimalStatus.loading);
  }

  AnimalState toStateError({String message = ''}) {
    return copyWith(status: AnimalStatus.error);
  }
}