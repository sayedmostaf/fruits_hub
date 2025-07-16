import 'dart:developer';

class UserEntity {
  final String name, email, uid;
  String? imageUrl;
  UserEntity({
    required this.name,
    required this.email,
    required this.uid,
    this.imageUrl,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      uid: json['uid'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  UserEntity copyWith({
    String? name,
    String? email,
    String? uid,
    String? imageUrl,
  }) {
    return UserEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    log('UserEntity: name=$name, email=$email, uid=$uid, imageUrl=$imageUrl');
    return 'UserEntity(name: $name, email: $email, uid: $uid, imageUrl: $imageUrl)';
  }
}
