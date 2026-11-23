import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dikey ekran kilitleme (mobil deneyim odaklı)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Yerel bildirim servisi başlatma
  await NotificationService.init();

  runApp(
    const ProviderScope(
      child: PisioApp(),
    ),
  );
}
