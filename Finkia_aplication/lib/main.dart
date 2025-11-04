import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Oculta barra de estado y botones
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

        // 🌞 Tema claro
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

        // 🌚 Tema oscuro
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

        // Cambia según el sistema
        themeMode: ThemeMode.system,

        home: const SplashScreen(),
      ),
    );
  }
}

class WidgetsBindingObserverApp extends StatefulWidget {
  final Widget child;
  const WidgetsBindingObserverApp({super.key, required this.child});

  @override
  State<WidgetsBindingObserverApp> createState() => _WidgetsBindingObserverAppState();
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
