// To parse this JSON data, do
//
//     final getReportRepairModel = getReportRepairModelFromJson(jsonString);

import 'dart:convert';

GetReportRepairModel getReportRepairModelFromJson(String str) => GetReportRepairModel.fromJson(json.decode(str));

String getReportRepairModelToJson(GetReportRepairModel data) => json.encode(data.toJson());

class GetReportRepairModel {
  bool? status;
  String? message;
  ReportRepairData? data;

  GetReportRepairModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetReportRepairModel.fromJson(Map<String, dynamic> json) => GetReportRepairModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : ReportRepairData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class ReportRepairData {
  int? surveyId;
  int? damageId;
  String? damageName;
  String? mediaUrl;
  Analysis? analysis;

  ReportRepairData({
    this.surveyId,
    this.damageId,
    this.damageName,
    this.mediaUrl,
    this.analysis,
  });

  factory ReportRepairData.fromJson(Map<String, dynamic> json) => ReportRepairData(
    surveyId: json["survey_id"],
    damageId: json["damage_id"],
    damageName: json["damage_name"],
    mediaUrl: json["media_url"],
    analysis: json["analysis"] == null ? null : Analysis.fromJson(json["analysis"]),
  );

  Map<String, dynamic> toJson() => {
    "survey_id": surveyId,
    "damage_id": damageId,
    "damage_name": damageName,
    "media_url": mediaUrl,
    "analysis": analysis?.toJson(),
  };
}

class Analysis {
  bool? success;
  String? filename;
  String? severity;
  String? damageType;
  String? description;
  int? imageIndex;
  CostEstimate? costEstimate;
  double? processingTime;
  List<String>? repairApproach;
  RecommendedProducts? recommendedProducts;

