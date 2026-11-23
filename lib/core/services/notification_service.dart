/// Bildirim Servisi — Web için no-op stub
class NotificationService {
  NotificationService._();

  static Future<void> init() async {}

  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {}
}
