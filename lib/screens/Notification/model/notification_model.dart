// To parse this JSON data, do
//
//     final getNotificationModel = getNotificationModelFromJson(jsonString);

import 'dart:convert';

GetNotificationModel getNotificationModelFromJson(String str) => GetNotificationModel.fromJson(json.decode(str));

String getNotificationModelToJson(GetNotificationModel data) => json.encode(data.toJson());

class GetNotificationModel {
  bool? status;
  String? message;
  NotificationData? notificationData;

  GetNotificationModel({
    this.status,
    this.message,
    this.notificationData,
  });

  factory GetNotificationModel.fromJson(Map<String, dynamic> json) => GetNotificationModel(
    status: json["status"],
    message: json["message"],
    notificationData: json["notification_data"] == null ? null : NotificationData.fromJson(json["notification_data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "notification_data": notificationData?.toJson(),
  };
}

class NotificationData {
  int? notificationCount;
  List<NotificationListData>? data;

  NotificationData({
    this.notificationCount,
    this.data,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    notificationCount: json["notification_count"],
    data: json["data"] == null ? [] : List<NotificationListData>.from(json["data"]!.map((x) => NotificationListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "notification_count": notificationCount,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NotificationListData {
  int? id;
  String? title;
  String? message;
  bool? isRead;
  String? createdAt;

  NotificationListData({
    this.id,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
  });

  factory NotificationListData.fromJson(Map<String, dynamic> json) => NotificationListData(
    id: json["id"],
    title: json["title"],
    message: json["message"],
    isRead: json["is_read"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "message": message,
    "is_read": isRead,
    "created_at": createdAt,
  };
}