  Analysis({
    this.success,
    this.filename,
    this.severity,
    this.damageType,
    this.description,
    this.imageIndex,
    this.costEstimate,
    this.processingTime,
    this.repairApproach,
    this.recommendedProducts,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) => Analysis(
    success: json["success"],
    filename: json["filename"],
    severity: json["severity"],
    damageType: json["damage_type"],
    description: json["description"],
    imageIndex: json["image_index"],
    costEstimate: json["cost_estimate"] == null ? null : CostEstimate.fromJson(json["cost_estimate"]),
    processingTime: json["processing_time"]?.toDouble(),
    repairApproach: json["repair_approach"] == null ? [] : List<String>.from(json["repair_approach"]!.map((x) => x)),
    recommendedProducts: json["recommended_products"] == null ? null : RecommendedProducts.fromJson(json["recommended_products"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "filename": filename,
    "severity": severity,
    "damage_type": damageType,
    "description": description,
    "image_index": imageIndex,
    "cost_estimate": costEstimate?.toJson(),
    "processing_time": processingTime,
    "repair_approach": repairApproach == null ? [] : List<dynamic>.from(repairApproach!.map((x) => x)),
    "recommended_products": recommendedProducts?.toJson(),
  };
}

class CostEstimate {
  int? laborCost;
  int? laborRate;
  double? totalCost;
  int? laborHours;
  double? materialCost;

  CostEstimate({
    this.laborCost,
    this.laborRate,
    this.totalCost,
    this.laborHours,
    this.materialCost,
  });

  factory CostEstimate.fromJson(Map<String, dynamic> json) => CostEstimate(
    laborCost: json["labor_cost"],
    laborRate: json["labor_rate"],
    totalCost: json["total_cost"]?.toDouble(),
    laborHours: json["labor_hours"],
    materialCost: json["material_cost"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "labor_cost": laborCost,
    "labor_rate": laborRate,
    "total_cost": totalCost,
    "labor_hours": laborHours,
    "material_cost": materialCost,
  };
}

class RecommendedProducts {
  List<EpoxyWoodRepair>? scraper;
  List<EpoxyWoodRepair>? sandpaper;
  List<EpoxyWoodRepair>? paintBrush;
  List<EpoxyWoodRepair>? puttyKnife;
  List<EpoxyWoodRepair>? sealingCoat;
  List<EpoxyWoodRepair>? woodHardener;
  List<EpoxyWoodRepair>? epoxyWoodRepair;
  Map<String, dynamic>? rawJson;

  RecommendedProducts({
    this.scraper,
    this.sandpaper,
    this.paintBrush,
    this.puttyKnife,
    this.sealingCoat,
    this.woodHardener,
    this.epoxyWoodRepair,
    this.rawJson,
  });

  factory RecommendedProducts.fromJson(Map<String, dynamic> json) => RecommendedProducts(
    scraper: json["scraper"] == null ? [] : List<EpoxyWoodRepair>.from(json["scraper"]!.map((x) => EpoxyWoodRepair.fromJson(x))),
    sandpaper: json["sandpaper"] == null ? [] : List<EpoxyWoodRepair>.from(json["sandpaper"]!.map((x) => EpoxyWoodRepair.fromJson(x))),
    paintBrush: json["paint_brush"] == null ? [] : List<EpoxyWoodRepair>.from(json["paint_brush"]!.map((x) => EpoxyWoodRepair.fromJson(x))),
    puttyKnife: json["putty_knife"] == null ? [] : List<EpoxyWoodRepair>.from(json["putty_knife"]!.map((x) => EpoxyWoodRepair.fromJson(x))),
    sealingCoat: json["sealing_coat"] == null ? [] : List<EpoxyWoodRepair>.from(json["sealing_coat"]!.map((x) => EpoxyWoodRepair.fromJson(x))),
    woodHardener: json["wood_hardener"] == null ? [] : List<EpoxyWoodRepair>.from(json["wood_hardener"]!.map((x) => EpoxyWoodRepair.fromJson(x))),
    epoxyWoodRepair: json["epoxy_wood_repair"] == null ? [] : List<EpoxyWoodRepair>.from(json["epoxy_wood_repair"]!.map((x) => EpoxyWoodRepair.fromJson(x))),
    rawJson: json,
  );


  Map<String, dynamic> toJson() => {
    "scraper": scraper == null ? [] : List<dynamic>.from(scraper!.map((x) => x.toJson())),
    "sandpaper": sandpaper == null ? [] : List<dynamic>.from(sandpaper!.map((x) => x.toJson())),
    "paint_brush": paintBrush == null ? [] : List<dynamic>.from(paintBrush!.map((x) => x.toJson())),
    "putty_knife": puttyKnife == null ? [] : List<dynamic>.from(puttyKnife!.map((x) => x.toJson())),
    "sealing_coat": sealingCoat == null ? [] : List<dynamic>.from(sealingCoat!.map((x) => x.toJson())),
    "wood_hardener": woodHardener == null ? [] : List<dynamic>.from(woodHardener!.map((x) => x.toJson())),
    "epoxy_wood_repair": epoxyWoodRepair == null ? [] : List<dynamic>.from(epoxyWoodRepair!.map((x) => x.toJson())),
  };
}

class EpoxyWoodRepair {
  String? url;
  String? name;
  String? price;
  String? source;
  List<String>? features;
  String? imageUrl;
  double? priceNumeric;

  EpoxyWoodRepair({
    this.url,
    this.name,
    this.price,
    this.source,
    this.features,
    this.imageUrl,
    this.priceNumeric,
  });

  factory EpoxyWoodRepair.fromJson(Map<String, dynamic> json) => EpoxyWoodRepair(
    url: json["url"],
    name: json["name"],
    price: json["price"],
    source: json["source"],
    features: json["features"] == null ? [] : List<String>.from(json["features"]!.map((x) => x)),
    imageUrl: json["image_url"],
    priceNumeric: json["price_numeric"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "name": name,
    "price": price,
    "source": source,
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
    "image_url": imageUrl,
    "price_numeric": priceNumeric,
  };
}


class EditableProduct {
  EpoxyWoodRepair product;
  int quantity;
  double unitPrice;

  EditableProduct({
    required this.product,
    this.quantity = 1,
    double? unitPrice,
  }) : unitPrice = unitPrice ?? (product.priceNumeric ?? 0.0);

  double get totalPrice => unitPrice * quantity;
}