// To parse this JSON data, do
//
//     final cmsModel = cmsModelFromJson(jsonString);

import 'dart:convert';

CmsModel cmsModelFromJson(String str) => CmsModel.fromJson(json.decode(str));

String cmsModelToJson(CmsModel data) => json.encode(data.toJson());

class CmsModel {
  bool? status;
  String? message;
  cmsData? data;

  CmsModel({
    this.status,
    this.message,
    this.data,
  });

  factory CmsModel.fromJson(Map<String, dynamic> json) => CmsModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : cmsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class cmsData {
  int? id;
  String? slug;
  String? title;
  String? content;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  cmsData({
    this.id,
    this.slug,
    this.title,
    this.content,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory cmsData.fromJson(Map<String, dynamic> json) => cmsData(
    id: json["id"],
    slug: json["slug"],
    title: json["title"],
    content: json["content"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "title": title,
    "content": content,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
