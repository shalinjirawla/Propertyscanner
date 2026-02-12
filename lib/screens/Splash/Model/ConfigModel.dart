// To parse this JSON data, do
//
//     final splashConfigModel = splashConfigModelFromJson(jsonString);

import 'dart:convert';

SplashConfigModel splashConfigModelFromJson(String str) => SplashConfigModel.fromJson(json.decode(str));

String splashConfigModelToJson(SplashConfigModel data) => json.encode(data.toJson());

class SplashConfigModel {
  bool? status;
  String? message;
  ConfigSplashData? data;

  SplashConfigModel({
    this.status,
    this.message,
    this.data,
  });

  factory SplashConfigModel.fromJson(Map<String, dynamic> json) => SplashConfigModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : ConfigSplashData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class ConfigSplashData {
  String? androidVersion;
  String? iosVersion;
  String? forceUpdate;
  String? maintenanceMode;

  ConfigSplashData({
    this.androidVersion,
    this.iosVersion,
    this.forceUpdate,
    this.maintenanceMode,
  });

  factory ConfigSplashData.fromJson(Map<String, dynamic> json) => ConfigSplashData(
    androidVersion: json["android_version"],
    iosVersion: json["ios_version"],
    forceUpdate: json["force_update"],
    maintenanceMode: json["maintenance_mode"],
  );

  Map<String, dynamic> toJson() => {
    "android_version": androidVersion,
    "ios_version": iosVersion,
    "force_update": forceUpdate,
    "maintenance_mode": maintenanceMode,
  };
}
