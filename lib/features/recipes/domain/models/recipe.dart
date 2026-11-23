import 'ingredient.dart';

/// Pişio Tarif Modeli
class Recipe {
  final String id;
  final String title;
  final String category; // Çorbalar, Bakliyatlar, Zeytinyağlılar vb.
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int baseServings;
  final String difficulty; // kolay, orta, ileri
  final String season; // kış, yaz, her_mevsim
  final String budgetLevel; // ekonomik, orta
  final String prepAheadTip; // Örn: Nohutları bir gece önceden ıslatın
  final List<String> tags;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final bool isFavorite;
  final bool isCustom;

  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    this.baseServings = 4,
    this.difficulty = 'kolay',
    this.season = 'her_mevsim',
    this.budgetLevel = 'ekonomik',
    this.prepAheadTip = '',
    this.tags = const [],
    this.ingredients = const [],
    this.steps = const [],
    this.isFavorite = false,
    this.isCustom = false,
  });

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 15,
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 30,
      baseServings: json['baseServings'] as int? ?? 4,
      difficulty: json['difficulty'] as String? ?? 'kolay',
      season: json['season'] as String? ?? 'her_mevsim',
      budgetLevel: json['budgetLevel'] as String? ?? 'ekonomik',
      prepAheadTip: json['prepAheadTip'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isFavorite: json['isFavorite'] as bool? ?? false,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'baseServings': baseServings,
      'difficulty': difficulty,
      'season': season,
      'budgetLevel': budgetLevel,
      'prepAheadTip': prepAheadTip,
      'tags': tags,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps,
      'isFavorite': isFavorite,
      'isCustom': isCustom,
    };
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? category,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    int? baseServings,
    String? difficulty,
    String? season,
    String? budgetLevel,
    String? prepAheadTip,
    List<String>? tags,
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
    bool? isFavorite,
    bool? isCustom,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      baseServings: baseServings ?? this.baseServings,
      difficulty: difficulty ?? this.difficulty,
      season: season ?? this.season,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      prepAheadTip: prepAheadTip ?? this.prepAheadTip,
      tags: tags ?? this.tags,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      isFavorite: isFavorite ?? this.isFavorite,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
