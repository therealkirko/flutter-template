// To parse this JSON data, do
//
//     final requisitionResponse = requisitionResponseFromJson(jsonString);

import 'dart:convert';

RequisitionResponse requisitionResponseFromJson(String str) => RequisitionResponse.fromJson(json.decode(str));

String requisitionResponseToJson(RequisitionResponse data) => json.encode(data.toJson());

class RequisitionResponse {
  Data data;

  RequisitionResponse({
    required  this.data,
  });

  factory RequisitionResponse.fromJson(Map<String, dynamic> json) => RequisitionResponse(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  List<Requisition> requisitions;
  Meta? meta;
  Pagination? pagination;

  Data({
    required this.requisitions,
    this.meta,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    requisitions: json["requisitions"] == null ? [] : List<Requisition>.from(json["requisitions"]!.map((x) => Requisition.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "requisitions": List<dynamic>.from(requisitions.map((x) => x.toJson())),
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

class Requisition {
  String? id;
  String? uid;
  Supplier? vendor;
  Branch? branch;
  Supplier? supplier;
  List<Item>? items;
  DateTime? date;
  String? status;
  DateTime? createdAt;

  Requisition({
    this.id,
    this.uid,
    this.vendor,
    this.branch,
    this.supplier,
    this.items,
    this.date,
    this.status,
    this.createdAt,
  });

  factory Requisition.fromJson(Map<String, dynamic> json) => Requisition(
    id: json["id"],
    uid: json["uid"],
    vendor: json["vendor"] == null ? null : Supplier.fromJson(json["vendor"]),
    branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
    supplier: json["supplier"] == null ? null : Supplier.fromJson(json["supplier"]),
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "vendor": vendor?.toJson(),
    "branch": branch?.toJson(),
    "supplier": supplier?.toJson(),
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "status": status,
    "created_at": createdAt?.toIso8601String(),
  };
}

class Branch {
  String? id;
  String? name;

  Branch({
    this.id,
    this.name,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Item {
  String? id;
  String? name;
  int? quantityRequested;
  dynamic quantityApproved;

  Item({
    this.id,
    this.name,
    this.quantityRequested,
    this.quantityApproved,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    quantityRequested: json["quantity_requested"],
    quantityApproved: json["quantity_approved"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "quantity_requested": quantityRequested,
    "quantity_approved": quantityApproved,
  };
}

class Supplier {
  String? id;
  String? name;
  String? address;

  Supplier({
    this.id,
    this.name,
    this.address,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
    id: json["id"],
    name: json["name"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
  };
}
