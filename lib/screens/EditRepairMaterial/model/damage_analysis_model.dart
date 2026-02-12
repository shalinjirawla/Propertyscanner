class SurveyDamageResponse {
  bool? status;
  String? message;
  DamageData? data;

  SurveyDamageResponse({this.status, this.message, this.data});

  SurveyDamageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DamageData.fromJson(json['data']) : null;
  }
}

class DamageData {
  int? surveyId;
  int? damageId;
  String? damageName;
  String? mediaUrl;
  Analysis? analysis;

  DamageData({
    this.surveyId,
    this.damageId,
    this.damageName,
    this.mediaUrl,
    this.analysis,
  });

  DamageData.fromJson(Map<String, dynamic> json) {
    surveyId = json['survey_id'];
    damageId = json['damage_id'];
    damageName = json['damage_name'];
    mediaUrl = json['media_url'];
    analysis = json['analysis'] != null
        ? Analysis.fromJson(json['analysis'])
        : null;
  }
}

class Analysis {
  bool? success;
  String? severity;
  String? damageType;
  String? description;
  int? imageIndex;
  CostEstimate? costEstimate;
  List<String>? repairApproach;
  RecommendedProducts? recommendedProducts;

  Analysis({
    this.success,
    this.severity,
    this.damageType,
    this.description,
    this.imageIndex,
    this.costEstimate,
    this.repairApproach,
    this.recommendedProducts,
  });

  Analysis.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    severity = json['severity'];
    damageType = json['damage_type'];
    description = json['description'];
    imageIndex = json['image_index'];
    costEstimate = json['cost_estimate'] != null
        ? CostEstimate.fromJson(json['cost_estimate'])
        : null;
    repairApproach = json['repair_approach'].cast<String>();
    recommendedProducts = json['recommended_products'] != null
        ? RecommendedProducts.fromJson(json['recommended_products'])
        : null;
  }
}

class CostEstimate {
  var laborCost;
  var laborRate;
  var totalCost;
  var laborHours;
  var materialCost;

  CostEstimate({
    this.laborCost,
    this.laborRate,
    this.totalCost,
    this.laborHours,
    this.materialCost,
  });

  CostEstimate.fromJson(Map<String, dynamic> json) {
    laborCost = json['labor_cost'];
    laborRate = json['labor_rate'];
    totalCost = json['total_cost'];
    laborHours = json['labor_hours'];
    materialCost = json['material_cost'];
  }
}

class RecommendedProducts {
  Map<String, List<ProductItem>> products = {};

  RecommendedProducts.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value is List) {
        products[key] = value.map((i) {
          var item = ProductItem.fromJson(i);
          item.category = _formatCategory(key);
          return item;
        }).toList();
      }
    });
  }

  String _formatCategory(String key) {
    // Convert snake_case or space separated to Title Case
    // e.g. "paint_brush" -> "Paint Brush"
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((str) {
          if (str.isEmpty) return str;
          return "${str[0].toUpperCase()}${str.substring(1)}";
        })
        .join(' ');
  }

  List<ProductItem> getAllProducts() {
    return products.values.expand((element) => element).toList();
  }
}

class ProductItem {
  String? url;
  String? name;
  String? price;
  String? source;
  List<String>? features;
  String? imageUrl;
  var priceNumeric;
  String? category;

  ProductItem({
    this.url,
    this.name,
    this.price,
    this.source,
    this.features,
    this.imageUrl,
    this.priceNumeric,
    this.category,
  });

  ProductItem.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
    price = json['price'];
    source = json['source'];
    features = json['features'] != null
        ? json['features'].cast<String>()
        : null;
    imageUrl = json['image_url'];
    priceNumeric = json['price_numeric'];
  }
}

// Updated ProductItem with category field
