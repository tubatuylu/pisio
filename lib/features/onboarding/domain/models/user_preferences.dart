/// Kullanıcı Beslenme ve Mutfak Tercihleri Modeli
class UserPreferences {
  final int householdSize; // Kişi sayısı (1, 2, 4, 6 vb.)
  final String dietaryType; // 'standard', 'vegetarian', 'vegan'
  final bool isGlutenFree;
  final String budgetLevel; // 'economic', 'moderate'
  final List<String> allergies; // ['fındık', 'laktoz']
  final List<String> dislikedIngredients; // ['kereviz', 'bamya', 'patlıcan']
  final String prepNotificationTime; // '20:00'
  final bool isOnboardingCompleted;

  const UserPreferences({
    this.householdSize = 4,
    this.dietaryType = 'standard',
    this.isGlutenFree = false,
    this.budgetLevel = 'economic',
    this.allergies = const [],
    this.dislikedIngredients = const [],
    this.prepNotificationTime = '20:00',
    this.isOnboardingCompleted = false,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      householdSize: json['householdSize'] as int? ?? 4,
      dietaryType: json['dietaryType'] as String? ?? 'standard',
      isGlutenFree: json['isGlutenFree'] as bool? ?? false,
      budgetLevel: json['budgetLevel'] as String? ?? 'economic',
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      dislikedIngredients: (json['dislikedIngredients'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      prepNotificationTime: json['prepNotificationTime'] as String? ?? '20:00',
      isOnboardingCompleted: json['isOnboardingCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'householdSize': householdSize,
      'dietaryType': dietaryType,
      'isGlutenFree': isGlutenFree,
      'budgetLevel': budgetLevel,
      'allergies': allergies,
      'dislikedIngredients': dislikedIngredients,
      'prepNotificationTime': prepNotificationTime,
      'isOnboardingCompleted': isOnboardingCompleted,
    };
  }

  UserPreferences copyWith({
    int? householdSize,
    String? dietaryType,
    bool? isGlutenFree,
    String? budgetLevel,
    List<String>? allergies,
    List<String>? dislikedIngredients,
    String? prepNotificationTime,
    bool? isOnboardingCompleted,
  }) {
    return UserPreferences(
      householdSize: householdSize ?? this.householdSize,
      dietaryType: dietaryType ?? this.dietaryType,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      allergies: allergies ?? this.allergies,
      dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
      prepNotificationTime: prepNotificationTime ?? this.prepNotificationTime,
      isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }
}
