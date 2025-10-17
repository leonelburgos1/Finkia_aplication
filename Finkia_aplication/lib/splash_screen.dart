import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:agrou_aplication/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Inicializamos el video desde los assets
    _controller = VideoPlayerController.asset('assets/videos/1.mp4')
      ..initialize().then((_) {
        _controller.setVolume(1.0); // 🔊 Activa el sonido
        _controller.play(); // ▶️ Inicia automáticamente
        setState(() {});
      });

    // Escucha cuando el video termina
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // ⏩ Cuando termine, pasa a la pantalla de login
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Login()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera memoria del video
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
