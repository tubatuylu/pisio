import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/turkish_formatters.dart';
import '../../domain/models/meal_plan.dart';
import '../../../recipes/domain/models/recipe.dart';
import '../../../recipes/presentation/screens/recipe_detail_screen.dart';

class MealSlotCard extends StatelessWidget {
  final String mealType;
  final MealPlanItem? item;
  final VoidCallback onAddMeal;
  final VoidCallback? onDeleteMeal;

  const MealSlotCard({
    super.key,
    required this.mealType,
    required this.item,
    required this.onAddMeal,
    this.onDeleteMeal,
  });

  @override
  Widget build(BuildContext context) {
    final mealName = TurkishFormatters.getMealTypeName(mealType);
    final hasItem = item != null && item!.recipe != null;
    final recipe = item?.recipe;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: hasItem ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasItem ? AppColors.border : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Öğün İkonu / Başlığı
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getMealColor(mealType).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getMealIcon(mealType),
                color: _getMealColor(mealType),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // İçerik
            Expanded(
              child: hasItem
                  ? InkWell(
                      onTap: () {
                        if (recipe != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mealName,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            recipe!.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, size: 13, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                '${recipe.totalTimeMinutes} dk',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.people_outline, size: 13, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                '${item!.servings} Kişilik',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          if (recipe.prepAheadTip.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.tips_and_updates, size: 12, color: AppColors.warning),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    recipe.prepAheadTip,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: onAddMeal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mealName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '+ Yemek Seç veya Ekle',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Eylem Butonları
            if (hasItem && onDeleteMeal != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                onPressed: onDeleteMeal,
                tooltip: 'Öğünü Kaldır',
              )
            else
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 22),
                onPressed: onAddMeal,
                tooltip: 'Yemek Ekle',
              ),
          ],
        ),
      ),
    );
  }

  IconData _getMealIcon(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny_outlined;
      case 'lunch':
        return Icons.soup_kitchen_outlined;
      case 'dinner':
        return Icons.dinner_dining_outlined;
      case 'snack':
        return Icons.icecream_outlined;
      default:
        return Icons.restaurant;
    }
  }

  Color _getMealColor(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFFF59E0B); // Amber
      case 'lunch':
        return AppColors.secondary;
      case 'dinner':
        return AppColors.primary;
      case 'snack':
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.primary;
    }
  }
}
