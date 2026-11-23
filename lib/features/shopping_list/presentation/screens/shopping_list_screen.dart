import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/turkish_formatters.dart';
import '../controllers/shopping_controller.dart';
import '../../domain/models/shopping_item.dart';
import '../../../../core/services/share_service.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  void _showAddCustomItemDialog() {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '1');
    final unitCtrl = TextEditingController(text: 'adet');
    String selectedCat = 'Manav';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Listeye Malzeme Ekle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ürün Adı',
                  hintText: 'Örn: Maden Suyu, Çay, Havlu Kağıt',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Miktar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: unitCtrl,
                      decoration: const InputDecoration(labelText: 'Birim (adet, paket, kg)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCat,
                decoration: const InputDecoration(labelText: 'Reyon / Kategori'),
                items: const [
                  'Manav',
                  'Kasap & Şarküteri',
                  'Süt Ürünleri',
                  'Bakliyat & Kuru Gıda',
                  'Temel Gıda & Baharat',
                  'Fırın & Hamur İşi',
                ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => selectedCat = v ?? 'Manav',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final amount = double.tryParse(amountCtrl.text.trim()) ?? 1.0;
                    final unit = unitCtrl.text.trim();

                    if (name.isNotEmpty) {
                      ref.read(shoppingListProvider.notifier).addManualItem(
                            name: name,
                            amount: amount,
                            unit: unit.isEmpty ? 'adet' : unit,
                            category: selectedCat,
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Listeye Ekle'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(shoppingListProvider);

    final toBuyItems = items.where((i) => !i.isInPantry).toList();
    final pantryItems = items.where((i) => i.isInPantry).toList();
    final purchasedCount = toBuyItems.where((i) => i.isPurchased).length;
    final totalToBuy = toBuyItems.length;

    // Reyonlara göre grupla
    final Map<String, List<ShoppingItem>> groupedToBuy = {};
    for (final item in toBuyItems) {
      groupedToBuy.putIfAbsent(item.category, () => []).add(item);
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Alışveriş Listesi'),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'WhatsApp ile Paylaş',
              onPressed: () {
                ShareService.shareShoppingListAsText(items);
              },
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'clear_purchased',
                  child: Text('Alınanları Temizle'),
                ),
              ],
              onSelected: (val) {
                if (val == 'clear_purchased') {
                  ref.read(shoppingListProvider.notifier).removePurchased();
                }
              },
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Alınacaklar'),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$totalToBuy',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Evde Var'),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${pantryItems.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Ürün Ekle'),
          onPressed: _showAddCustomItemDialog,
        ),
        body: TabBarView(
          children: [
            // 1. SEKME: ALINACAKLAR
            Column(
              children: [
                // İlerleme Çubuğu (Kaç tanesi sepete atıldı)
                if (totalToBuy > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: AppColors.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sepet İlerlemesi: $purchasedCount / $totalToBuy Alındı',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '%${((purchasedCount / totalToBuy) * 100).toInt()}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: totalToBuy > 0 ? (purchasedCount / totalToBuy) : 0,
                            backgroundColor: AppColors.borderLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Reyon Bazlı Liste
                Expanded(
                  child: toBuyItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.shopping_basket_outlined, size: 64, color: AppColors.textMuted),
                                const SizedBox(height: 16),
                                const Text(
                                  'Alışveriş listeniz şu an boş.',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Haftalık menünüze yemek eklediğinizde malzemeler market reyonlarına göre buraya otomatik toplanır.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: groupedToBuy.keys.length,
                          itemBuilder: (context, catIndex) {
                            final category = groupedToBuy.keys.elementAt(catIndex);
                            final catItems = groupedToBuy[category]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Reyon Başlığı
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: _getAisleColor(category),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        category.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: _getAisleColor(category),
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '(${catItems.length})',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),

                                // Reyon Kalemleri
                                ...catItems.map((item) {
                                  final amountText = TurkishFormatters.formatQuantity(item.amount);
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: item.isPurchased ? AppColors.surfaceMuted : AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: item.isPurchased ? AppColors.borderLight : AppColors.border,
                                      ),
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      leading: Checkbox(
                                        value: item.isPurchased,
                                        activeColor: AppColors.secondary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        onChanged: (_) {
                                          ref.read(shoppingListProvider.notifier).togglePurchased(item.id);
                                        },
                                      ),
                                      title: Text(
                                        item.name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                                          color: item.isPurchased ? AppColors.textMuted : AppColors.textPrimary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '$amountText ${item.unit}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: item.isPurchased ? AppColors.textMuted : AppColors.primary,
                                        ),
                                      ),
                                      trailing: TextButton.icon(
                                        icon: const Icon(Icons.home_outlined, size: 16),
                                        label: const Text('Evde Var', style: TextStyle(fontSize: 11)),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColors.textSecondary,
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        onPressed: () {
                                          ref.read(shoppingListProvider.notifier).toggleInPantry(item.id);
                                        },
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),

            // 2. SEKME: EVDE VAR (KİLER)
            pantryItems.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Kilerde işaretlenmiş malzeme bulunmuyor.\nListeden "Evde Var" butonuna basarak evdeki malzemeleri market alışverişinden çıkarabilirsiniz.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: pantryItems.length,
                    itemBuilder: (context, index) {
                      final item = pantryItems[index];
                      final amountText = TurkishFormatters.formatQuantity(item.amount);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.check_circle, color: AppColors.secondary),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text('$amountText ${item.unit} • ${item.category}'),
                          trailing: TextButton(
                            child: const Text('Listeye Geri Al', style: TextStyle(fontSize: 12)),
                            onPressed: () {
                              ref.read(shoppingListProvider.notifier).toggleInPantry(item.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Color _getAisleColor(String category) {
    switch (category) {
      case 'Manav':
        return AppColors.aisleProduce;
      case 'Kasap & Şarküteri':
        return AppColors.aisleMeat;
      case 'Süt Ürünleri':
        return AppColors.aisleDairy;
      case 'Bakliyat & Kuru Gıda':
        return AppColors.aisleLegumes;
      case 'Fırın & Hamur İşi':
        return AppColors.aisleBakery;
      default:
        return AppColors.aisleSpices;
    }
  }
}
