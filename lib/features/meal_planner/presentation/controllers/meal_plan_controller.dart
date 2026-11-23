import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/logic/menu_generator.dart';
import '../../data/repositories/meal_plan_repository.dart';
import '../../../recipes/domain/models/recipe.dart';
import '../../../recipes/presentation/controllers/recipe_controller.dart';
import '../../../onboarding/presentation/controllers/preferences_controller.dart';
import '../../../../core/utils/turkish_formatters.dart';

/// Repository Provider
final mealPlanRepositoryProvider = Provider<MealPlanRepository>((ref) {
  return LocalMealPlanRepository();
});

/// Seçili Haftanın Pazartesi Tarihi State Provider
final selectedWeekMondayProvider = StateProvider<DateTime>((ref) {
  return TurkishFormatters.getWeekMonday(DateTime.now());
});

/// Haftalık Menü Notifier
class WeeklyMealPlanNotifier extends StateNotifier<AsyncValue<WeeklyMealPlan>> {
  final Ref _ref;
  final MealPlanRepository _repository;
  final MenuGenerator _generator = MenuGenerator();

  WeeklyMealPlanNotifier(this._ref, this._repository) : super(const AsyncValue.loading()) {
    loadCurrentWeekPlan();
  }

  DateTime get currentMonday => _ref.read(selectedWeekMondayProvider);

  Future<void> loadCurrentWeekPlan() async {
    state = const AsyncValue.loading();
    try {
      final monday = currentMonday;
      final plan = await _repository.getWeeklyPlan(monday);
      state = AsyncValue.data(plan);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Haftayı değiştir (Önceki veya Sonraki Hafta)
  void shiftWeek(int weeks) {
    final current = _ref.read(selectedWeekMondayProvider);
    final newMonday = current.add(Duration(days: 7 * weeks));
    _ref.read(selectedWeekMondayProvider.notifier).state = newMonday;
    loadCurrentWeekPlan();
  }

  /// Tek Tuşla Akıllı Menü Oluştur
  Future<void> autoGenerateMenu({
    bool includeBreakfast = true,
    bool includeLunch = true,
    bool includeDinner = true,
  }) async {
    try {
      final allRecipes = await _ref.read(recipeRepositoryProvider).getAllRecipes();
      final preferences = _ref.read(userPreferencesProvider);
      final monday = currentMonday;

      final generatedItems = _generator.generateWeeklyPlan(
        weekStartDate: monday,
        allRecipes: allRecipes,
        preferences: preferences,
        includeBreakfast: includeBreakfast,
        includeLunch: includeLunch,
        includeDinner: includeDinner,
      );

      final newPlan = WeeklyMealPlan(
        id: 'plan_${monday.toIso8601String()}',
        weekStartDate: monday,
        items: generatedItems,
      );

      await _repository.saveWeeklyPlan(newPlan);
      state = AsyncValue.data(newPlan);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Öğüne Tarif Ekle
  Future<void> addRecipeToMeal({
    required DateTime date,
    required String mealType,
    required Recipe recipe,
    required int servings,
  }) async {
    final item = MealPlanItem(
      id: const Uuid().v4(),
      mealPlanId: 'week_${currentMonday.toIso8601String()}',
      date: date,
      mealType: mealType,
      recipeId: recipe.id,
      recipe: recipe,
      servings: servings,
    );

    await _repository.addOrUpdateItem(item);
    await loadCurrentWeekPlan();
  }

  /// Öğün Kaydını Sil
  Future<void> removeItem(String itemId) async {
    await _repository.removeItem(itemId);
    await loadCurrentWeekPlan();
  }

  /// Haftalık Menüyü Sıfırla
  Future<void> clearPlan() async {
    await _repository.clearWeeklyPlan(currentMonday);
    await loadCurrentWeekPlan();
  }
}

final weeklyMealPlanProvider =
    StateNotifierProvider<WeeklyMealPlanNotifier, AsyncValue<WeeklyMealPlan>>((ref) {
  final repo = ref.watch(mealPlanRepositoryProvider);
  return WeeklyMealPlanNotifier(ref, repo);
});
