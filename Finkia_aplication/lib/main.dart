import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'package:agrou_aplication/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// 🎨 PALETA DE COLORES
const Color darkBg = Color(0xFF191A19);
const Color primaryDark = Color(0xFF1E5128);
const Color primaryLight = Color(0xFF4E9F3D);
const Color accentLight = Color(0xFFD8E9A8);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Oculta barra de estado y botones del sistema
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsBindingObserverApp(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finkia',

        // 🌎 Localización
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('es', 'CO'),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },

        // ☀️ TEMA CLARO CON TU PALETA
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: primaryLight,
            secondary: accentLight,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),

        // 🌙 TEMA OSCURO PROFESIONAL
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: darkBg,
          colorScheme: const ColorScheme.dark(
            primary: primaryDark,
            secondary: accentLight,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: darkBg,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          iconTheme: const IconThemeData(color: Colors.white70),
        ),

        // 🔄 Cambia automáticamente según el sistema
        themeMode: ThemeMode.system,

        home: const SplashScreen(),
      ),
    );
  }
}

/// 🔧 Clase para mantener el modo inmersivo
class WidgetsBindingObserverApp extends StatefulWidget {
  final Widget child;
  const WidgetsBindingObserverApp({super.key, required this.child});

  @override
  State<WidgetsBindingObserverApp> createState() =>
      _WidgetsBindingObserverAppState();
}

class _WidgetsBindingObserverAppState extends State<WidgetsBindingObserverApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enableImmersiveMode();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enableImmersiveMode();
    }
  }

  void _enableImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
