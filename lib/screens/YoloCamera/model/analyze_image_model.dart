// To parse this JSON data, do
//
//     final getAnalyzeImageModel = getAnalyzeImageModelFromJson(jsonString);

import 'dart:convert';

GetAnalyzeImageModel getAnalyzeImageModelFromJson(String str) => GetAnalyzeImageModel.fromJson(json.decode(str));

String getAnalyzeImageModelToJson(GetAnalyzeImageModel data) => json.encode(data.toJson());

class GetAnalyzeImageModel {
  bool? status;
  String? message;
  AnalyzeModeldata? data;

  GetAnalyzeImageModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetAnalyzeImageModel.fromJson(Map<String, dynamic> json) => GetAnalyzeImageModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : AnalyzeModeldata.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class AnalyzeModeldata {
  String? mediaUrl;
  Analysis? analysis;

  AnalyzeModeldata({
    this.mediaUrl,
    this.analysis,
  });

  factory AnalyzeModeldata.fromJson(Map<String, dynamic> json) => AnalyzeModeldata(
    mediaUrl: json["media_url"],
    analysis: json["analysis"] == null ? null : Analysis.fromJson(json["analysis"]),
  );

  Map<String, dynamic> toJson() => {
    "media_url": mediaUrl,
    "analysis": analysis?.toJson(),
  };
}

class Analysis {
  int? count;
  List<Result>? results;
  bool? success;

