// To parse this JSON data, do
//
//     final getReportDetail = getReportDetailFromJson(jsonString);

import 'dart:convert';

GetReportDetail getReportDetailFromJson(String str) => GetReportDetail.fromJson(json.decode(str));

String getReportDetailToJson(GetReportDetail data) => json.encode(data.toJson());

class GetReportDetail {
  bool? status;
  String? message;
  ReportDetailData? data;

  GetReportDetail({
    this.status,
    this.message,
    this.data,
  });

  factory GetReportDetail.fromJson(Map<String, dynamic> json) => GetReportDetail(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : ReportDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class ReportDetailData {
  int? id;
  String? propertyName;
  String? propertyAddress;
  String? summary;
  String? captureVideo;
  String? pdf;
  List<Damage>? damages;

  ReportDetailData({
    this.id,
    this.propertyName,
    this.propertyAddress,
    this.summary,
    this.captureVideo,
    this.pdf,
    this.damages,
  });

  factory ReportDetailData.fromJson(Map<String, dynamic> json) => ReportDetailData(
    id: json["id"],
    propertyName: json["property_name"],
    propertyAddress: json["property_address"],
    summary: json["summary"],
    captureVideo: json["capture_video"],
    pdf: json["pdf"],
    damages: json["damages"] == null ? [] : List<Damage>.from(json["damages"]!.map((x) => Damage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_name": propertyName,
    "property_address": propertyAddress,
    "summary": summary,
    "capture_video": captureVideo,
    "pdf": pdf,
    "damages": damages == null ? [] : List<dynamic>.from(damages!.map((x) => x.toJson())),
  };
}

class Damage {
  int? id;
  int? surveyId;
  String? damageName;
  String? mediaUrl;
  String? severity;

  Damage({
    this.id,
    this.surveyId,
    this.damageName,
    this.mediaUrl,
    this.severity,
  });

  factory Damage.fromJson(Map<String, dynamic> json) => Damage(
    id: json["id"],
    surveyId: json["survey_id"],
    damageName: json["damage_name"],
    mediaUrl: json["media_url"],
    severity: json["severity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "survey_id": surveyId,
    "damage_name": damageName,
    "media_url": mediaUrl,
    "severity": severity,
  };
}
