import 'package:drift/drift.dart';

/// Drift Tablo Tanımları (Pişio İlişkisel Veritabanı)

class RecipesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 150)();
  TextColumn get category => text()();
  IntColumn get prepTimeMinutes => integer()();
  IntColumn get cookTimeMinutes => integer()();
  IntColumn get baseServings => integer().withDefault(const Constant(4))();
  TextColumn get difficulty => text().withDefault(const Constant('kolay'))();
  TextColumn get season => text().withDefault(const Constant('her_mevsim'))();
  TextColumn get budgetLevel => text().withDefault(const Constant('ekonomik'))();
  TextColumn get prepAheadTip => text().withDefault(const Constant(''))();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get stepsJson => text().withDefault(const Constant('[]'))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class IngredientsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get defaultUnit => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class RecipeIngredientsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recipeId => text().references(RecipesTable, #id)();
  TextColumn get ingredientId => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
  TextColumn get category => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

class MealPlanItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get mealPlanId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get mealType => text()(); // 'breakfast', 'lunch', 'dinner', 'snack'
  TextColumn get recipeId => text().nullable().references(RecipesTable, #id)();
  TextColumn get customTitle => text().nullable()();
  IntColumn get servings => integer().withDefault(const Constant(4))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class ShoppingItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
  TextColumn get category => text()();
  BoolColumn get isInPantry => boolean().withDefault(const Constant(false))();
  BoolColumn get isPurchased => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}
