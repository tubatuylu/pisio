import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/ingredient.dart';

abstract class RecipeRepository {
  Future<void> init();
  Future<List<Recipe>> getAllRecipes();
  Future<Recipe?> getRecipeById(String id);
  Future<List<Recipe>> searchRecipes({
    String? query,
    String? category,
    String? season,
    String? budgetLevel,
    bool? isVegetarian,
    bool? isGlutenFree,
    int? maxCookTimeMinutes,
  });
  Future<void> toggleFavorite(String recipeId);
  Future<List<Recipe>> getFavorites();
  Future<void> addCustomRecipe(Recipe recipe);
  Future<void> deleteCustomRecipe(String recipeId);
  Future<List<Ingredient>> getAllIngredients();
}

class LocalRecipeRepository implements RecipeRepository {
  List<Recipe> _recipes = [];
  List<Ingredient> _ingredients = [];
  final Set<String> _favoriteIds = {};
  bool _isInitialized = false;

  @override
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // 1. Malzeme seed verisini yükle
      final ingredientsString = await rootBundle.loadString('assets/seed/ingredients_seed.json');
      final List<dynamic> ingredientsJson = jsonDecode(ingredientsString) as List<dynamic>;
      _ingredients = ingredientsJson.map((e) => Ingredient.fromJson(e as Map<String, dynamic>)).toList();

      // 2. Tarif seed verisini yükle
      final recipesString = await rootBundle.loadString('assets/seed/recipes_seed.json');
      final List<dynamic> recipesJson = jsonDecode(recipesString) as List<dynamic>;
      _recipes = recipesJson.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();

      _isInitialized = true;
    } catch (e) {
      // Test veya asset yüklenemediğinde fallback boş liste
      _recipes = [];
      _ingredients = [];
    }
  }

  // Testler veya önbellek için doğrudan liste ile başlatma
  void setInitialData(List<Recipe> recipes, List<Ingredient> ingredients) {
    _recipes = List.from(recipes);
    _ingredients = List.from(ingredients);
    _isInitialized = true;
  }

  @override
  Future<List<Recipe>> getAllRecipes() async {
    await init();
    return _recipes.map((r) => r.copyWith(isFavorite: _favoriteIds.contains(r.id))).toList();
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    await init();
    try {
      final recipe = _recipes.firstWhere((r) => r.id == id);
      return recipe.copyWith(isFavorite: _favoriteIds.contains(recipe.id));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Recipe>> searchRecipes({
    String? query,
    String? category,
    String? season,
    String? budgetLevel,
    bool? isVegetarian,
    bool? isGlutenFree,
    int? maxCookTimeMinutes,
  }) async {
    await init();

    return _recipes.where((recipe) {
      // İsim veya malzeme araması
      if (query != null && query.trim().isNotEmpty) {
        final q = query.trim().toLowerCase();
        final matchesTitle = recipe.title.toLowerCase().contains(q);
        final matchesIngredient = recipe.ingredients.any((i) => i.name.toLowerCase().contains(q));
        if (!matchesTitle && !matchesIngredient) return false;
      }

      // Kategori filtresi
      if (category != null && category.isNotEmpty && category != 'Tümü') {
        if (recipe.category.toLowerCase() != category.toLowerCase()) return false;
      }

      // Mevsim filtresi
      if (season != null && season.isNotEmpty && season != 'her_mevsim') {
        if (recipe.season != 'her_mevsim' && recipe.season != season) return false;
      }

      // Bütçe filtresi
      if (budgetLevel != null && budgetLevel.isNotEmpty) {
        if (recipe.budgetLevel != budgetLevel) return false;
      }

      // Diyet filtreleri
      if (isVegetarian == true) {
        if (!recipe.tags.contains('vejetaryen')) return false;
      }

      if (isGlutenFree == true) {
        if (!recipe.tags.contains('glütensiz')) return false;
      }

      // Pişirme süresi
      if (maxCookTimeMinutes != null && maxCookTimeMinutes > 0) {
        if (recipe.totalTimeMinutes > maxCookTimeMinutes) return false;
      }

      return true;
    }).map((r) => r.copyWith(isFavorite: _favoriteIds.contains(r.id))).toList();
  }

  @override
  Future<void> toggleFavorite(String recipeId) async {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
  }

  @override
  Future<List<Recipe>> getFavorites() async {
    await init();
    return _recipes
        .where((r) => _favoriteIds.contains(r.id))
        .map((r) => r.copyWith(isFavorite: true))
        .toList();
  }

  @override
  Future<void> addCustomRecipe(Recipe recipe) async {
    await init();
    _recipes.insert(0, recipe.copyWith(isCustom: true));
  }

  @override
  Future<void> deleteCustomRecipe(String recipeId) async {
    await init();
    _recipes.removeWhere((r) => r.id == recipeId && r.isCustom);
    _favoriteIds.remove(recipeId);
  }

  @override
  Future<List<Ingredient>> getAllIngredients() async {
    await init();
    return _ingredients;
  }
}
