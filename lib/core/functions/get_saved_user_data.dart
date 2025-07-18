import 'dart:convert';

import 'package:fruits_hub/core/services/shared_preferences.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/features/auth/data/models/user_model.dart';
import 'package:fruits_hub/features/auth/domain/entities/user_entity.dart';

UserEntity getSavedUserData() {
  final String jsonUser = Pref.getString(Constants.userData);
  final UserEntity userEntity = UserModel.fromJson(jsonDecode(jsonUser));
  return userEntity;
}
