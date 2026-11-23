import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/ingredient.dart';
import '../controllers/recipe_controller.dart';

class AddCustomRecipeScreen extends ConsumerStatefulWidget {
  const AddCustomRecipeScreen({super.key});

  @override
  ConsumerState<AddCustomRecipeScreen> createState() => _AddCustomRecipeScreenState();
}

class _AddCustomRecipeScreenState extends ConsumerState<AddCustomRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _prepTimeController = TextEditingController(text: '15');
  final _cookTimeController = TextEditingController(text: '30');
  final _servingsController = TextEditingController(text: '4');
  final _prepAheadTipController = TextEditingController();

  String _selectedCategory = 'Tencere & Etli Yemekler';
  String _difficulty = 'kolay';
  String _budget = 'ekonomik';

  final List<RecipeIngredient> _ingredients = [];
  final List<String> _steps = [];

  final _ingredientNameController = TextEditingController();
  final _ingredientAmountController = TextEditingController(text: '1');
  final _ingredientUnitController = TextEditingController(text: 'adet');
  final _stepController = TextEditingController();

  void _addIngredient() {
    final name = _ingredientNameController.text.trim();
    final amount = double.tryParse(_ingredientAmountController.text.trim()) ?? 1.0;
    final unit = _ingredientUnitController.text.trim();

    if (name.isNotEmpty) {
      setState(() {
        _ingredients.add(
          RecipeIngredient(
            ingredientId: 'custom_${DateTime.now().millisecondsSinceEpoch}',
            name: name,
            amount: amount,
            unit: unit.isEmpty ? 'adet' : unit,
            category: 'Temel Gıda',
          ),
        );
        _ingredientNameController.clear();
        _ingredientAmountController.text = '1';
      });
    }
  }

  void _addStep() {
    final text = _stepController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _steps.add(text);
        _stepController.clear();
      });
    }
  }

  void _saveRecipe() {
    if (!_formKey.currentState!.validate()) return;
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir malzeme ekleyin.')),
      );
      return;
    }

    final newRecipe = Recipe(
      id: 'custom_${const Uuid().v4()}',
      title: _titleController.text.trim(),
      category: _selectedCategory,
      prepTimeMinutes: int.tryParse(_prepTimeController.text) ?? 15,
      cookTimeMinutes: int.tryParse(_cookTimeController.text) ?? 30,
      baseServings: int.tryParse(_servingsController.text) ?? 4,
      difficulty: _difficulty,
      budgetLevel: _budget,
      prepAheadTip: _prepAheadTipController.text.trim(),
      ingredients: _ingredients,
      steps: _steps.isEmpty ? ['Malzemeleri birleştirip pişirin.'] : _steps,
      isCustom: true,
    );

    ref.read(recipeRepositoryProvider).addCustomRecipe(newRecipe);
    ref.invalidate(filteredRecipesProvider);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Özel tarifiniz başarıyla kaydedildi!'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kendi Tarifini Ekle'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tarif Adı
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tarif Adı *',
                hintText: 'Örn: Annemin Özel Ezogelin Çorbası',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Tarif adı zorunludur' : null,
            ),
            const SizedBox(height: 16),

            // Kategori Seçimi
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: const [
                'Çorbalar',
                'Bakliyatlar',
                'Tencere & Etli Yemekler',
                'Zeytinyağlılar & Sebze',
                'Pilav & Makarnalar',
                'Börek & Hamur İşi',
                'Kahvaltılıklar',
                'Tatlılar',
                'Salata & Mezeler',
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 16),

            // Süre ve Porsiyon
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _prepTimeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Hazırlık (dk)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cookTimeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Pişirme (dk)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Porsiyon'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Önceden Hazırlık İpucu
            TextFormField(
              controller: _prepAheadTipController,
              decoration: const InputDecoration(
                labelText: 'Önceden Hazırlık İpucu (İsteğe Bağlı)',
                hintText: 'Örn: Fasulyeleri akşamdan ıslatmayı unutmayın',
              ),
            ),
            const SizedBox(height: 24),

            // Malzeme Ekleme Alanı
            const Text(
              'Malzemeler *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _ingredientNameController,
                    decoration: const InputDecoration(hintText: 'Malzeme adı'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _ingredientAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Miktar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _ingredientUnitController,
                    decoration: const InputDecoration(hintText: 'Birim (su bardağı, adet)'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
                  onPressed: _addIngredient,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._ingredients.map((ing) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.check, color: AppColors.secondary, size: 18),
                  title: Text('${ing.name} (${ing.amount} ${ing.unit})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                    onPressed: () => setState(() => _ingredients.remove(ing)),
                  ),
                )),
            const SizedBox(height: 24),

            // Adım Ekleme Alanı
            const Text(
              'Hazırlanış Adımları',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _stepController,
                    decoration: const InputDecoration(hintText: 'Adım talimatını yazın'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
                  onPressed: _addStep,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._steps.asMap().entries.map((entry) => ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primaryLight,
                    child: Text('${entry.key + 1}', style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                  ),
                  title: Text(entry.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                    onPressed: () => setState(() => _steps.removeAt(entry.key)),
                  ),
                )),
            const SizedBox(height: 32),

            // Kaydet Butonu
            ElevatedButton(
              onPressed: _saveRecipe,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Tarifi Kaydet', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
