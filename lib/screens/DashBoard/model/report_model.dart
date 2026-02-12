// To parse this JSON data, do
//
//     final getReportModel = getReportModelFromJson(jsonString);

import 'dart:convert';

GetReportModel getReportModelFromJson(String str) => GetReportModel.fromJson(json.decode(str));

String getReportModelToJson(GetReportModel data) => json.encode(data.toJson());

class GetReportModel {
  bool? status;
  String? message;
  List<ReportData>? data;

  GetReportModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetReportModel.fromJson(Map<String, dynamic> json) => GetReportModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ReportData>.from(json["data"]!.map((x) => ReportData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ReportData {
  int? id;
  String? propertyName;
  String? propertyAddress;
  String? status;
  dynamic pdf;
  DateTime? createdAt;

  ReportData({
    this.id,
    this.propertyName,
    this.propertyAddress,
    this.status,
    this.pdf,
    this.createdAt,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
    id: json["id"],
    propertyName: json["property_name"],
    propertyAddress: json["property_address"],
    status: json["status"],
    pdf: json["pdf"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_name": propertyName,
    "property_address": propertyAddress,
    "status": status,
    "pdf": pdf,
    "created_at": createdAt?.toIso8601String(),
  };
}
