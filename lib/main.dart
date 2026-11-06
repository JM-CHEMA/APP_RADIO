import 'package:audio_service/audio_service.dart' as bg;
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/providers/app_provider.dart';
import 'package:radio_app/helpers/providers/audio_provider.dart';
import 'package:radio_app/screens/splash_screen.dart';
import 'package:radio_app/services/audio_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Un servicio nativo compartido para app, notificación y pantalla bloqueada.
  final audioHandler = await bg.AudioService.init<RadioAudioService>(
    builder: RadioAudioService.new,
    config: const bg.AudioServiceConfig(
      androidNotificationChannelId: 'com.radio_app.audio',
      androidNotificationChannelName: 'Radio en vivo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  // La sesión se configura después de crear el reproductor.
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider(audioHandler)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Radio App',
    theme: AppTheme.darkTheme,
    home: const SplashScreen(),
  );
}
