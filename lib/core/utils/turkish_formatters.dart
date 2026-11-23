/// Türkiye yerelleştirmesi için tarih, sayı ve ölçü biçimlendiriciler.
/// (Web ve mobil platformlarda bağımsız ve %100 güvenli çalışır)
class TurkishFormatters {
  TurkishFormatters._();

  static const List<String> _months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  /// Tarihi GG.AA.YYYY biçiminde döndürür (Örn: 23.11.2026)
  static String formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d.$m.${date.year}';
  }

  /// Tarihi "23 Kasım" biçiminde döndürür (Harici locale tablosu gerektirmez)
  static String formatDayMonth(DateTime date) {
    final monthName = (date.month >= 1 && date.month <= 12)
        ? _months[date.month - 1]
        : '';
    return '${date.day} $monthName';
  }

  /// Sayıyı Türkiye standardında biçimlendirir (Örn: 1.250,50)
  static String formatNumber(double number) {
    final isNegative = number < 0;
    final absNum = number.abs();
    final parts = absNum.toStringAsFixed(2).split('.');
    final integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    final formatted = '$integerPart,${parts[1]}';
    return isNegative ? '-$formatted' : formatted;
  }

  /// Para birimini biçimlendirir
  static String formatCurrency(double amount) {
    return '${formatNumber(amount)} ₺';
  }

  /// Verilen tarihin ait olduğu haftanın Pazartesi gününü döndürür (Hafta Pazartesi başlar)
  static DateTime getWeekMonday(DateTime date) {
    return DateTime(date.year, date.month, date.day).subtract(
      Duration(days: date.weekday - 1),
    );
  }

  /// Pazartesi'den Pazar'a haftanın 7 gününü liste olarak döndürür
  static List<DateTime> getWeekDays(DateTime date) {
    final monday = getWeekMonday(date);
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  /// Gün indeksine (1: Pazartesi .. 7: Pazar) göre Türkçe gün adı
  static String getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Pazartesi';
      case 2:
        return 'Salı';
      case 3:
        return 'Çarşamba';
      case 4:
        return 'Perşembe';
      case 5:
        return 'Cuma';
      case 6:
        return 'Cumartesi';
      case 7:
        return 'Pazar';
      default:
        return '';
    }
  }

  /// Gün indeksine göre kısa Türkçe gün adı
  static String getShortDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Pzt';
      case 2:
        return 'Sal';
      case 3:
        return 'Çar';
      case 4:
        return 'Per';
      case 5:
        return 'Cum';
      case 6:
        return 'Cmt';
      case 7:
        return 'Paz';
      default:
        return '';
    }
  }

  /// Öğün türü Türkçe adı
  static String getMealTypeName(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'Kahvaltı';
      case 'lunch':
        return 'Öğle Yemeği';
      case 'dinner':
        return 'Akşam Yemeği';
      case 'snack':
        return 'Ara Öğün / Tatlı';
      default:
        return mealType;
    }
  }

  /// Miktarı Türkçe mutfak ölçüsü olarak formatlar (Örn: 0.5 -> ½)
  static String formatQuantity(double amount) {
    if ((amount - 0.5).abs() < 0.01) return '½';
    if ((amount - 0.25).abs() < 0.01) return '¼';
    if ((amount - 0.75).abs() < 0.01) return '¾';
    if ((amount - 1.5).abs() < 0.01) return '1 ½';
    if ((amount - 2.5).abs() < 0.01) return '2 ½';

    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(1).replaceAll('.', ',');
  }
}
