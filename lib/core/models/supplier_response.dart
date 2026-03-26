// To parse this JSON data, do
//
//     final supplierResponse = supplierResponseFromJson(jsonString);

import 'dart:convert';

SupplierResponse supplierResponseFromJson(String str) => SupplierResponse.fromJson(json.decode(str));

String supplierResponseToJson(SupplierResponse data) => json.encode(data.toJson());

class SupplierResponse {
  Data data;

  SupplierResponse({
    required this.data,
  });

  factory SupplierResponse.fromJson(Map<String, dynamic> json) => SupplierResponse(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  List<Supplier>? suppliers;
  Meta? meta;

  Data({
    this.suppliers,
    this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    suppliers: json["suppliers"] == null ? [] : List<Supplier>.from(json["suppliers"]!.map((x) => Supplier.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "suppliers": suppliers == null ? [] : List<dynamic>.from(suppliers!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Meta {
  bool? cached;
  int? total;
  DateTime? timestamp;
  String? requestedBy;

  Meta({
    this.cached,
    this.total,
    this.timestamp,
    this.requestedBy,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    cached: json["cached"],
    total: json["total"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    requestedBy: json["requested_by"],
  );

  Map<String, dynamic> toJson() => {
    "cached": cached,
    "total": total,
    "timestamp": timestamp?.toIso8601String(),
    "requested_by": requestedBy,
  };
}

class Supplier {
  String? id;
  String? code;
  String? name;
  String? email;
  String? status;
  String? address;

  Supplier({
    this.id,
    this.code,
    this.name,
    this.email,
    this.status,
    this.address,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    email: json["email"],
    status: json["status"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "email": email,
    "status": status,
    "address": address,
  };
}
