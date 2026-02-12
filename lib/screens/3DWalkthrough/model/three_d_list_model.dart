// To parse this JSON data, do
//
//     final getThreeDModel = getThreeDModelFromJson(jsonString);

import 'dart:convert';

GetThreeDModel getThreeDModelFromJson(String str) => GetThreeDModel.fromJson(json.decode(str));

String getThreeDModelToJson(GetThreeDModel data) => json.encode(data.toJson());

class GetThreeDModel {
  bool? status;
  String? message;
  List<ThreeDModelData>? data;

  GetThreeDModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetThreeDModel.fromJson(Map<String, dynamic> json) => GetThreeDModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ThreeDModelData>.from(json["data"]!.map((x) => ThreeDModelData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ThreeDModelData {
  int? id;
  String? propertyName;
  String? propertyAddress;
  String? modelUrl;
  String? modelType;
  String? dimension;
  DateTime? createdAt;

  ThreeDModelData({
    this.id,
    this.propertyName,
    this.propertyAddress,
    this.modelUrl,
    this.modelType,
    this.dimension,
    this.createdAt,
  });

  factory ThreeDModelData.fromJson(Map<String, dynamic> json) => ThreeDModelData(
    id: json["id"],
    propertyName: json["property_name"],
    propertyAddress: json["property_address"],
    modelUrl: json["model_url"],
    dimension: json["dimensions"],
    modelType: json["model_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_name": propertyName,
    "property_address": propertyAddress,
    "model_url": modelUrl,
    "model_type": modelType,
    "dimensions": dimension,
    "created_at": createdAt?.toIso8601String(),
  };
}
