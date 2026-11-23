import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/meal_planner/domain/models/meal_plan.dart';

/// Pişio Akıllı Önceden Hazırlık ve Menü Hatırlatıcı Servisi
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  /// Bildirim eklentisini başlatır
  static Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(initSettings);
      _isInitialized = true;
    } catch (e) {
      // Test ortamlarında hata fırlatmasını önler
      _isInitialized = false;
    }
  }

  /// Anlık test bildirimi gönderir
  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'pisio_prep_channel',
      'Yemek Hazırlık Hatırlatıcıları',
      channelDescription: 'Yarın pişirilecek yemeklerin önceden hazırlık uyarıları',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(id, title, body, details);
  }

  /// Haftalık plandaki yarınki yemeklerin hazırlık uyarılarını kontrol edip planlar
  static Future<void> scheduleTomorrowPrepAlerts(WeeklyMealPlan plan) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    // Yarınki akşam yemeğini bul
    final tomorrowDinner = plan.getItem(tomorrow, 'dinner');
    final recipe = tomorrowDinner?.recipe;

    if (recipe != null && recipe.prepAheadTip.isNotEmpty) {
      // Hazırlık ipucu var (Örn: Nohutları akşamdan ıslatın)
      await showInstantNotification(
        id: 101,
        title: '🍲 Yarın Akşam: ${recipe.title}',
        body: 'Hatırlatma: ${recipe.prepAheadTip}',
      );
    }
  }
}
