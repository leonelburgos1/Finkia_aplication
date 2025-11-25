// responsive_navbar_page.dart
import 'package:agrou_aplication/screens/asesorIA.dart';
import 'package:agrou_aplication/screens/form_finca.dart';
import 'package:agrou_aplication/screens/fincas.dart';
import 'package:agrou_aplication/screens/gastos.dart';
import 'package:agrou_aplication/screens/login.dart';
import 'package:agrou_aplication/screens/estadistica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agrou_aplication/utils/localization_extension.dart';
import 'package:agrou_aplication/screens/acercaDe.dart';

// ======================= PALETA DE COLORES =======================
const Color darkBg = Color.fromARGB(255, 1, 34, 2);
const Color primaryDark = Color.fromARGB(255, 2, 78, 7);
const Color primaryLight = Color.fromARGB(210, 2, 78, 7);
const Color accentLight = Color.fromARGB(255, 235, 235, 235);
// ==============================================================

class ResponsiveNavBarPage extends StatefulWidget {
  final String fincaId;

  const ResponsiveNavBarPage({super.key, required this.fincaId});

  @override
  State<ResponsiveNavBarPage> createState() => _ResponsiveNavBarPageState();
}

class _ResponsiveNavBarPageState extends State<ResponsiveNavBarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;

  // Nuevo Future para cargar el nombre de la finca
  late Future<String> _fincaNameFuture;

  @override
  void initState() {
    super.initState();
    // Inicializa la carga del nombre de la finca al iniciar el widget
    _fincaNameFuture = _loadFincaName(widget.fincaId);
  }

  // Método para obtener el nombre de la finca de Firestore
  Future<String> _loadFincaName(String fincaId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('fincas')
          .doc(fincaId)
          .get();

      if (docSnapshot.exists) {
        // Asegúrate de que 'nombre' es la clave correcta en tu documento
        return docSnapshot.data()?['nombre'] as String? ?? 'Finca Desconocida';
      }
      return 'Finca No Encontrada';
    } catch (e) {
      // En caso de error de conexión o de Firestore
      print('Error al cargar el nombre de la finca: $e');
      return 'Error de Carga';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> _pages = [
      HomeSection(fincaId: widget.fincaId),
      const FincasPage(),
      const FormFinca(),
      Center(
        child: Text(
          context.local.notificaciones,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 100,
      drawer: _drawer(isDark),
      body: Stack(
        children: [
          // ================= HEADER DINÁMICO =================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              isDark ? 'assets/images/header2.png' : 'assets/images/header.png',
              fit: BoxFit.cover,
              height: 100,
            ),
          ),

          // ================== BOTÓN MENÚ =====================
          Positioned(
            top: 25,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 32),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                splashRadius: 28,
              ),
            ),
          ),

          // =================== CONTENIDO ======================
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _pages[selectedIndex],
            ),
          ),

          // ============= BOTTOM NAV BAR ======================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(
              selectedIndex: selectedIndex,
              onItemTapped: (index) {
                if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GastosPage(fincaId: widget.fincaId),
                    ),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EstadisticaPage(fincaId: widget.fincaId),
                    ),
                  );
                } else if (index == 3) {
                  // ===> LÓGICA PARA EL ASESOR IA (Reemplaza Notificaciones) <===
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AsesorAgricolaPage(),
                    ),
                  );
                } else {
                  setState(() => selectedIndex = index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  //                          DRAWER CON NOMBRE DE FINCA
  // ================================================================
  Widget _drawer(bool isDark) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: -250.0, end: 0.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: Container(
            width: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [primaryDark, darkBg]
                    : [
                        const Color.fromARGB(255, 38, 95, 5),
                        const Color.fromARGB(255, 164, 231, 38),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      backgroundImage: const AssetImage(
                        'assets/images/trabajador1.jpg',
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // =================== NOMBRE DE LA FINCA ===================
                  Center(
                    child: FutureBuilder<String>(
                      future: _fincaNameFuture,
                      builder: (context, snapshot) {
                        String name = 'Cargando...';
                        if (snapshot.hasData) {
                          name = snapshot.data!;
                        } else if (snapshot.hasError) {
                          name = 'Error';
                        }
                        return Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),

                  // ==========================================================
                  const SizedBox(height: 15),
                  const Divider(
                    color: Color.fromARGB(59, 255, 255, 255),
                    thickness: 1,
                  ),

                  // Ítems del menú
                  ...[
                    {
                      'icon': Icons.info_outline,
                      'text': context.local.acercaDe,
                      'action': 'acerca',
                    },
                    {
                      'icon': Icons.swap_horiz,
                      'text': context.local.cambiar_finca,
                      'action': 'cambiar',
                    },
                    {
                      'icon': Icons.logout,
                      'text': context.local.salir,
                      'action': 'salir',
                    },
                  ].map((item) {
                    final String action = item['action'] as String;
                    return ListTile(
                      leading: Icon(
                        item['icon'] as IconData,
                        color: Colors.white,
                      ),
                      title: Text(
                        item['text'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context); // Cerrar el drawer primero

                        if (action == 'salir') {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                            (route) => false,
                          );
                        } else if (action == 'cambiar') {
                          // Opción de Cambiar de finca -> Redirige a FincasPage
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FincasPage(),
                            ),
                            (route) =>
                                false, // Elimina todas las rutas anteriores
                          );
                        } else if (action == 'acerca') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AcercaDePage(), // Reemplaza AboutPage() con tu clase
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        0,
                        0,
                        0,
                      ).withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '© 2025 Finkia',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ================================================================
//                       HOME SECTION (CON 5 GASTOS SEPARADOS)
// ================================================================
class HomeSection extends StatelessWidget {
  final String fincaId;
  const HomeSection({super.key, required this.fincaId});

  // Método helper para formatear a moneda
  String _formatCurrency(double v) {
    if (v == 0) return '\$0';
    if (v.abs() >= 1000000)
      return '\$' + (v / 1000000).toStringAsFixed(1) + 'M';
    if (v.abs() >= 1000) return '\$' + (v / 1000).toStringAsFixed(1) + 'K';
    return '\$' + v.toStringAsFixed(0);
  }

  // pequeña tarjeta usada dentro del grid
  Widget _smallCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 243, 243),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final gastosStream = FirebaseFirestore.instance
        .collection('fincas')
        .doc(fincaId)
        .collection('gastos')
        .snapshots();

    return Container(
      color: isDark ? darkBg : Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 30),
          const SizedBox(height: 20),

          // Tarjeta "Gastos generales" con Grid de 3 columnas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: gastosStream,
              builder: (context, snapshot) {
                // valores por defecto
                double totalGeneral = 0.0;
                final Map<String, double> totalPorTipo = {
                  context.local.comida: 0.0,
                  context.local.trabajadores: 0.0,
                  context.local.insumos: 0.0,
                  context.local.transporte: 0.0,
                  context.local.otros: 0.0,
                };

                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  for (var d in docs) {
                    final data = d.data();
                    final tipo =
                        (data['tipo'] as String?)?.toLowerCase() ?? 'otros';
                    double valorDoc = 0.0;

                    if (data.containsKey('total')) {
                      valorDoc = (data['total'] is num)
                          ? (data['total'] as num).toDouble()
                          : double.tryParse('${data['total']}') ?? 0.0;
                    } else if (data.containsKey('precio')) {
                      valorDoc = (data['precio'] is num)
                          ? (data['precio'] as num).toDouble()
                          : double.tryParse('${data['precio']}') ?? 0.0;
                    } else if (data.containsKey('valorPorBulto')) {
                      final cant = (data['cantidadBultos'] is num)
                          ? (data['cantidadBultos'] as num).toDouble()
                          : double.tryParse('${data['cantidadBultos'] ?? 0}') ??
                                0.0;
                      final val = (data['valorPorBulto'] is num)
                          ? (data['valorPorBulto'] as num).toDouble()
                          : double.tryParse('${data['valorPorBulto'] ?? 0}') ??
                                0.0;
                      valorDoc = cant * val;
                    } else if (data.containsKey('precioPorLitro') &&
                        data.containsKey('litros')) {
                      final litros = (data['litros'] is num)
                          ? (data['litros'] as num).toDouble()
                          : double.tryParse('${data['litros'] ?? 0}') ?? 0.0;
                      final precioL = (data['precioPorLitro'] is num)
                          ? (data['precioPorLitro'] as num).toDouble()
                          : double.tryParse('${data['precioPorLitro'] ?? 0}') ??
                                0.0;
                      valorDoc =
                          litros * precioL +
                          ((data['otrosGastos'] is num)
                              ? (data['otrosGastos'] as num).toDouble()
                              : double.tryParse(
                                      '${data['otrosGastos'] ?? 0}',
                                    ) ??
                                    0.0);
                    } else if (data.containsKey('valorUnidad') &&
                        data.containsKey('cantidadTrabajadores')) {
                      final cantidadTrab = (data['cantidadTrabajadores'] is num)
                          ? (data['cantidadTrabajadores'] as num).toDouble()
                          : double.tryParse(
                                  '${data['cantidadTrabajadores'] ?? 0}',
                                ) ??
                                0.0;
                      final cantidad = (data['cantidad'] is num)
                          ? (data['cantidad'] as num).toDouble()
                          : double.tryParse('${data['cantidad'] ?? 0}') ?? 0.0;
                      final valorUnidad = (data['valorUnidad'] is num)
                          ? (data['valorUnidad'] as num).toDouble()
                          : double.tryParse('${data['valorUnidad'] ?? 0}') ??
                                0.0;
                      valorDoc = cantidadTrab * cantidad * valorUnidad;
                    } else {
                      if (data.containsKey('valorUnidad')) {
                        valorDoc = (data['valorUnidad'] is num)
                            ? (data['valorUnidad'] as num).toDouble()
                            : double.tryParse('${data['valorUnidad']}') ?? 0.0;
                      } else {
                        valorDoc = 0.0;
                      }
                    }

                    totalGeneral += valorDoc;
                    if (totalPorTipo.containsKey(tipo)) {
                      totalPorTipo[tipo] = (totalPorTipo[tipo] ?? 0) + valorDoc;
                    } else {
                      totalPorTipo['otros'] =
                          (totalPorTipo['otros'] ?? 0) + valorDoc;
                    }
                  }
                }

                // Lista de todos los widgets de las tarjetas de gasto
                final List<Widget> expenseCards = [
                  _smallCard(
                    context.local.total_general,
                    _formatCurrency(totalGeneral),
                    Colors.black87,
                  ),
                  _smallCard(
                    context.local.comida,
                    _formatCurrency(totalPorTipo[context.local.comida] ?? 0),
                    const Color(0xFF2E7D32),
                  ),
                  _smallCard(
                    context.local.trabajadores,
                    _formatCurrency(
                      totalPorTipo[context.local.trabajadores] ?? 0,
                    ),
                    const Color(0xFFA4E726),
                  ),
                  _smallCard(
                    context.local.insumos,
                    _formatCurrency(totalPorTipo[context.local.insumos] ?? 0),
                    Colors.orange,
                  ),
                  _smallCard(
                    context.local.transporte,
                    _formatCurrency(
                      totalPorTipo[context.local.transporte] ?? 0,
                    ),
                    Colors.deepOrange,
                  ),
                ];

                // tarjeta que contiene el grid
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(
                      color: const Color.fromARGB(
                        255,
                        0,
                        0,
                        0,
                      ).withOpacity(0.06),
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          context.local.gastos_generales,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Usamos GridView con 3 columnas
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: expenseCards.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                        itemBuilder: (context, index) {
                          return expenseCards[index];
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // espacio y resto del Home
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }
}

// ================================================================
//                    CUSTOM BOTTOM NAV BAR
// ================================================================
class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    double sectionWidth = size.width / 4;

    final List<double> positions = [
      (sectionWidth * 0.67) / size.width,
      (sectionWidth * 1.54) / size.width,
      (sectionWidth * 2.44) / size.width,
      (sectionWidth * 3.32) / size.width,
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: positions[widget.selectedIndex],
        end: positions[widget.selectedIndex],
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, position, _) {
        return SizedBox(
          width: size.width,
          height: 90,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: Size(size.width, 90),
                painter: BNBCustomPainter(
                  position: position,
                  isDarkMode: isDarkMode,
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavIcon(Icons.home, 0, isDarkMode),
                    _buildNavIcon(Icons.bar_chart_rounded, 1, isDarkMode),
                    _buildNavIcon(Icons.add_circle_outline, 2, isDarkMode),
                    _buildNavIcon(Icons.auto_awesome, 3, isDarkMode),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavIcon(IconData icon, int index, bool isDarkMode) {
    final isSelected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () => widget.onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(0, isSelected ? -20 : -5, 0),
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  color: isDarkMode
                      ? const Color.fromARGB(255, 32, 138, 23)
                      : const Color.fromARGB(255, 164, 231, 38),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode
                        ? const Color.fromARGB(255, 6, 167, 33).withOpacity(0.3)
                        : const Color.fromARGB(255, 38, 95, 5).withOpacity(0.3),
                    width: 2,
                  ),
                )
              : null,
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: isSelected
                ? Colors.white
                : (isDarkMode ? Colors.white : primaryDark),
            size: isSelected ? 35 : 28,
          ),
        ),
      ),
    );
  }
}

// ================================================================
//                      PINTOR NAV BAR
// ================================================================
class BNBCustomPainter extends CustomPainter {
  final double position;
  final bool isDarkMode;

  BNBCustomPainter({required this.position, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width * position;
    final double height = 18;

    final path = Path()..moveTo(0, height);

    path.lineTo(centerX - 35, height);
    path.quadraticBezierTo(centerX - 20, height + 25, centerX, height + 25);
    path.quadraticBezierTo(centerX + 20, height + 25, centerX + 35, height);
    path.lineTo(size.width, height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final shadowPaint = Paint()
      ..color = const Color.fromARGB(155, 1, 121, 27).withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.save();
    canvas.translate(0, -4);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    final paint = Paint()
      ..color = isDarkMode ? const Color.fromARGB(210, 2, 78, 7) : Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
