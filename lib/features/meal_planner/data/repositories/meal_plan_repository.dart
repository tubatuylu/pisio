import '../../domain/models/meal_plan.dart';
import '../../../../core/utils/turkish_formatters.dart';

abstract class MealPlanRepository {
  Future<WeeklyMealPlan> getWeeklyPlan(DateTime weekStartDate);
  Future<void> saveWeeklyPlan(WeeklyMealPlan plan);
  Future<void> addOrUpdateItem(MealPlanItem item);
  Future<void> removeItem(String itemId);
  Future<void> clearWeeklyPlan(DateTime weekStartDate);
}

class LocalMealPlanRepository implements MealPlanRepository {
  final Map<String, WeeklyMealPlan> _plansCache = {};

  String _getWeekKey(DateTime date) {
    final monday = TurkishFormatters.getWeekMonday(date);
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<WeeklyMealPlan> getWeeklyPlan(DateTime weekStartDate) async {
    final key = _getWeekKey(weekStartDate);
    final monday = TurkishFormatters.getWeekMonday(weekStartDate);

    if (!_plansCache.containsKey(key)) {
      _plansCache[key] = WeeklyMealPlan(
        id: 'plan_$key',
        weekStartDate: monday,
        items: [],
      );
    }
    return _plansCache[key]!;
  }

  @override
  Future<void> saveWeeklyPlan(WeeklyMealPlan plan) async {
    final key = _getWeekKey(plan.weekStartDate);
    _plansCache[key] = plan;
  }

  @override
  Future<void> addOrUpdateItem(MealPlanItem item) async {
    final key = _getWeekKey(item.date);
    final monday = TurkishFormatters.getWeekMonday(item.date);

    final currentPlan = _plansCache[key] ??
        WeeklyMealPlan(
          id: 'plan_$key',
          weekStartDate: monday,
          items: [],
        );

    final updatedItems = List<MealPlanItem>.from(currentPlan.items);
    final existingIndex = updatedItems.indexWhere((i) =>
        i.date.year == item.date.year &&
        i.date.month == item.date.month &&
        i.date.day == item.date.day &&
        i.mealType == item.mealType);

    if (existingIndex >= 0) {
      updatedItems[existingIndex] = item;
    } else {
      updatedItems.add(item);
    }

    _plansCache[key] = currentPlan.copyWith(items: updatedItems);
  }

  @override
  Future<void> removeItem(String itemId) async {
    for (final key in _plansCache.keys) {
      final plan = _plansCache[key]!;
      final updated = plan.items.where((i) => i.id != itemId).toList();
      _plansCache[key] = plan.copyWith(items: updated);
    }
  }

  @override
  Future<void> clearWeeklyPlan(DateTime weekStartDate) async {
    final key = _getWeekKey(weekStartDate);
    final monday = TurkishFormatters.getWeekMonday(weekStartDate);
    _plansCache[key] = WeeklyMealPlan(
      id: 'plan_$key',
      weekStartDate: monday,
      items: [],
    );
  }
}
