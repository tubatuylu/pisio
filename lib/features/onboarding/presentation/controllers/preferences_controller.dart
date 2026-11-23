import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_preferences.dart';

/// Kullanıcı Tercihleri Notifier
class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier() : super(const UserPreferences());

  void updateHouseholdSize(int size) {
    state = state.copyWith(householdSize: size);
  }

  void updateDietaryType(String type) {
    state = state.copyWith(dietaryType: type);
  }

  void updateGlutenFree(bool isGlutenFree) {
    state = state.copyWith(isGlutenFree: isGlutenFree);
  }

  void updateBudgetLevel(String budget) {
    state = state.copyWith(budgetLevel: budget);
  }

  void toggleAllergy(String allergy) {
    final current = List<String>.from(state.allergies);
    if (current.contains(allergy)) {
      current.remove(allergy);
    } else {
      current.add(allergy);
    }
    state = state.copyWith(allergies: current);
  }

  void toggleDislikedIngredient(String ingredient) {
    final current = List<String>.from(state.dislikedIngredients);
    if (current.contains(ingredient)) {
      current.remove(ingredient);
    } else {
      current.add(ingredient);
    }
    state = state.copyWith(dislikedIngredients: current);
  }

  void completeOnboarding() {
    state = state.copyWith(isOnboardingCompleted: true);
  }
}

final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier();
});
