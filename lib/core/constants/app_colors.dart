import 'package:flutter/material.dart';

/// Pişio'nun Türk mutfağı sıcaklığını yansıtan özgün renk paleti.
class AppColors {
  AppColors._();

  // Ana Vurgu Rengi: Salça / Terracotta (#D94826)
  static const Color primary = Color(0xFFD94826);
  static const Color primaryDark = Color(0xFFB03518);
  static const Color primaryLight = Color(0xFFFBECE8);

  // İkincil Renk: Zeytinyağı Yeşili (#3E6B48)
  static const Color secondary = Color(0xFF3E6B48);
  static const Color secondaryDark = Color(0xFF2C4C33);
  static const Color secondaryLight = Color(0xFFEBF2EC);

  // Arka Plan & Yüzey
  static const Color background = Color(0xFFFBF9F5); // Kaymak / Taş Baskı
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF4F1EA);

  // Metin Renkleri: Köz Siyahı
  static const Color textPrimary = Color(0xFF23272A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Vurgu & Uyarı Renkleri (Hazırlık notları ve bildirimler için)
  static const Color warning = Color(0xFFE5A93C); // Fırın Sarısı / Safran
  static const Color warningLight = Color(0xFFFEF7E8);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);

  // Kenarlık & Çizgiler
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // Reyon Renkleri (Alışveriş listesi grupları)
  static const Color aisleProduce = Color(0xFF2E7D32); // Manav
  static const Color aisleMeat = Color(0xFFC62828);    // Kasap
  static const Color aisleDairy = Color(0xFF0277BD);   // Süt Ürünleri
  static const Color aisleLegumes = Color(0xFFEF6C00); // Bakliyat & Kuru Gıda
  static const Color aisleSpices = Color(0xFF6D4C41);  // Baharat & Temel Gıda
  static const Color aisleBakery = Color(0xFFF57F17);  // Fırın & Hamur
}
