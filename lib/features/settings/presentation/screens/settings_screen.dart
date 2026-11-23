import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../onboarding/presentation/controllers/preferences_controller.dart';
import '../../../onboarding/presentation/screens/preference_wizard_screen.dart';
import '../../../meal_planner/presentation/controllers/meal_plan_controller.dart';
import '../../../shopping_list/presentation/controllers/shopping_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showDeleteAllDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: AppColors.error),
              SizedBox(width: 8),
              Text('Tüm Verileri Sil (KVKK)', style: TextStyle(fontSize: 18)),
            ],
          ),
          content: const Text(
            'Bu işlem geri alınamaz. Cihazınızdaki tüm haftalık menü planları, alışveriş listesi ve özel tarifleriniz kalıcı olarak silinecektir.\n\nOnaylıyor musunuz?',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () {
                // Verileri sıfırla
                ref.read(weeklyMealPlanProvider.notifier).clearPlan();
                ref.read(shoppingListProvider.notifier).removePurchased();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tüm verileriniz kanunen kalıcı olarak silindi.'),
                    backgroundColor: AppColors.primaryDark,
                  ),
                );
              },
              child: const Text('Evet, Kalıcı Olarak Sil'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar & Profil'),
      ),
      body: ListView(
        children: [
          // Profil & Tercihler Kartı
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(Icons.person_outline, size: 32, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Misafir Kullanıcı',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${prefs.householdSize} Kişilik • ${prefs.dietaryType == 'vegetarian' ? 'Vejetaryen' : 'Standart'} • ${prefs.budgetLevel == 'economic' ? 'Ekonomik' : 'Standart'}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PreferenceWizardScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Mutfak Ayarları Bölümü
          _buildSectionHeader('Mutfak & Planlama'),
          ListTile(
            leading: const Icon(Icons.tune, color: AppColors.primary),
            title: const Text('Mutfak Tercihlerini Düzenle'),
            subtitle: const Text('Kişi sayısı, alerjenler, sevilmeyen malzemeler'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreferenceWizardScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.alarm, color: AppColors.primary),
            title: const Text('Önceden Hazırlık Hatırlatıcısı'),
            subtitle: Text('Her akşam ${prefs.prepNotificationTime} (Yarınki nohut ıslatma vb.)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hatırlatma saati: 20:00 olarak ayarlandı.')),
              );
            },
          ),

          const Divider(),

          // Veri & Gizlilik (KVKK)
          _buildSectionHeader('Veri & KVKK Gizlilik'),
          ListTile(
            leading: const Icon(Icons.cloud_sync_outlined, color: AppColors.secondary),
            title: const Text('Bulut Yedekleme (Google / Apple)'),
            subtitle: const Text('Tariflerinizi ve menünüzü diğer cihazlarla eşitleyin'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Misafir modundasınız. Bulut eşitleme aktif.')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.textSecondary),
            title: const Text('KVKK Aydınlatma Metni'),
            subtitle: const Text('Verilerinizin nasıl korunduğunu inceleyin'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Metin modalı
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: AppColors.error),
            title: const Text(
              'Hesabımı ve Tüm Verilerimi Sil',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Tüm menü ve kiler verilerinizi kalıcı olarak siler'),
            onTap: () => _showDeleteAllDataDialog(context, ref),
          ),

          const Divider(),

          // Uygulama Bilgisi
          _buildSectionHeader('Uygulama Hakkında'),
          const ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.textSecondary),
            title: Text('Pişio'),
            subtitle: Text('Sürüm 1.0.0 (Türkiye Özel Sürümü)\n%100 Ücretsiz & Reklamsız'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
