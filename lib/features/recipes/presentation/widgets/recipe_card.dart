import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Satır: Kategori ve Favori Butonu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      recipe.category,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (onFavoriteToggle != null)
                    IconButton(
                      icon: Icon(
                        recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: recipe.isFavorite ? AppColors.primary : AppColors.textMuted,
                        size: 22,
                      ),
                      visualDensity: VisualDensity.compact,
                      onPressed: onFavoriteToggle,
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Başlık
              Text(
                recipe.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Alt Bilgiler: Süre, Zorluk, Bütçe
              Row(
                children: [
                  // Toplam Süre
                  const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.totalTimeMinutes} dk',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 16),

                  // Porsiyon
                  const Icon(Icons.people_alt_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.baseServings} Kişilik',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 16),

                  // Bütçe Rozeti
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: recipe.budgetLevel == 'ekonomik'
                          ? AppColors.secondaryLight
                          : AppColors.warningLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      recipe.budgetLevel == 'ekonomik' ? 'Ekonomik' : 'Standart',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: recipe.budgetLevel == 'ekonomik'
                            ? AppColors.secondary
                            : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),

              // Hazırlık Uyarısı Rozeti (Varsa)
              if (recipe.prepAheadTip.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.tips_and_updates_outlined, size: 14, color: AppColors.warning),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        recipe.prepAheadTip,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
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
        ),
      ),
    );
  }
}
