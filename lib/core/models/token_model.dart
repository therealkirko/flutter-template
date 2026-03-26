// To parse this JSON data, do
//
//     final token = tokenFromJson(jsonString);

import 'dart:convert';

Token tokenFromJson(String str) => Token.fromJson(json.decode(str));

String tokenToJson(Token data) => json.encode(data.toJson());

class Token {
  String message;
  Data data;

  Token({
    required this.message,
    required this.data,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  TokenClass? token;
  User? user;
  Branch? branch;

  Data({
    this.token,
    this.user,
    this.branch,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"] == null ? null : TokenClass.fromJson(json["token"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token?.toJson(),
    "user": user?.toJson(),
    "branch": branch?.toJson(),
  };
}

class Branch {
  String? id;
  String? name;
  String? address;

  Branch({
    this.id,
    this.name,
    this.address,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
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

class TokenClass {
  String? type;
  String? accessToken;
  DateTime? issuedAt;

  TokenClass({
    this.type,
    this.accessToken,
    this.issuedAt,
  });

  factory TokenClass.fromJson(Map<String, dynamic> json) => TokenClass(
    type: json["type"],
    accessToken: json["access_token"],
    issuedAt: json["issued_at"] == null ? null : DateTime.parse(json["issued_at"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "access_token": accessToken,
    "issued_at": issuedAt?.toIso8601String(),
  };
}

class User {
  String? id;
  String? name;
  String? email;
  String? role;
  String? status;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "status": status,
  };
}
