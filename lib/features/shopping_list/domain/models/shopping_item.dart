/// Alışveriş Listesi Kalem Modeli
class ShoppingItem {
  final String id;
  final String name;
  final double amount;
  final String unit;
  final String category; // Manav, Kasap, Süt Ürünleri, Bakliyat vb.
  final bool isInPantry; // Evde Var (Kilerden düşüldü)
  final bool isPurchased; // Satın alındı / Sepette
  final String notes;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.category,
    this.isInPantry = false,
    this.isPurchased = false,
    this.notes = '',
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
      isInPantry: json['isInPantry'] as bool? ?? false,
      isPurchased: json['isPurchased'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'unit': unit,
      'category': category,
      'isInPantry': isInPantry,
      'isPurchased': isPurchased,
      'notes': notes,
    };
  }

  ShoppingItem copyWith({
    String? id,
    String? name,
    double? amount,
    String? unit,
    String? category,
    bool? isInPantry,
    bool? isPurchased,
    String? notes,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      isInPantry: isInPantry ?? this.isInPantry,
      isPurchased: isPurchased ?? this.isPurchased,
      notes: notes ?? this.notes,
    );
  }
}
