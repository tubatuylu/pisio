import 'package:flutter_test/flutter_test.dart';
import 'package:pisio/features/shopping_list/domain/logic/shopping_aggregator.dart';
import 'package:pisio/features/meal_planner/domain/models/meal_plan.dart';
import 'package:pisio/features/recipes/domain/models/recipe.dart';
import 'package:pisio/features/recipes/domain/models/ingredient.dart';

void main() {
  group('ShoppingAggregator Testleri', () {
    test('Farklı yemeklerdeki aynı malzemeler doğru toplanmalı ve tekilleştirilmelidir', () {
      final recipeA = Recipe(
        id: 'rec_a',
        title: 'Mercimek Çorbası',
        category: 'Çorbalar',
        prepTimeMinutes: 10,
        cookTimeMinutes: 20,
        baseServings: 4,
        ingredients: [
          const RecipeIngredient(
            ingredientId: 'ing_sogan',
            name: 'Kuru Soğan',
            amount: 1.0,
            unit: 'adet',
            category: 'Manav',
          ),
          const RecipeIngredient(
            ingredientId: 'ing_mercimek',
            name: 'Kırmızı Mercimek',
            amount: 1.5,
            unit: 'su bardağı',
            category: 'Bakliyat & Kuru Gıda',
          ),
        ],
      );

      final recipeB = Recipe(
        id: 'rec_b',
        title: 'Kuru Fasulye',
        category: 'Bakliyatlar',
        prepTimeMinutes: 10,
        cookTimeMinutes: 40,
        baseServings: 4,
        ingredients: [
          const RecipeIngredient(
            ingredientId: 'ing_sogan',
            name: 'Kuru Soğan',
            amount: 2.0,
            unit: 'adet',
            category: 'Manav',
          ),
        ],
      );

      final monday = DateTime(2026, 11, 23);
      final mealPlan = WeeklyMealPlan(
        id: 'plan_test',
        weekStartDate: monday,
        items: [
          MealPlanItem(
            id: 'item_1',
            mealPlanId: 'plan_test',
            date: monday,
            mealType: 'lunch',
            recipe: recipeA,
            servings: 4,
          ),
          MealPlanItem(
            id: 'item_2',
            mealPlanId: 'plan_test',
            date: monday,
            mealType: 'dinner',
            recipe: recipeB,
            servings: 4,
          ),
        ],
      );

      final shoppingItems = ShoppingAggregator.aggregateFromMealPlan(mealPlan);

      // Kuru Soğan toplamda 1 + 2 = 3 adet olmalıdır
      final onionItem = shoppingItems.firstWhere((i) => i.name == 'Kuru Soğan');
      expect(onionItem.amount, 3.0);
      expect(onionItem.unit, 'adet');
      expect(onionItem.category, 'Manav');

      // Kırmızı Mercimek 1.5 su bardağı olmalıdır
      final lentilItem = shoppingItems.firstWhere((i) => i.name == 'Kırmızı Mercimek');
      expect(lentilItem.amount, 1.5);
    });
  });
}