  Analysis({
    this.count,
    this.results,
    this.success,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) => Analysis(
    count: json["count"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    "success": success,
  };
}

class Result {
  CostEstimate? costEstimate;
  String? damageType;
  String? description;
  int? imageIndex;
  RecommendedProducts? recommendedProducts;
  List<String>? repairApproach;
  String? severity;
  bool? success;

  Result({
    this.costEstimate,
    this.damageType,
    this.description,
    this.imageIndex,
    this.recommendedProducts,
    this.repairApproach,
    this.severity,
    this.success,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    costEstimate: json["cost_estimate"] == null ? null : CostEstimate.fromJson(json["cost_estimate"]),
    damageType: json["damage_type"],
    description: json["description"],
    imageIndex: json["image_index"],
    recommendedProducts: json["recommended_products"] == null ? null : RecommendedProducts.fromJson(json["recommended_products"]),
    repairApproach: json["repair_approach"] == null ? [] : List<String>.from(json["repair_approach"]!.map((x) => x)),
    severity: json["severity"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "cost_estimate": costEstimate?.toJson(),
    "damage_type": damageType,
    "description": description,
    "image_index": imageIndex,
    "recommended_products": recommendedProducts?.toJson(),
    "repair_approach": repairApproach == null ? [] : List<dynamic>.from(repairApproach!.map((x) => x)),
    "severity": severity,
    "success": success,
  };
}

class CostEstimate {
  int? laborCost;
  int? laborHours;
  int? laborRate;
  double? materialCost;
  double? totalCost;

  CostEstimate({
    this.laborCost,
    this.laborHours,
    this.laborRate,
    this.materialCost,
    this.totalCost,
  });

  factory CostEstimate.fromJson(Map<String, dynamic> json) => CostEstimate(
    laborCost: json["labor_cost"],
    laborHours: json["labor_hours"],
    laborRate: json["labor_rate"],
    materialCost: json["material_cost"]?.toDouble(),
    totalCost: json["total_cost"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "labor_cost": laborCost,
    "labor_hours": laborHours,
    "labor_rate": laborRate,
    "material_cost": materialCost,
    "total_cost": totalCost,
  };
}

class RecommendedProducts {
  List<CrackFiller>? crackFiller;
  List<CrackFiller>? interiorWallPaint;
  List<CrackFiller>? paintRoller;
  List<CrackFiller>? primer;
  List<CrackFiller>? puttyKnife;
  List<CrackFiller>? puttyTrowel;
  List<CrackFiller>? readyMixPlaster;
  List<CrackFiller>? sandpaper;
  List<CrackFiller>? wallPutty;

  RecommendedProducts({
    this.crackFiller,
    this.interiorWallPaint,
    this.paintRoller,
    this.primer,
    this.puttyKnife,
    this.puttyTrowel,
    this.readyMixPlaster,
    this.sandpaper,
    this.wallPutty,
  });

  factory RecommendedProducts.fromJson(Map<String, dynamic> json) => RecommendedProducts(
    crackFiller: json["crack filler"] == null ? [] : List<CrackFiller>.from(json["crack filler"]!.map((x) => CrackFiller.fromJson(x))),
    interiorWallPaint: json["interior wall paint"] == null ? [] : List<CrackFiller>.from(json["interior wall paint"]!.map((x) => CrackFiller.fromJson(x))),
    paintRoller: json["paint roller"] == null ? [] : List<CrackFiller>.from(json["paint roller"]!.map((x) => CrackFiller.fromJson(x))),
    primer: json["primer"] == null ? [] : List<CrackFiller>.from(json["primer"]!.map((x) => CrackFiller.fromJson(x))),
    puttyKnife: json["putty knife"] == null ? [] : List<CrackFiller>.from(json["putty knife"]!.map((x) => CrackFiller.fromJson(x))),
    puttyTrowel: json["putty trowel"] == null ? [] : List<CrackFiller>.from(json["putty trowel"]!.map((x) => CrackFiller.fromJson(x))),
    readyMixPlaster: json["ready mix plaster"] == null ? [] : List<CrackFiller>.from(json["ready mix plaster"]!.map((x) => CrackFiller.fromJson(x))),
    sandpaper: json["sandpaper"] == null ? [] : List<CrackFiller>.from(json["sandpaper"]!.map((x) => CrackFiller.fromJson(x))),
    wallPutty: json["wall putty"] == null ? [] : List<CrackFiller>.from(json["wall putty"]!.map((x) => CrackFiller.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "crack filler": crackFiller == null ? [] : List<dynamic>.from(crackFiller!.map((x) => x.toJson())),
    "interior wall paint": interiorWallPaint == null ? [] : List<dynamic>.from(interiorWallPaint!.map((x) => x.toJson())),
    "paint roller": paintRoller == null ? [] : List<dynamic>.from(paintRoller!.map((x) => x.toJson())),
    "primer": primer == null ? [] : List<dynamic>.from(primer!.map((x) => x.toJson())),
    "putty knife": puttyKnife == null ? [] : List<dynamic>.from(puttyKnife!.map((x) => x.toJson())),
    "putty trowel": puttyTrowel == null ? [] : List<dynamic>.from(puttyTrowel!.map((x) => x.toJson())),
    "ready mix plaster": readyMixPlaster == null ? [] : List<dynamic>.from(readyMixPlaster!.map((x) => x.toJson())),
    "sandpaper": sandpaper == null ? [] : List<dynamic>.from(sandpaper!.map((x) => x.toJson())),
    "wall putty": wallPutty == null ? [] : List<dynamic>.from(wallPutty!.map((x) => x.toJson())),
  };
}

class CrackFiller {
  List<Feature>? features;
  String? imageUrl;
  String? name;
  String? price;
  double? priceNumeric;
  String? source;
  String? url;

  CrackFiller({
    this.features,
    this.imageUrl,
    this.name,
    this.price,
    this.priceNumeric,
    this.source,
    this.url,
  });

  factory CrackFiller.fromJson(Map<String, dynamic> json) => CrackFiller(
    features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => featureValues.map[x]!)),
    imageUrl: json["image_url"],
    name: json["name"],
    price: json["price"],
    priceNumeric: json["price_numeric"]?.toDouble(),
    source: json["source"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => featureValues.reverse[x])),
    "image_url": imageUrl,
    "name": name,
    "price": price,
    "price_numeric": priceNumeric,
    "source": source,
    "url": url,
  };
}

enum Feature {
  DURABLE,
  EASY_TO_USE,
  PROFESSIONAL_QUALITY
}

final featureValues = EnumValues({
  "Durable": Feature.DURABLE,
  "Easy to use": Feature.EASY_TO_USE,
  "Professional quality": Feature.PROFESSIONAL_QUALITY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}



