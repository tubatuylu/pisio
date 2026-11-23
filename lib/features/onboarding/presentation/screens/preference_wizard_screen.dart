import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/preferences_controller.dart';
import '../../../../app.dart';

class PreferenceWizardScreen extends ConsumerStatefulWidget {
  const PreferenceWizardScreen({super.key});

  @override
  ConsumerState<PreferenceWizardScreen> createState() => _PreferenceWizardScreenState();
}

class _PreferenceWizardScreenState extends ConsumerState<PreferenceWizardScreen> {
  static const List<String> commonDisliked = [
    'Kereviz',
    'Bamya',
    'Pırasa',
    'Karnabahar',
    'Lahana',
    'Patlıcan',
    'Brokoli',
    'Enginar',
    'Sakatat',
  ];

  static const List<String> commonAllergies = [
    'Fındık / Fıstık',
    'Laktoz / Süt',
    'Glüten',
    'Yumurta',
    'Balık / Deniz Ürünü',
  ];

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(userPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutfak Tercihleri'),
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
          child: ElevatedButton(
            onPressed: () {
              ref.read(userPreferencesProvider.notifier).completeOnboarding();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainNavigationScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Menümü Hazırla ve Başla', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Size en uygun haftalık menüyü hazırlamak için birkaç soru:',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // 1. Hane Kişi Sayısı
          const Text(
            '1. Kaç kişilik yemek pişiriyorsunuz?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [1, 2, 4, 6].map((size) {
              final isSelected = prefs.householdSize == size;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Center(
                      child: Text(
                        size == 6 ? '6+ Kişi' : '$size Kişi',
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    onSelected: (_) {
                      ref.read(userPreferencesProvider.notifier).updateHouseholdSize(size);
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 2. Beslenme Tarzı
          const Text(
            '2. Beslenme Tercihiniz',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('🥩 Klasik Türk Mutfağı (Dengeli)'),
                selected: prefs.dietaryType == 'standard',
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: prefs.dietaryType == 'standard' ? Colors.white : AppColors.textPrimary,
                ),
                onSelected: (_) => ref.read(userPreferencesProvider.notifier).updateDietaryType('standard'),
              ),
              ChoiceChip(
                label: const Text('🌱 Vejetaryen'),
                selected: prefs.dietaryType == 'vegetarian',
                selectedColor: AppColors.secondary,
                labelStyle: TextStyle(
                  color: prefs.dietaryType == 'vegetarian' ? Colors.white : AppColors.textPrimary,
                ),
                onSelected: (_) => ref.read(userPreferencesProvider.notifier).updateDietaryType('vegetarian'),
              ),
              ChoiceChip(
                label: const Text('🌾 Glütensiz'),
                selected: prefs.isGlutenFree,
                selectedColor: AppColors.warning,
                labelStyle: TextStyle(
                  color: prefs.isGlutenFree ? Colors.white : AppColors.textPrimary,
                ),
                onSelected: (val) => ref.read(userPreferencesProvider.notifier).updateGlutenFree(val),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. Bütçe Seviyesi
          const Text(
            '3. Bütçe Tercihi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('💰 Ekonomik (Bakliyat & Sebze)')),
                  selected: prefs.budgetLevel == 'economic',
                  selectedColor: AppColors.secondary,
                  labelStyle: TextStyle(
                    color: prefs.budgetLevel == 'economic' ? Colors.white : AppColors.textPrimary,
                  ),
                  onSelected: (_) => ref.read(userPreferencesProvider.notifier).updateBudgetLevel('economic'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('🥘 Standart (Geniş Yelpaze)')),
                  selected: prefs.budgetLevel == 'moderate',
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: prefs.budgetLevel == 'moderate' ? Colors.white : AppColors.textPrimary,
                  ),
                  onSelected: (_) => ref.read(userPreferencesProvider.notifier).updateBudgetLevel('moderate'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 4. Sevilmeyen Malzemeler
          const Text(
            '4. Evde sevilmeyen veya yenmeyen malzemeler var mı?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Seçtiğiniz malzemeleri içeren yemekler otomatik menüde önerilmez.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commonDisliked.map((item) {
              final isDisliked = prefs.dislikedIngredients.contains(item);
              return FilterChip(
                label: Text(item),
                selected: isDisliked,
                selectedColor: AppColors.primaryLight,
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isDisliked ? AppColors.primaryDark : AppColors.textPrimary,
                  fontWeight: isDisliked ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) {
                  ref.read(userPreferencesProvider.notifier).toggleDislikedIngredient(item);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 5. Alerjenler
          const Text(
            '5. Alerji durumu var mı?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commonAllergies.map((allergy) {
              final isAllergic = prefs.allergies.contains(allergy);
              return FilterChip(
                label: Text(allergy),
                selected: isAllergic,
                selectedColor: AppColors.error.withOpacity(0.15),
                checkmarkColor: AppColors.error,
                labelStyle: TextStyle(
                  color: isAllergic ? AppColors.error : AppColors.textPrimary,
                  fontWeight: isAllergic ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) {
                  ref.read(userPreferencesProvider.notifier).toggleAllergy(allergy);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
