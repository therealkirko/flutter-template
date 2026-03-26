// To parse this JSON data, do
//
//     final orderResponse = orderResponseFromJson(jsonString);

import 'dart:convert';

OrderResponse orderResponseFromJson(String str) => OrderResponse.fromJson(json.decode(str));

String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse {
  Data data;

  OrderResponse({
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  List<Order> orders;
  Meta? meta;
  Pagination? pagination;

  Data({
    required this.orders,
    this.meta,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
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

class Order {
  String? id;
  String? uid;
  Supplier? vendor;
  Branch? branch;
  Supplier? supplier;
  List<Item>? items;
  DateTime? date;
  String? status;
  DateTime? createdAt;

  Order({
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

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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
    "date": date?.toIso8601String(),
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
  String? item;
  String? name;
  String? sku;
  int? quantityOrdered;
  int? quantityDelivered;

  Item({
    this.id,
    this.item,
    this.name,
    this.sku,
    this.quantityOrdered,
    this.quantityDelivered,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    item: json["item"],
    name: json["name"],
    sku: json["sku"],
    quantityOrdered: json["quantity_ordered"],
    quantityDelivered: json["quantity_delivered"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item": item,
    "name": name,
    "sku": sku,
    "quantity_ordered": quantityOrdered,
    "quantity_delivered": quantityDelivered,
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
