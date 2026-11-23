import 'package:flutter_test/flutter_test.dart';
import 'package:pisio/features/meal_planner/domain/logic/menu_generator.dart';
import 'package:pisio/features/recipes/domain/models/recipe.dart';
import 'package:pisio/features/recipes/domain/models/ingredient.dart';
import 'package:pisio/features/onboarding/domain/models/user_preferences.dart';

void main() {
  group('MenuGenerator Testleri', () {
    test('Vejetaryen kullanıcıya etli tarif önerilmemelidir', () {
      final recipes = [
        const Recipe(
          id: 'rec_veg',
          title: 'Zeytinyağlı Taze Fasulye',
          category: 'Zeytinyağlılar & Sebze',
          prepTimeMinutes: 10,
          cookTimeMinutes: 30,
          tags: ['vejetaryen'],
        ),
        const Recipe(
          id: 'rec_meat',
          title: 'Etli Nohut',
          category: 'Bakliyatlar',
          prepTimeMinutes: 15,
          cookTimeMinutes: 50,
          tags: ['etli'],
        ),
      ];

      final generator = MenuGenerator();
      final monday = DateTime(2026, 11, 23);
      final prefs = const UserPreferences(dietaryType: 'vegetarian');

      final items = generator.generateWeeklyPlan(
        weekStartDate: monday,
        allRecipes: recipes,
        preferences: prefs,
        includeBreakfast: false,
        includeLunch: false,
        includeDinner: true,
      );

      // Üretilen tüm akşam yemekleri vejetaryen olmalı, hiçbiri Etli Nohut olmamalıdır
      for (final item in items) {
        expect(item.recipeId, isNot('rec_meat'));
        expect(item.recipeId, 'rec_veg');
      }
    });

    test('Sevilmeyen malzeme (kereviz) içeren tarifler filtrelenmelidir', () {
      final recipes = [
        const Recipe(
          id: 'rec_kereviz',
          title: 'Portakallı Kereviz',
          category: 'Zeytinyağlılar & Sebze',
          prepTimeMinutes: 10,
          cookTimeMinutes: 30,
          ingredients: [
            RecipeIngredient(
              ingredientId: 'ing_kereviz',
              name: 'Kereviz',
              amount: 2,
              unit: 'adet',
              category: 'Manav',
            ),
          ],
        ),
        const Recipe(
          id: 'rec_ispanak',
          title: 'Pirinçli Ispanak Yemeği',
          category: 'Zeytinyağlılar & Sebze',
          prepTimeMinutes: 10,
          cookTimeMinutes: 20,
          ingredients: [
            RecipeIngredient(
              ingredientId: 'ing_ispanak',
              name: 'Ispanak',
              amount: 500,
              unit: 'gram',
              category: 'Manav',
            ),
          ],
        ),
      ];

      final generator = MenuGenerator();
      final monday = DateTime(2026, 11, 23);
      final prefs = const UserPreferences(dislikedIngredients: ['kereviz']);

      final items = generator.generateWeeklyPlan(
        weekStartDate: monday,
        allRecipes: recipes,
        preferences: prefs,
        includeBreakfast: false,
        includeLunch: false,
        includeDinner: true,
      );

      for (final item in items) {
        expect(item.recipeId, isNot('rec_kereviz'));
      }
    });
  });
}
