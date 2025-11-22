import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:agrou_aplication/utils/localization_extension.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool isLoading = false;

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.local.contrasenasNoCoinciden)),
      );
      return;
    }

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.local.camposObligatorios)));
      return;
    }

    try {
      setState(() => isLoading = true);

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.local.registroExitoso)));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo según tema
          Image.asset(
            isDark
                ? 'assets/images/register_dark.png'
                : 'assets/images/register_6.jpg', // cambia esta si quieres
            fit: BoxFit.cover,
          ),

          // Panel inferior con blur
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.local.crearCuenta,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color.fromARGB(221, 255, 255, 255),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Campo email
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.15)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: context.local.correoElectronico,
                            hintStyle: TextStyle(
                              color:
                                  isDark ? Colors.white70 : Colors.grey[700],
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Campo contraseña
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.15)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: context.local.contrasena,
                            hintStyle: TextStyle(
                              color:
                                  isDark ? Colors.white70 : Colors.grey[700],
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color:
                                    isDark ? Colors.white70 : Colors.black54,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Confirmar contraseña
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.15)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: context.local.confirmarContrasena,
                            hintStyle: TextStyle(
                              color:
                                  isDark ? Colors.white70 : Colors.grey[700],
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color:
                                    isDark ? Colors.white70 : Colors.black54,
                              ),
                              onPressed: () => setState(() =>
                                  _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Botón registrar
                      SizedBox(
                        width: double.infinity,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                      162, 125, 131, 59),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  context.local.registrarse,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),

                      const SizedBox(height: 10),

                      // Ir al login
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                          );
                        },
                        child: Text(
                          context.local.yaTienesCuenta,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color.fromARGB(221, 255, 255, 255),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
