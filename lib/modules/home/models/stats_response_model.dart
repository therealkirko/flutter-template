// To parse this JSON data, do
//
//     final statsResponse = statsResponseFromJson(jsonString);

import 'dart:convert';

StatsResponse statsResponseFromJson(String str) => StatsResponse.fromJson(json.decode(str));

String statsResponseToJson(StatsResponse data) => json.encode(data.toJson());

class StatsResponse {
  String? message;
  Data data;

  StatsResponse({
    this.message,
    required this.data,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) => StatsResponse(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int? requisitions;
  int? deliveries;

  Data({
    this.requisitions,
    this.deliveries,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    requisitions: json["requisitions"],
    deliveries: json["deliveries"],
  );

  Map<String, dynamic> toJson() => {
    "requisitions": requisitions,
    "deliveries": deliveries,
  };
}
