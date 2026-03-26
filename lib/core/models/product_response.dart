// To parse this JSON data, do
//
//     final productResponse = productResponseFromJson(jsonString);

import 'dart:convert';

ProductResponse productResponseFromJson(String str) => ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) => json.encode(data.toJson());

class ProductResponse {
  Data data;

  ProductResponse({
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  List<Product>? products;
  Meta? meta;
  Pagination? pagination;

  Data({
    this.products,
    this.meta,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
    "pagination": pagination?.toJson(),
  };
}

class Meta {
  bool? cached;
  DateTime? timestamp;
  String? requestedBy;

  Meta({
    this.cached,
    this.timestamp,
    this.requestedBy,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    cached: json["cached"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    requestedBy: json["requested_by"],
  );

  Map<String, dynamic> toJson() => {
    "cached": cached,
    "timestamp": timestamp?.toIso8601String(),
    "requested_by": requestedBy,
  };
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;
  int? from;
  int? to;

  Pagination({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
    this.from,
    this.to,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"],
    perPage: json["per_page"],
    total: json["total"],
    lastPage: json["last_page"],
    from: json["from"],
    to: json["to"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "per_page": perPage,
    "total": total,
    "last_page": lastPage,
    "from": from,
    "to": to,
  };
}

class Product {
  String? id;
  String? sku;
  String? name;
  dynamic barcode;
  dynamic description;
  Category? category;

  Product({
    this.id,
    this.sku,
    this.name,
    this.barcode,
    this.description,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    sku: json["sku"],
    name: json["name"],
    barcode: json["barcode"],
    description: json["description"],
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sku": sku,
    "name": name,
    "barcode": barcode,
    "description": description,
    "category": category?.toJson(),
  };
}

class Category {
  String? id;
  String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
