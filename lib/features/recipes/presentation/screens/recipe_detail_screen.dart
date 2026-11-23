import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/portion_scaler.dart';
import '../../domain/models/recipe.dart';
import '../widgets/portion_stepper_widget.dart';
import '../../../meal_planner/presentation/controllers/meal_plan_controller.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  late int _servings;

  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.baseServings;
  }

  void _showAddToMenuDialog() {
    DateTime selectedDate = DateTime.now();
    String selectedMealType = 'dinner';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Menüye Ekle',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.recipe.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Öğün Seçimi
                  const Text(
                    'Öğün Türü',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Kahvaltı'),
                        selected: selectedMealType == 'breakfast',
                        onSelected: (_) => setModalState(() => selectedMealType = 'breakfast'),
                      ),
                      ChoiceChip(
                        label: const Text('Öğle'),
                        selected: selectedMealType == 'lunch',
                        onSelected: (_) => setModalState(() => selectedMealType = 'lunch'),
                      ),
                      ChoiceChip(
                        label: const Text('Akşam'),
                        selected: selectedMealType == 'dinner',
                        onSelected: (_) => setModalState(() => selectedMealType = 'dinner'),
                      ),
                      ChoiceChip(
                        label: const Text('Ara Öğün'),
                        selected: selectedMealType == 'snack',
                        onSelected: (_) => setModalState(() => selectedMealType = 'snack'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ekle Butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(weeklyMealPlanProvider.notifier).addRecipeToMeal(
                              date: selectedDate,
                              mealType: selectedMealType,
                              recipe: widget.recipe,
                              servings: _servings,
                            );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.recipe.title} haftalık menüye eklendi!'),
                            backgroundColor: AppColors.secondary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('Haftalık Menüye Kaydet'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: recipe.isFavorite ? AppColors.primary : null,
            ),
            onPressed: () {
              // Favori durumu değişimi
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showAddToMenuDialog,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: const Text('Haftalık Menüye Ekle'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Bilgi Kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(Icons.timer_outlined, 'Hazırlık', '${recipe.prepTimeMinutes} dk'),
                      _buildDivider(),
                      _buildInfoColumn(Icons.local_fire_department_outlined, 'Pişirme', '${recipe.cookTimeMinutes} dk'),
                      _buildDivider(),
                      _buildInfoColumn(Icons.speed, 'Zorluk', recipe.difficulty.toUpperCase()),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Porsiyon Ayarı:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      PortionStepperWidget(
                        currentServings: _servings,
                        onServingsChanged: (newServings) {
                          setState(() {
                            _servings = newServings;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Hazırlık Uyarısı (Prep Ahead Tip)
            if (recipe.prepAheadTip.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.warning.withOpacity(0.5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.tips_and_updates, color: AppColors.warning, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Önceden Hazırlık İpucu',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            recipe.prepAheadTip,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Malzemeler Bölümü (Dinamik Ölçeklenmiş)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Malzemeler',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_servings Kişilik Ölçü',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recipe.ingredients.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ing = recipe.ingredients[index];
                  final formattedAmount = PortionScaler.formatScaledIngredient(
                    baseAmount: ing.amount,
                    baseServings: recipe.baseServings,
                    targetServings: _servings,
                    unit: ing.unit,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ing.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          formattedAmount,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Adım Adım Yapılışı
            const Text(
              'Nasıl Yapılır?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipe.steps.length,
              itemBuilder: (context, index) {
                final stepText = recipe.steps[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          stepText,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.border,
    );
  }
}
