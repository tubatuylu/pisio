/// Pişio Malzeme Modeli
class Ingredient {
  final String id;
  final String name;
  final String category; // Manav, Kasap, Süt Ürünleri, Bakliyat vb.
  final String defaultUnit; // su bardağı, yemek kaşığı, adet, gram vb.

  const Ingredient({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultUnit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      defaultUnit: json['defaultUnit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'defaultUnit': defaultUnit,
    };
  }
}

/// Tarif içindeki malzeme miktarı ve birimi
class RecipeIngredient {
  final String ingredientId;
  final String name;
  final double amount;
  final String unit;
  final String category;
  final String notes;

  const RecipeIngredient({
    required this.ingredientId,
    required this.name,
    required this.amount,
    required this.unit,
    required this.category,
    this.notes = '',
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      ingredientId: json['ingredientId'] as String? ?? '',
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String? ?? 'Temel Gıda',
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
      'name': name,
      'amount': amount,
      'unit': unit,
      'category': category,
      'notes': notes,
    };
  }

  RecipeIngredient copyWith({
    String? ingredientId,
    String? name,
    double? amount,
    String? unit,
    String? category,
    String? notes,
  }) {
    return RecipeIngredient(
      ingredientId: ingredientId ?? this.ingredientId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }
}
