import 'package:share_plus/share_plus.dart';
import '../utils/turkish_formatters.dart';
import '../../features/meal_planner/domain/models/meal_plan.dart';
import '../../features/shopping_list/domain/models/shopping_item.dart';

/// WhatsApp ve diğer uygulamalarla menü ve alışveriş listesi paylaşım servisi
class ShareService {
  ShareService._();

  /// Haftalık menüyü okunaklı ve emojili WhatsApp metni olarak paylaşır
  static Future<void> shareWeeklyMenuAsText(WeeklyMealPlan plan) async {
    final weekDays = TurkishFormatters.getWeekDays(plan.weekStartDate);
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('🍲 Pişio — Haftalık Yemek Menüm');
    buffer.writeln('📅 ${TurkishFormatters.formatDayMonth(weekDays.first)} - ${TurkishFormatters.formatDayMonth(weekDays.last)}');
    buffer.writeln('--------------------------------');

    for (final date in weekDays) {
      final dayName = TurkishFormatters.getDayName(date.weekday);
      buffer.writeln('\n📌 $dayName (${TurkishFormatters.formatDate(date)})');

      final breakfast = plan.getItem(date, 'breakfast');
      final lunch = plan.getItem(date, 'lunch');
      final dinner = plan.getItem(date, 'dinner');
      final snack = plan.getItem(date, 'snack');

      if (breakfast != null && breakfast.recipe != null) {
        buffer.writeln('  🍳 Kahvaltı: ${breakfast.recipe!.title}');
      }
      if (lunch != null && lunch.recipe != null) {
        buffer.writeln('  🥣 Öğle: ${lunch.recipe!.title}');
      }
      if (dinner != null && dinner.recipe != null) {
        buffer.writeln('  🍛 Akşam: ${dinner.recipe!.title}');
      }
      if (snack != null && snack.recipe != null) {
        buffer.writeln('  🍰 Tatlı / Ara: ${snack.recipe!.title}');
      }

      if (breakfast == null && lunch == null && dinner == null && snack == null) {
        buffer.writeln('  (Planlanmadı)');
      }
    }

    buffer.writeln('\nAfiyet olsun! ✨');
    buffer.writeln('Pişio ile hazırlandı: "Bu hafta ne pişirsem derdine son!"');

    await Share.share(
      buffer.toString(),
      subject: 'Pişio Haftalık Menüm',
    );
  }

  /// Alışveriş listesini reyonlara ayrılmış şekilde WhatsApp metni olarak paylaşır
  static Future<void> shareShoppingListAsText(List<ShoppingItem> items) async {
    if (items.isEmpty) return;

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('🛒 Pişio — Haftalık Alışveriş Listem');
    buffer.writeln('--------------------------------');

    // Reyonlara göre grupla
    final Map<String, List<ShoppingItem>> grouped = {};
    for (final item in items) {
      if (item.isInPantry) continue; // Evde olanları market listesinde gönderme
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    for (final entry in grouped.entries) {
      buffer.writeln('\n🏬 ${entry.key}:');
      for (final item in entry.value) {
        final check = item.isPurchased ? '✅' : '▫️';
        final amountText = TurkishFormatters.formatQuantity(item.amount);
        buffer.writeln('  $check ${item.name} ($amountText ${item.unit})');
      }
    }

    buffer.writeln('\nPişio ile hazırlandı 🌾');

    await Share.share(
      buffer.toString(),
      subject: 'Pişio Alışveriş Listem',
    );
  }
}
