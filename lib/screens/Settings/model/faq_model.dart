// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  bool? status;
  String? message;
  List<FaqsData>? data;

  FaqModel({
    this.status,
    this.message,
    this.data,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<FaqsData>.from(json["data"]!.map((x) => FaqsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FaqsData {
  int? id;
  String? question;
  String? answer;
  DateTime? createdAt;
  DateTime? updatedAt;

  FaqsData({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
  });

  factory FaqsData.fromJson(Map<String, dynamic> json) => FaqsData(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
