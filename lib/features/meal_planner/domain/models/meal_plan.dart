import 'package:pisio/features/recipes/domain/models/recipe.dart';

/// Haftalık menüdeki tek bir öğün kaydı
class MealPlanItem {
  final String id;
  final String mealPlanId;
  final DateTime date; // Örn: 2026-11-23
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack'
  final String? recipeId;
  final Recipe? recipe;
  final String? customTitle; // Kullanıcı serbest metin girdiyse
  final int servings;
  final String notes;

  const MealPlanItem({
    required this.id,
    required this.mealPlanId,
    required this.date,
    required this.mealType,
    this.recipeId,
    this.recipe,
    this.customTitle,
    this.servings = 4,
    this.notes = '',
  });

  String get displayTitle => recipe?.title ?? customTitle ?? 'Yemek Seçilmedi';

  factory MealPlanItem.fromJson(Map<String, dynamic> json, {Recipe? recipe}) {
    return MealPlanItem(
      id: json['id'] as String,
      mealPlanId: json['mealPlanId'] as String,
      date: DateTime.parse(json['date'] as String),
      mealType: json['mealType'] as String,
      recipeId: json['recipeId'] as String?,
      recipe: recipe,
      customTitle: json['customTitle'] as String?,
      servings: json['servings'] as int? ?? 4,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealPlanId': mealPlanId,
      'date': date.toIso8601String().split('T').first,
      'mealType': mealType,
      'recipeId': recipeId,
      'customTitle': customTitle,
      'servings': servings,
      'notes': notes,
    };
  }

  MealPlanItem copyWith({
    String? id,
    String? mealPlanId,
    DateTime? date,
    String? mealType,
    String? recipeId,
    Recipe? recipe,
    String? customTitle,
    int? servings,
    String? notes,
  }) {
    return MealPlanItem(
      id: id ?? this.id,
      mealPlanId: mealPlanId ?? this.mealPlanId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      recipeId: recipeId ?? this.recipeId,
      recipe: recipe ?? this.recipe,
      customTitle: customTitle ?? this.customTitle,
      servings: servings ?? this.servings,
      notes: notes ?? this.notes,
    );
  }
}

/// 7 günlük haftalık menü planı
class WeeklyMealPlan {
  final String id;
  final DateTime weekStartDate; // Her zaman ilgili haftanın Pazartesi günü
  final List<MealPlanItem> items;

  const WeeklyMealPlan({
    required this.id,
    required this.weekStartDate,
    this.items = const [],
  });

  /// Belirli bir gün ve öğün türündeki kaydı bulur
  MealPlanItem? getItem(DateTime date, String mealType) {
    try {
      return items.firstWhere(
        (item) =>
            item.date.year == date.year &&
            item.date.month == date.month &&
            item.date.day == date.day &&
            item.mealType.toLowerCase() == mealType.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  WeeklyMealPlan copyWith({
    String? id,
    DateTime? weekStartDate,
    List<MealPlanItem>? items,
  }) {
    return WeeklyMealPlan(
      id: id ?? this.id,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      items: items ?? this.items,
    );
  }
}
