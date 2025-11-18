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
        body: Stack(
          children: [
            // -------------------------------
            //    HEADER CON IMAGEN (NUEVO)
            // -------------------------------
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/misFincas.jpg',   // <-- CAMBIA LA IMAGEN SI QUIERES
                height: 120,
                fit: BoxFit.cover,
              ),
            ),

            // -------------------------------
            //       BOTÓN ATRÁS (NUEVO)
            // -------------------------------
            Positioned(
              top: 25,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.25),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // -----------------------------------------
            //   CONTENIDO REAL DE LA PÁGINA (LISTA)
            // -----------------------------------------
            Padding(
              padding: const EdgeInsets.only(top: 110, left: 16, right: 16),
              child: Column(
                children: [
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
                                        fontWeight: FontWeight.w900,
                                        fontSize: 25,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _infoItem(Icons.public, "${context.local.pais}: ${data['pais'] ?? context.local.noEspecificado}"),
                                          _infoItem(Icons.map, "${context.local.departamento}: ${data['departamento'] ?? context.local.noEspecificado}"),
                                          _infoItem(Icons.location_city, "${context.local.ciudad}: ${data['ciudad'] ?? context.local.desconocida}"),
                                          _infoItem(Icons.agriculture, "${context.local.actividad}: ${data['actividad'] ?? context.local.noEspecificado}"),
                                          _infoItem(Icons.straighten, "${context.local.area}: ${data['area'] ?? context.local.noEspecificado} ha"),
                                          _infoItem(Icons.phone, "${context.local.contacto}: ${data['contacto'] ?? context.local.noEspecificado}"),
                                        ],
                                      ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 164, 231, 38),
                                              Color(0xFF2E7D32),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ResponsiveNavBarPage(
                                                  fincaId: fincas[index].id,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            context.local.ingresar,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
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

                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 164, 231, 38),
                              Color(0xFF2E7D32),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add, color: Colors.white, size: 25),
                          label: Text(
                            context.local.registrarFinca,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
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
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      );
    }


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
    Widget _infoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color.fromARGB(196, 46, 125, 50),  // íconos minimalistas
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class AppColors {
  static const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color primaryColor = Color.fromARGB(255, 73, 95, 33);
  static const Color cardColor = Color.fromARGB(255, 255, 255, 255);
}
