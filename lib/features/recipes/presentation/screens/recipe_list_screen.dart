import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/recipe_controller.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'add_custom_recipe_screen.dart';

class RecipeListScreen extends ConsumerWidget {
  const RecipeListScreen({super.key});

  static const List<String> categories = [
    'Tümü',
    'Çorbalar',
    'Bakliyatlar',
    'Tencere & Etli Yemekler',
    'Zeytinyağlılar & Sebze',
    'Pilav & Makarnalar',
    'Börek & Hamur İşi',
    'Kahvaltılıklar',
    'Tatlılar',
    'Salata & Mezeler',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCat = ref.watch(selectedCategoryProvider);
    final isVegetarian = ref.watch(isVegetarianFilterProvider);
    final isGlutenFree = ref.watch(isGlutenFreeFilterProvider);
    final recipesAsync = ref.watch(filteredRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarif Kütüphanesi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Favorilerim',
            onPressed: () {
              // Favoriler filtresi veya ekranı
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tarif Ekle'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCustomRecipeScreen(),
            ),
          );
        },
      ),
      body: Column(
        children: [
          // Arama Çubuğu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tarif veya malzeme ara (örn: mercimek, tavuk)...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: ref.watch(recipeSearchQueryProvider).isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          ref.read(recipeSearchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                ref.read(recipeSearchQueryProvider.notifier).state = val;
              },
            ),
          ),

          // Kategori Kaydırılabilir Şerit
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCat == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                  onSelected: (_) {
                    ref.read(selectedCategoryProvider.notifier).state = cat;
                  },
                );
              },
            ),
          ),

          // Hızlı Diyet Filtreleri
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('🌱 Vejetaryen'),
                  selected: isVegetarian,
                  selectedColor: AppColors.secondaryLight,
                  checkmarkColor: AppColors.secondary,
                  labelStyle: TextStyle(
                    color: isVegetarian ? AppColors.secondaryDark : AppColors.textSecondary,
                    fontWeight: isVegetarian ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    ref.read(isVegetarianFilterProvider.notifier).state = val;
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('🌾 Glütensiz'),
                  selected: isGlutenFree,
                  selectedColor: AppColors.primaryLight,
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isGlutenFree ? AppColors.primaryDark : AppColors.textSecondary,
                    fontWeight: isGlutenFree ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    ref.read(isGlutenFreeFilterProvider.notifier).state = val;
                  },
                ),
              ],
            ),
          ),

          // Tarif Listesi
          Expanded(
            child: recipesAsync.when(
              data: (recipes) {
                if (recipes.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          const Text(
                            'Aradığınız kriterlere uygun tarif bulunamadı.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Farklı bir arama terimi deneyebilir veya kendi tarifinizi ekleyebilirsiniz.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Kendi Tarifini Ekle'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddCustomRecipeScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                      onFavoriteToggle: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(recipe.id);
                        ref.invalidate(filteredRecipesProvider);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text('Tarifler yüklenirken hata oluştu: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
