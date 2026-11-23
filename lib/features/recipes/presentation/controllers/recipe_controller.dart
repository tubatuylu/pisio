import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/recipe.dart';
import '../../data/repositories/recipe_repository.dart';

/// Repository Provider
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final repo = LocalRecipeRepository();
  repo.init();
  return repo;
});

/// Arama Sorgusu State Provider
final recipeSearchQueryProvider = StateProvider<String>((ref) => '');

/// Seçili Kategori State Provider
final selectedCategoryProvider = StateProvider<String>((ref) => 'Tümü');

/// Seçili Diyet Filtreleri (Vejetaryen, Glütensiz vb.)
final isVegetarianFilterProvider = StateProvider<bool>((ref) => false);
final isGlutenFreeFilterProvider = StateProvider<bool>((ref) => false);

/// Filtrelenmiş Tarif Listesi Provider
final filteredRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final query = ref.watch(recipeSearchQueryProvider);
  final category = ref.watch(selectedCategoryProvider);
  final isVegetarian = ref.watch(isVegetarianFilterProvider);
  final isGlutenFree = ref.watch(isGlutenFreeFilterProvider);

  return repo.searchRecipes(
    query: query,
    category: category,
    isVegetarian: isVegetarian ? true : null,
    isGlutenFree: isGlutenFree ? true : null,
  );
});

/// Favoriler Listesi Notifier
class FavoritesNotifier extends StateNotifier<AsyncValue<List<Recipe>>> {
  final RecipeRepository _repository;

  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = const AsyncValue.loading();
    try {
      final favs = await _repository.getFavorites();
      state = AsyncValue.data(favs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite(String recipeId) async {
    await _repository.toggleFavorite(recipeId);
    await loadFavorites();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Recipe>>>((ref) {
  final repo = ref.watch(recipeRepositoryProvider);
  return FavoritesNotifier(repo);
});

/// Dinamik Porsiyon State Provider (Tarif ID'sine özel porsiyon takibi)
final recipeServingCountProvider = StateProvider.family<int, int>((ref, baseServing) => baseServing);
