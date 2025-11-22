import 'package:agrou_aplication/screens/form_finca.dart';
import 'package:agrou_aplication/screens/fincas.dart';
import 'package:agrou_aplication/screens/gastos.dart';
import 'package:agrou_aplication/screens/login.dart';
import 'package:agrou_aplication/screens/estadistica.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agrou_aplication/utils/localization_extension.dart';

// ======================= PALETA DE COLORES =======================

const Color darkBg = Color.fromARGB(255, 1, 34, 2);
const Color primaryDark = Color.fromARGB(255, 2, 78, 7);
const Color primaryLight = Color.fromARGB(210, 2, 78, 7);
const Color accentLight = Color.fromARGB(255, 235, 235, 235);

// ================================================================
//                       PÁGINA PRINCIPAL
// ================================================================
class ResponsiveNavBarPage extends StatefulWidget {
  final String fincaId;

  const ResponsiveNavBarPage({super.key, required this.fincaId});

  @override
  State<ResponsiveNavBarPage> createState() => _ResponsiveNavBarPageState();
}

class _ResponsiveNavBarPageState extends State<ResponsiveNavBarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;

  late List<String> _menuItems = [];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    _menuItems = [
      context.local.acercaDe,
      context.local.contacto,
      context.local.configuracion,
      context.local.salir,
    ];

    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    final List<Widget> _pages = [
      const HomeSection(),
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
              isDark
                  ? 'assets/images/header2.png'
                  : 'assets/images/gastos.png',
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
  //                           DRAWER
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
                    : [Color.fromARGB(255, 38, 95, 5), Color.fromARGB(255, 164, 231, 38)],
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
                      backgroundImage:
                          const AssetImage('assets/images/trabajador1.jpg'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Color.fromARGB(59, 255, 255, 255), thickness: 1),

                  // Ítems del menú
                  ...[
                    {'icon': Icons.info_outline, 'text': context.local.acercaDe},
                    {
                      'icon': Icons.contact_mail_outlined,
                      'text': context.local.contacto
                    },
                    {
                      'icon': Icons.settings_outlined,
                      'text': context.local.configuracion
                    },
                    {'icon': Icons.logout, 'text': context.local.salir},
                  ].map((item) {
                    return ListTile(
                      leading: Icon(item['icon'] as IconData, color: Colors.white),
                      title: Text(
                        item['text'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () async {
                        if (item['text'] == context.local.salir) {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                            (route) => false,
                          );
                        } else {
                          _scaffoldKey.currentState?.openEndDrawer();
                        }
                      },
                    );
                  }).toList(),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
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
//                       HOME SECTION
// ================================================================
class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? darkBg : Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: Image.asset(
                isDark
                    ? 'assets/images/Finkia_Transparente.png'
                    : 'assets/images/Finkia_Transparente.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
//                    CUSTOM BOTTOM NAV BAR
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
                painter:
                    BNBCustomPainter(position: position, isDarkMode: isDarkMode),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavIcon(Icons.home, 0, isDarkMode),
                    _buildNavIcon(Icons.bar_chart_rounded, 1, isDarkMode),
                    _buildNavIcon(Icons.add_circle_outline, 2, isDarkMode),
                    _buildNavIcon(Icons.notifications, 3, isDarkMode),
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
        transform:
            Matrix4.translationValues(0, isSelected ? -20 : -5, 0),
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                    color: isDarkMode
                    ? const Color.fromARGB(255, 32, 138, 23):
                      const Color.fromARGB(255, 164, 231, 38),
                  shape: BoxShape.circle,
                  border: Border.all(
                  color: isDarkMode
                    ? const Color.fromARGB(255, 6, 167, 33).withOpacity(0.3):
                      const Color.fromARGB(255, 38, 95, 5).withOpacity(0.3),
                    width: 2,
                  ),
                )
              : null,
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color:
                isSelected ? Colors.white : (isDarkMode ? Colors.white : primaryDark),
            size: isSelected ? 35 : 28,
          ),
        ),
      ),
    );
  }
}

// ================================================================
//                      PINTOR NAV BAR
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
      ..color = isDarkMode ? Color.fromARGB(210, 2, 78, 7) : Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
