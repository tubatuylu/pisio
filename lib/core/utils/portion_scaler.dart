import 'turkish_formatters.dart';

/// Tarif malzemelerini kişi sayısına göre dinamik ölçekleyen hesaplayıcı.
class PortionScaler {
  PortionScaler._();

  /// Verilen miktarı hedef porsiyona göre ölçekler
  static double scaleAmount({
    required double baseAmount,
    required int baseServings,
    required int targetServings,
  }) {
    if (baseServings <= 0 || targetServings <= 0) return baseAmount;
    final ratio = targetServings / baseServings;
    return baseAmount * ratio;
  }

  /// Ölçeklenmiş miktarı ve birimi okunaklı Türkçe metne çevirir
  /// Örn: "1 ½ su bardağı", "2 adet", "250 gram"
  static String formatScaledIngredient({
    required double baseAmount,
    required int baseServings,
    required int targetServings,
    required String unit,
  }) {
    final scaled = scaleAmount(
      baseAmount: baseAmount,
      baseServings: baseServings,
      targetServings: targetServings,
    );
    final formattedAmount = TurkishFormatters.formatQuantity(scaled);
    return '$formattedAmount $unit';
  }
}
