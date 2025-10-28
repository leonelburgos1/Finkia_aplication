import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 👇 Oculta barra de estado y botones de navegación (modo inmersivo total)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 👇 Asegura que el modo inmersivo se mantenga activo cada vez que se reconstruya la app
    return WidgetsBindingObserverApp(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finkia',
        theme: ThemeData(primarySwatch: Colors.green),
        home: const SplashScreen(),
      ),
    );
  }
}

/// 👇 Clase personalizada que mantiene el modo inmersivo activo siempre
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
    // 👇 Cada vez que la app vuelve a primer plano, reactiva el modo inmersivo
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
