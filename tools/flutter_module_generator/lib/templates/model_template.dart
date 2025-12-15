class ModelTemplate {
  static String generate(String moduleName, String className) {
    return '''/// $className model for $moduleName module
class $className {
  final String id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  $className({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from JSON
  factory $className.fromJson(Map<String, dynamic> json) {
    return $className(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Copy with
  $className copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return $className(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '$className(id: \$id, name: \$name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is $className && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
''';
  }
}
