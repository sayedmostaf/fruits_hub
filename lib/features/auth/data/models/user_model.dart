import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String name, email, uid;
  final String? imageUrl;
  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    this.imageUrl,
  }) : super(name: name, email: email, uid: uid, imageUrl: imageUrl);
  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      name: userEntity.name,
      email: userEntity.email,
      uid: userEntity.uid,
      imageUrl: userEntity.imageUrl,
    );
  }

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      name: user.displayName ?? AppStrings.noName.tr(),
      email: user.email ?? AppStrings.noEmail.tr(),
      uid: user.uid,
      imageUrl: user.photoURL,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'uid': uid, 'imageUrl': imageUrl};
  }

  @override
  UserModel copyWith({
    String? name,
    String? email,
    String? uid,
    String? imageUrl,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
