import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../domain/models/meal_plan.dart';
import '../../../recipes/domain/models/recipe.dart';
import '../../../onboarding/domain/models/user_preferences.dart';
import '../../../../core/utils/turkish_formatters.dart';

/// Pişio Akıllı Otomatik Menü Oluşturucu Motoru
class MenuGenerator {
  final Random _random = Random();

  /// Kullanıcı tercihlerine ve mevsimselliğe göre 7 günlük dengeli menü üretir
  List<MealPlanItem> generateWeeklyPlan({
    required DateTime weekStartDate,
    required List<Recipe> allRecipes,
    required UserPreferences preferences,
    bool includeBreakfast = true,
    bool includeLunch = true,
    bool includeDinner = true,
    bool includeSnack = false,
  }) {
    final List<MealPlanItem> generatedItems = [];
    final monday = TurkishFormatters.getWeekMonday(weekStartDate);
    final weekDays = TurkishFormatters.getWeekDays(monday);

    // 1. Tarifleri tercih ve alerjenlere göre filtrele
    final eligibleRecipes = _filterEligibleRecipes(allRecipes, preferences);

    // 2. Kategorilere göre tarif havuzları oluştur
    final breakfastPool = eligibleRecipes
        .where((r) => r.category == 'Kahvaltılıklar' || r.category == 'Börek & Hamur İşi')
        .toList();
    final soupPool = eligibleRecipes.where((r) => r.category == 'Çorbalar').toList();
    final legumePool = eligibleRecipes.where((r) => r.category == 'Bakliyatlar').toList();
    final meatPool = eligibleRecipes.where((r) => r.category == 'Tencere & Etli Yemekler').toList();
    final vegPool = eligibleRecipes.where((r) => r.category == 'Zeytinyağlılar & Sebze').toList();
    final sidePool = eligibleRecipes
        .where((r) => r.category == 'Pilav & Makarnalar' || r.category == 'Salata & Mezeler')
        .toList();
    final dessertPool = eligibleRecipes.where((r) => r.category == 'Tatlılar').toList();

    // 3. Haftanın 7 günü için döngü
    for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
      final currentDate = weekDays[dayIndex];

      // KAHVALTI
      if (includeBreakfast && breakfastPool.isNotEmpty) {
        final recipe = breakfastPool[dayIndex % breakfastPool.length];
        generatedItems.add(
          MealPlanItem(
            id: const Uuid().v4(),
            mealPlanId: 'week_${monday.toIso8601String()}',
            date: currentDate,
            mealType: 'breakfast',
            recipeId: recipe.id,
            recipe: recipe,
            servings: preferences.householdSize,
          ),
        );
      }

      // ÖĞLE YEMEĞİ (Genelde Çorba + Yan Yemek veya Hafif Sebze)
      if (includeLunch) {
        Recipe? lunchRecipe;
        if (soupPool.isNotEmpty && dayIndex % 2 == 0) {
          lunchRecipe = soupPool[(dayIndex ~/ 2) % soupPool.length];
        } else if (vegPool.isNotEmpty) {
          lunchRecipe = vegPool[dayIndex % vegPool.length];
        } else if (sidePool.isNotEmpty) {
          lunchRecipe = sidePool[dayIndex % sidePool.length];
        }

        if (lunchRecipe != null) {
          generatedItems.add(
            MealPlanItem(
              id: const Uuid().v4(),
              mealPlanId: 'week_${monday.toIso8601String()}',
              date: currentDate,
              mealType: 'lunch',
              recipeId: lunchRecipe.id,
              recipe: lunchRecipe,
              servings: preferences.householdSize,
            ),
          );
        }
      }

      // AKŞAM YEMEĞİ (Ana Yemek Döngüsü: Bakliyat -> Et/Tavuk -> Sebze -> Dengeli)
      if (includeDinner) {
        Recipe? dinnerRecipe;

        // Türk aile dengesi:
        // Pazartesi: Bakliyat (Kuru fasulye / Nohut)
        // Salı: Pilav & Çorba veya Tencere Yemeği
        // Çarşamba: Sebze / Zeytinyağlı
        // Perşembe: Et / Tavuk yemeği
        // Cuma: Hafif sebze / makarna
        // Cumartesi: Fırında et/tavuk veya börek
        // Pazar: Tencere yemeği & tatlı
        switch (dayIndex) {
          case 0: // Pazartesi
            dinnerRecipe = _pickFromPool(legumePool) ?? _pickFromPool(eligibleRecipes);
            break;
          case 1: // Salı
            dinnerRecipe = _pickFromPool(meatPool) ?? _pickFromPool(eligibleRecipes);
            break;
          case 2: // Çarşamba
            dinnerRecipe = _pickFromPool(vegPool) ?? _pickFromPool(eligibleRecipes);
            break;
          case 3: // Perşembe
            dinnerRecipe = _pickFromPool(legumePool) ?? _pickFromPool(meatPool) ?? _pickFromPool(eligibleRecipes);
            break;
          case 4: // Cuma
            dinnerRecipe = _pickFromPool(sidePool) ?? _pickFromPool(soupPool) ?? _pickFromPool(eligibleRecipes);
            break;
          case 5: // Cumartesi
            dinnerRecipe = _pickFromPool(meatPool) ?? _pickFromPool(eligibleRecipes);
            break;
          case 6: // Pazar
            dinnerRecipe = _pickFromPool(vegPool) ?? _pickFromPool(eligibleRecipes);
            break;
        }

        if (dinnerRecipe != null) {
          generatedItems.add(
            MealPlanItem(
              id: const Uuid().v4(),
              mealPlanId: 'week_${monday.toIso8601String()}',
              date: currentDate,
              mealType: 'dinner',
              recipeId: dinnerRecipe.id,
              recipe: dinnerRecipe,
              servings: preferences.householdSize,
            ),
          );
        }
      }

      // ARA ÖĞÜN / TATLI
      if (includeSnack && dessertPool.isNotEmpty && (dayIndex == 2 || dayIndex == 6)) {
        final snackRecipe = dessertPool[_random.nextInt(dessertPool.length)];
        generatedItems.add(
          MealPlanItem(
            id: const Uuid().v4(),
            mealPlanId: 'week_${monday.toIso8601String()}',
            date: currentDate,
            mealType: 'snack',
            recipeId: snackRecipe.id,
            recipe: snackRecipe,
            servings: preferences.householdSize,
          ),
        );
      }
    }

