import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrou_aplication/utils/localization_extension.dart';
import 'form_finca.dart';
import 'inicio.dart';

class FincasPage extends StatefulWidget {
  const FincasPage({super.key});

  @override
  State<FincasPage> createState() => _FincasPageState();
}

class _FincasPageState extends State<FincasPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _fincasStream;

  @override
  void initState() {
    super.initState();
    // Escucha en tiempo real los cambios en la colección "fincas"
    final user = FirebaseAuth.instance.currentUser;

    _fincasStream = _firestore
        .collection('fincas')
        .where('uid', isEqualTo: user?.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: Text(
          context.local.misFincas,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // 🔥 StreamBuilder para escuchar los datos de Firebase
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _fincasStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  final fincas = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: fincas.length,
                    itemBuilder: (context, index) {
                      final data = fincas[index].data() as Map<String, dynamic>;

                      return Card(
                        color: AppColors.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['nombre'] ?? context.local.sinNombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "🌎 ${context.local.pais}: ${data['pais'] ?? context.local.noEspecificado}\n"
                                "🏞️ ${context.local.departamento}: ${data['departamento'] ?? context.local.noEspecificado}\n"
                                "🌍 ${context.local.ciudad}: ${data['ciudad'] ?? context.local.desconocida}\n"
                                "🌾 ${context.local.actividad}: ${data['actividad'] ?? context.local.noEspecificado}\n"
                                "📐 ${context.local.area}: ${data['area'] ?? context.local.noEspecificado} ha\n"
                                "📞 ${context.local.contacto}: ${data['contacto'] ?? context.local.noEspecificado}\n",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(context.local.ingresar),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ResponsiveNavBarPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // 🌿 Botón más arriba (~1 cm del borde)
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ), // más arriba del borde
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(context.local.registrarFinca),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FormFinca()),
                    ).then((_) => setState(() {}));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🌾 Estado cuando no hay fincas
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.landscape_rounded,
            size: 100,
            color: AppColors.primaryColor.withOpacity(0.6),
          ),
          const SizedBox(height: 20),
          Text(
            context.local.sinRegistro,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.local.primeraFinca,
            style: const TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

// 🎨 Colores
class AppColors {
  static const Color backgroundColor = Color(0xFFEAF4E1);
  static const Color appBarColor = Color(0xFF2B7A0B);
  static const Color primaryColor = Color(0xFF81B622);
  static const Color cardColor = Color(0xFFD9F8C4);
}
