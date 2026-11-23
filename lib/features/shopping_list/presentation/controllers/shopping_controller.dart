import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/shopping_item.dart';
import '../../domain/logic/shopping_aggregator.dart';
import '../../../meal_planner/presentation/controllers/meal_plan_controller.dart';

class ShoppingListNotifier extends StateNotifier<List<ShoppingItem>> {
  final Ref _ref;

  ShoppingListNotifier(this._ref) : super([]) {
    // Haftalık menü değiştikçe otomatik listeyi senkronize et
    _ref.listen(weeklyMealPlanProvider, (previous, next) {
      next.whenData((plan) {
        syncFromMealPlan(plan);
      });
    });

    // İlk yüklemede mevcut planı al
    final initialPlan = _ref.read(weeklyMealPlanProvider).asData?.value;
    if (initialPlan != null) {
      syncFromMealPlan(initialPlan);
    }
  }

  void syncFromMealPlan(dynamic plan) {
    final aggregated = ShoppingAggregator.aggregateFromMealPlan(plan);

    // Mevcut işaretlemeleri koru
    final currentPantryIds = {for (var i in state.where((x) => x.isInPantry)) i.name: true};
    final currentPurchasedIds = {for (var i in state.where((x) => x.isPurchased)) i.name: true};

    final updated = aggregated.map((item) {
      return item.copyWith(
        isInPantry: currentPantryIds[item.name] ?? false,
        isPurchased: currentPurchasedIds[item.name] ?? false,
      );
    }).toList();

    // Özel eklenen manuel kalemleri de koru
    final customItems = state.where((i) => i.id.startsWith('custom_manual_')).toList();
    updated.addAll(customItems);

    state = updated;
  }

  /// 'Satın Alındı' durumunu değiştir
  void togglePurchased(String itemId) {
    state = state.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isPurchased: !item.isPurchased);
      }
      return item;
    }).toList();
  }

  /// 'Evde Var' (Kilerde Mevcut) durumunu değiştir
  void toggleInPantry(String itemId) {
    state = state.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isInPantry: !item.isInPantry);
      }
      return item;
    }).toList();
  }

  /// Manuel malzeme ekle (Örn: 'Maden Suyu', 'Bulaşık Deterjanı')
  void addManualItem({
    required String name,
    required double amount,
    required String unit,
    required String category,
  }) {
    final newItem = ShoppingItem(
      id: 'custom_manual_${const Uuid().v4()}',
      name: name,
      amount: amount,
      unit: unit,
      category: category,
      isInPantry: false,
      isPurchased: false,
    );

    state = [...state, newItem];
  }

  /// Alınanları temizle
  void removePurchased() {
    state = state.where((item) => !item.isPurchased).toList();
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>((ref) {
  return ShoppingListNotifier(ref);
});
