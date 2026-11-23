import 'package:intl/intl.dart';

/// Türkiye yerelleştirmesi için tarih, sayı ve ölçü biçimlendiriciler.
class TurkishFormatters {
  TurkishFormatters._();

  static final DateFormat _dateOnlyFormat = DateFormat('dd.MM.yyyy');
  static final DateFormat _dayMonthFormat = DateFormat('d MMMM', 'tr_TR');
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
  );

  /// Tarihi GG.AA.YYYY biçiminde döndürür.
  static String formatDate(DateTime date) {
    return _dateOnlyFormat.format(date);
  }

  /// Tarihi "23 Kasım" biçiminde döndürür.
  static String formatDayMonth(DateTime date) {
    return _dayMonthFormat.format(date);
  }

  /// Sayıyı Türkiye standardında biçimlendirir (Örn: 1.250,50)
  static String formatNumber(double number) {
    final formatter = NumberFormat('#,##0.##', 'tr_TR');
    return formatter.format(number);
  }

  /// Para birimini biçimlendirir
  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  /// Verilen tarihin ait olduğu haftanın Pazartesi gününü döndürür (Hafta Pazartesi başlar)
  static DateTime getWeekMonday(DateTime date) {
    // date.weekday: Pazartesi = 1, Pazar = 7
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

  /// Miktarı Türkçe mutfak ölçüsü olarak güzelleştirir (Örn: 0.5 -> 1/2)
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