    return generatedItems;
  }

  Recipe? _pickFromPool(List<Recipe> pool) {
    if (pool.isEmpty) return null;
    return pool[_random.nextInt(pool.length)];
  }

  List<Recipe> _filterEligibleRecipes(List<Recipe> recipes, UserPreferences prefs) {
    return recipes.where((recipe) {
      // Vejetaryen kontrolü
      if (prefs.dietaryType == 'vegetarian' && !recipe.tags.contains('vejetaryen')) {
        return false;
      }

      // Glütensiz kontrolü
      if (prefs.isGlutenFree && !recipe.tags.contains('glütensiz')) {
        return false;
      }

      // Bütçe kontrolü (Ekonomik seçildiyse)
      if (prefs.budgetLevel == 'economic' && recipe.budgetLevel == 'orta') {
        // Tamamen elemek yerine öncelik düşürülebilir, şimdilik kabul edilebilir
      }

      // Sevilmeyen malzeme kontrolü (Örn: kereviz, bamya)
      for (final disliked in prefs.dislikedIngredients) {
        final dLower = disliked.trim().toLowerCase();
        if (dLower.isNotEmpty) {
          final containsDisliked = recipe.ingredients.any(
            (i) => i.name.toLowerCase().contains(dLower),
          );
          if (containsDisliked) return false;
        }
      }

      // Alerjen kontrolü
      for (final allergy in prefs.allergies) {
        final aLower = allergy.trim().toLowerCase();
        if (aLower.isNotEmpty) {
          final containsAllergy = recipe.ingredients.any(
            (i) => i.name.toLowerCase().contains(aLower),
          );
          if (containsAllergy) return false;
        }
      }

      return true;
    }).toList();
  }
}
