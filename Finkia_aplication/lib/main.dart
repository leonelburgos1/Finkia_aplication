import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'package:agrou_aplication/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones generadas automáticamente
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

        // Localización (idiomas)
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // Inglés
          Locale('es'), // Español
          Locale('es', 'CO'), // Español (Colombia)
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },

        // Tema claro
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),

        // Tema oscuro
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          iconTheme: const IconThemeData(color: Colors.white70),
        ),

        themeMode: ThemeMode.system, // Cambia según el sistema

        home: const SplashScreen(),
      ),
    );
  }
}

/// 🔧 Clase que mantiene el modo inmersivo activo cuando se reanuda la app
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
