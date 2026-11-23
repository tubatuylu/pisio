import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'preference_wizard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isKvkkAccepted = false;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      icon: Icons.soup_kitchen,
      title: 'Bu Hafta Ne Pişirsem\nDerdine Son!',
      description:
          'Her gün akşam ne pişireceğinizi düşünmeyin. Türk mutfağına özel lezzetlerle haftalık menünüzü tek tıkla planlayın.',
    ),
    _OnboardingPageData(
      icon: Icons.shopping_basket_outlined,
      title: 'Akıllı ve Reyon Bazlı\nAlışveriş Listesi',
      description:
          'Haftalık menünüzdeki tüm malzemeler tekilleştirilir, market reyonlarına göre toplanır. Evde olanları tek dokunuşla listeden çıkarın.',
    ),
    _OnboardingPageData(
      icon: Icons.favorite_border,
      title: 'Tamamen Ücretsiz &\nReklamsız Deneyim',
      description:
          'Abonelik yok, ödeme duvarı yok. Bütçenize, aile kişi sayınıza ve sevdiğiniz lezzetlere göre sofranızı bereketlendirin.',
    ),
  ];

  void _showKvkkModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollCtrl) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollCtrl,
                children: const [
                  Text(
                    'KVKK Aydınlatma Metni & Gizlilik Politikası',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Pişio ("Uygulama"), 6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") kapsamında kullanıcılarının gizliliğine azami özen göstermektedir.\n\n'
                    '1. Veri Sorumlusu:\n'
                    'Pişio mobil uygulaması, yemek planlama ve alışveriş listesi yönetiminde çevrimdışı (cihaz içi) öncelikli mimari benimser.\n\n'
                    '2. İşlenen Kişisel Veriler:\n'
                    '- Hane kişi sayısı, beslenme tercihleri, alerjen ve sevilmeyen malzeme tercihleri.\n'
                    '- Oluşturulan haftalık menüler ve alışveriş listesi kalemleri.\n'
                    'Bu veriler cihazınızda yerel SQLite veritabanında saklanır; isteğe bağlı olarak bulut yedeklemesi için Supabase altyapısına şifreli olarak senkronize edilebilir.\n\n'
                    '3. Verilerin Silinmesi (Unutulma Hakkı):\n'
                    'Kullanıcı, Ayarlar > "Hesabımı ve Tüm Verilerimi Sil" ekranından tek bir dokunuşla tüm yerel ve bulut verilerini kanunen kalıcı olarak imha etme hakkına sahiptir.\n\n'
                    '4. Ticari İleti ve Üçüncü Taraflar:\n'
                    'Verileriniz asla üçüncü taraflara satılmaz, reklam ağlarıyla paylaşılmaz.',
                    style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.textPrimary),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 64, color: AppColors.primary),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Sayfa Göstergeleri (Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final isSelected = _currentPage == index;
                return Container(
                  width: isSelected ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // KVKK Onay Kutusu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Checkbox(
                    value: _isKvkkAccepted,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _isKvkkAccepted = v ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _showKvkkModal,
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          children: [
                            TextSpan(text: 'Kullanıma devam ederek '),
                            TextSpan(
                              text: 'KVKK Aydınlatma Metni',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: "'ni okudum ve onaylıyorum."),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Başla Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isKvkkAccepted
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PreferenceWizardScreen(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Mutfak Tercihlerimi Ayarla', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
