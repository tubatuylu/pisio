import 'package:uuid/uuid.dart';
import '../../domain/models/shopping_item.dart';
import '../../../meal_planner/domain/models/meal_plan.dart';
import '../../../../core/utils/portion_scaler.dart';

/// Haftalık menüdeki tüm yemeklerin malzemelerini toplayıp tekilleştiren motor
class ShoppingAggregator {
  ShoppingAggregator._();

  /// Haftalık menü kalemlerini analiz edip reyon bazlı tekil alışveriş listesi üretir
  static List<ShoppingItem> aggregateFromMealPlan(WeeklyMealPlan mealPlan) {
    // Malzeme Adı + Birim bazında toplam miktarları tutan harita
    final Map<String, _AggregatedItemData> itemMap = {};

    for (final mealItem in mealPlan.items) {
      final recipe = mealItem.recipe;
      if (recipe == null) continue;

      final servings = mealItem.servings;
      final baseServings = recipe.baseServings;

      for (final ing in recipe.ingredients) {
        // Porsiyona göre ölçeklenmiş miktar
        final scaledAmount = PortionScaler.scaleAmount(
          baseAmount: ing.amount,
          baseServings: baseServings,
          targetServings: servings,
        );

        // Anahtar: Normalize edilmiş ad + Birim (aynı birimdeki malzemeleri toplamak için)
        final key = '${ing.name.trim().toLowerCase()}_${ing.unit.trim().toLowerCase()}';

        if (itemMap.containsKey(key)) {
          final existing = itemMap[key]!;
          existing.totalAmount += scaledAmount;
        } else {
          itemMap[key] = _AggregatedItemData(
            id: const Uuid().v4(),
            name: ing.name.trim(),
            totalAmount: scaledAmount,
            unit: ing.unit.trim(),
            category: ing.category.isNotEmpty ? ing.category : 'Temel Gıda & Baharat',
          );
        }
      }
    }

    // Haritadan ShoppingItem listesine dönüştür
    final items = itemMap.values.map((data) {
      return ShoppingItem(
        id: data.id,
        name: data.name,
        amount: data.totalAmount,
        unit: data.unit,
        category: data.category,
        isInPantry: false,
        isPurchased: false,
      );
    }).toList();

    // Reyonlara göre sırala
    items.sort((a, b) {
      final catComp = a.category.compareTo(b.category);
      if (catComp != 0) return catComp;
      return a.name.compareTo(b.name);
    });

    return items;
  }
}

class _AggregatedItemData {
  final String id;
  final String name;
  double totalAmount;
  final String unit;
  final String category;

  _AggregatedItemData({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.unit,
    required this.category,
  });
}
