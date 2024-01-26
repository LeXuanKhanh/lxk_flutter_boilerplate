import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

// quick and small user data, only use in login api

@freezed
class UserData with _$UserData {
  @JsonSerializable(
    fieldRename: FieldRename.snake
  )
  const factory UserData({
    @Default(-1) int id,
    @Default('') String token
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
