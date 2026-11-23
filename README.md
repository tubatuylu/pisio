# 🍲 Pişio — Türkiye Pazarına Özel Haftalık Menü Planlama Uygulaması

> *"Bu hafta ne pişirsem derdine son!"*

Pişio, Türkiye'de yaşayan birey ve ailelerin her gün karşılaştığı *"Bugün akşama ne yapsam?"* sorusunu çözen, **%100 ücretsiz, reklamsız ve aboneliksiz** çalışan akıllı haftalık menü planlama ve market alışverişi uygulamasıdır.

---

## 🌟 Öne Çıkan Özellikler (MVP)

1. **Haftalık Menü Takvimi (7 Gün x 4 Öğün):**
   - Pazartesi başlangıçlı 7 günlük takvim (Kahvaltı, Öğle, Akşam, Ara Öğün/Tatlı).
   - Öğünleri kolayca seçme, değiştirme ve silme.
2. **Sihirli Menü Motoru (Tek Tuşla Otomatik Plan):**
   - Hane kişi sayısı, bütçe (Ekonomik / Standart), beslenme şekli (Klasik Türk Mutfağı, Vejetaryen, Glütensiz), alerjenler ve sevilmeyen sebzeler (kereviz, bamya vb.) filtrelenerek 7 günü dengeli doldurur.
3. **Özgün Türk Mutfağı Tarif Kütüphanesi:**
   - Çorbalar, Zeytinyağlılar, Tencere Yemekleri, Bakliyatlar, Pilav-Makarnalar, Börekler, Kahvaltılıklar ve Tatlılar.
   - Türk ev ölçüleri (su bardağı, yemek kaşığı, demet, adet).
4. **Dinamik Porsiyon Ölçekleyici:**
   - 4 kişilik bir tarifin porsiyonu 2 veya 6 kişiye çekildiğinde tüm malzeme miktarları matematiksel olarak anında yeniden oranlanır.
5. **Akıllı ve Reyon Bazlı Alışveriş Listesi:**
   - 7 günlük menüdeki tüm yemeklerin malzemelerini tekilleştirir (örn: 3 yemekteki soğanları birleştirip "5 adet Kuru Soğan" yapar).
   - Türk market reyonlarına göre dizer (*Manav, Kasap, Süt Ürünleri, Bakliyat, Baharat & Temel Gıda*).
   - *"Evde Var"* butonu ile kilerdekileri listeden düşer.
6. **Önceden Hazırlık Hatırlatıcıları:**
   - "Yarın akşam kuru fasulye var; fasulyeleri bu akşamdan ıslatmayı unutmayın!" gibi yerel bildirimler.
7. **WhatsApp ile Paylaşım:**
   - Haftalık menüyü ve alışveriş listesini emojili ve düzenli biçimde WhatsApp'a aktarma.
8. **Misafir Modu & KVKK Uyum:**
   - Giriş yapmadan anında çevrimdışı (offline-first) kullanım.
   - Tek dokunuşla kanunen "Hesabımı ve Tüm Verilerimi Kalıcı Olarak Sil" desteği.

---

## 🎨 Tasarım & Renk Paleti

- **Ana Renk (Salça / Terracotta):** `#D94826`
- **İkincil Renk (Zeytinyağı Yeşili):** `#3E6B48`
- **Arka Plan (Kaymak / Taş Baskı):** `#FBF9F5`
- **Yüzey:** `#FFFFFF`
- **Metin (Köz Siyahı):** `#23272A`
- **Uyarı & İpucu (Fırın Sarısı / Safran):** `#E5A93C`

---

## 🏗 Mimari ve Teknoloji Yığını

- **Framework:** Flutter 3.19+ (iOS & Android)
- **State Management:** Flutter Riverpod
- **Yerel Veritabanı (Offline-First):** Drift (Type-Safe SQLite)
- **Bulut Senkronizasyonu:** Supabase (PostgreSQL - 100% Ücretsiz Katman)
- **Bildirimler:** flutter_local_notifications
- **Paylaşım:** share_plus
- **Yazılım Deseni:** Clean Architecture (Domain, Data, Presentation) & Feature-First klasör yapısı.

---

## 🚀 Kurulum ve Çalıştırma

Projeyi çalıştırmak için:

```bash
# 1. Proje dizinine gidin
cd C:\Users\tugbak\.gemini\antigravity\scratch\pisio

# 2. Bağımlılıkları yükleyin
flutter pub get

# 3. Testleri çalıştırın
flutter test

# 4. Uygulamayı başlatın
flutter run
```
