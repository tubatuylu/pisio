import 'package:flutter_test/flutter_test.dart';
import 'package:pisio/core/utils/portion_scaler.dart';
import 'package:pisio/core/utils/turkish_formatters.dart';

void main() {
  group('PortionScaler & TurkishFormatters Testleri', () {
    test('Porsiyon 4 kişiden 2 kişiye düştüğünde malzeme miktarı yarıya inmelidir', () {
      final scaled = PortionScaler.scaleAmount(
        baseAmount: 2.0,
        baseServings: 4,
        targetServings: 2,
      );
      expect(scaled, 1.0);
    });

    test('Porsiyon 4 kişiden 6 kişiye çıktığında malzeme miktarı 1.5 katına çıkmalıdır', () {
      final scaled = PortionScaler.scaleAmount(
        baseAmount: 1.0,
        baseServings: 4,
        targetServings: 6,
      );
      expect(scaled, 1.5);
    });

    test('0.5 ölçü ½ olarak güzel formatlanmalıdır', () {
      final formatted = TurkishFormatters.formatQuantity(0.5);
      expect(formatted, '½');
    });

    test('1.5 ölçü 1 ½ olarak güzel formatlanmalıdır', () {
      final formatted = TurkishFormatters.formatQuantity(1.5);
      expect(formatted, '1 ½');
    });

    test('Pazartesi başlangıçlı hafta hesabı doğrulanmalıdır', () {
      final testDate = DateTime(2026, 11, 25); // Çarşamba
      final monday = TurkishFormatters.getWeekMonday(testDate);
      expect(monday.weekday, 1); // Pazartesi
      expect(monday.day, 23);
    });
  });
}
