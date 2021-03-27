// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    points: json['points'] as int,
    age: json['age'] as String,
    gender: json['gender'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    ip: json['ip'] as String,
    type: json['type'] as int,
    uid: json['uid'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'points': instance.points,
      'age': instance.age,
      'uid': instance.uid,
      'username': instance.username,
      'gender': instance.gender,
      'email': instance.email,
      'ip': instance.ip,
      'type': instance.type,
    };
