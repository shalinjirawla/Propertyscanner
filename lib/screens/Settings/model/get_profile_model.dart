// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) => GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) => json.encode(data.toJson());

class GetProfileModel {
  bool? status;
  String? message;
  ProfileData? data;

  GetProfileModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileData {
  int? id;
  String? name;
  String? email;
  String? profilePic;
  String? role;
  String? socialType;
  String? socialId;
  dynamic gender;
  dynamic emailVerifiedAt;
  int? isActive;
  String? fcmToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProfileData({
    this.id,
    this.name,
    this.email,
    this.profilePic,
    this.role,
    this.socialType,
    this.socialId,
    this.gender,
    this.emailVerifiedAt,
    this.isActive,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    profilePic: json["profile_pic"],
    role: json["role"],
    socialType: json["social_type"],
    socialId: json["social_id"],
    gender: json["gender"],
    emailVerifiedAt: json["email_verified_at"],
    isActive: json["is_active"],
    fcmToken: json["fcm_token"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profile_pic": profilePic,
    "role": role,
    "social_type": socialType,
    "social_id": socialId,
    "gender": gender,
    "email_verified_at": emailVerifiedAt,
    "is_active": isActive,
    "fcm_token": fcmToken,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
