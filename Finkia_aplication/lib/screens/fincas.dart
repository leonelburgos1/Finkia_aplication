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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color.fromARGB(192, 2, 20, 3) : Colors.white,
      body: Stack(
        children: [
          // -----------------------------------
          //      IMAGEN HEADER (dark/light)
          // -----------------------------------
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Image.asset(
              isDark
                  ? 'assets/images/misfincas_dark.png'
                  : 'assets/images/misFincas.jpg',
              height: 130,
              fit: BoxFit.cover,
            ),
          ),

          // -----------------------------------
          //       BOTÓN ATRÁS REDONDO
          // -----------------------------------
          Positioned(
            top: 30,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // -----------------------------------
          //     CONTENIDO PRINCIPAL (LISTA)
          // -----------------------------------
          Padding(
            padding: const EdgeInsets.only(top: 140, left: 18, right: 18),
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
                        return _buildEmptyState(isDark);
                      }

                      final fincas = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: fincas.length,
                        itemBuilder: (context, index) {
                          final data =
                              fincas[index].data() as Map<String, dynamic>;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color.fromARGB(157, 3, 34, 5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                if (!isDark)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // NOMBRE
                                  Text(
                                    data['nombre'] ?? context.local.sinNombre,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF2E7D32),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // INFO
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _infoItem(
                                          isDark,
                                          Icons.public,
                                          "${context.local.pais}: ${data['pais'] ?? context.local.noEspecificado}"),
                                      _infoItem(
                                          isDark,
                                          Icons.map,
                                          "${context.local.departamento}: ${data['departamento'] ?? context.local.noEspecificado}"),
                                      _infoItem(
                                          isDark,
                                          Icons.location_city,
                                          "${context.local.ciudad}: ${data['ciudad'] ?? context.local.noEspecificado}"),
                                      _infoItem(
                                          isDark,
                                          Icons.agriculture,
                                          "${context.local.actividad}: ${data['actividad'] ?? context.local.noEspecificado}"),
                                      _infoItem(
                                          isDark,
                                          Icons.straighten,
                                          "${context.local.area}: ${data['area']} ha"),
                                      _infoItem(
                                          isDark,
                                          Icons.phone,
                                          "${context.local.contacto}: ${data['contacto']}"),
                                    ],
                                  ),

                                  const SizedBox(height: 15),

                                  // BOTÓN INGRESAR
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isDark
                                              ? [
                                                  const Color.fromARGB(
                                                      210, 2, 78, 7),
                                                  const Color.fromARGB(
                                                      255, 1, 34, 2),
                                                ]
                                              : [
                                                  const Color.fromARGB(
                                                      255, 164, 231, 38),
                                                  const Color(0xFF2E7D32),
                                                ],
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        border:
                                            Border.all(color: Color.fromARGB(255, 2, 19, 0)),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
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

                const SizedBox(height: 20),

                // BOTÓN DE REGISTRAR FINCA
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color.fromARGB(210, 2, 78, 7),
                              const Color.fromARGB(255, 1, 34, 2),
                            ]
                          : [
                              const Color.fromARGB(255, 164, 231, 38),
                              const Color(0xFF2E7D32),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color.fromARGB(255, 2, 19, 0)),
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
                        borderRadius: BorderRadius.circular(15),
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

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------
  //    EMPTY STATE
  // -------------------------
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.landscape_rounded,
            size: 100,
            color: (isDark ? Colors.white : const Color(0xFF2E7D32))
                .withOpacity(0.6),
          ),
          const SizedBox(height: 20),
          Text(
            context.local.sinRegistro,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.local.primeraFinca,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // INFO ITEM
  // -------------------------
  Widget _infoItem(bool isDark, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark
                ? Colors.white
                : const Color.fromARGB(196, 46, 125, 50),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white70 : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
