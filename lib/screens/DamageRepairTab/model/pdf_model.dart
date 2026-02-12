// To parse this JSON data, do
//
//     final getPdfModel = getPdfModelFromJson(jsonString);

import 'dart:convert';

GetPdfModel getPdfModelFromJson(String str) => GetPdfModel.fromJson(json.decode(str));

String getPdfModelToJson(GetPdfModel data) => json.encode(data.toJson());

class GetPdfModel {
  bool? status;
  String? message;
  pdfData? data;

  GetPdfModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetPdfModel.fromJson(Map<String, dynamic> json) => GetPdfModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : pdfData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class pdfData {
  String? pdfUrl;

  pdfData({
    this.pdfUrl,
  });

  factory pdfData.fromJson(Map<String, dynamic> json) => pdfData(
    pdfUrl: json["pdf_url"],
  );

  Map<String, dynamic> toJson() => {
    "pdf_url": pdfUrl,
  };
}
