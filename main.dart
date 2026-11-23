import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web tarayıcısında çalışırken mobil bildirim ve yön kilidi kilitlenmelerini önle
  if (!kIsWeb) {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (_) {}

    try {
      await NotificationService.init();
    } catch (_) {}
  }

  runApp(
    const ProviderScope(
      child: PisioApp(),
    ),
  );
}
