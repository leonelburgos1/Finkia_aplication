import 'package:agrou_aplication/screens/form_finca.dart';
import 'package:agrou_aplication/screens/fincas.dart'; // 👈 Nueva importación
import 'package:agrou_aplication/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
class ResponsiveNavBarPage extends StatelessWidget {
  ResponsiveNavBarPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color.fromARGB(255, 118, 235, 15),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 163, 228, 138),
          elevation: 0,
          titleSpacing: 0,
          leading: isLargeScreen
              ? null
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Finkia_Transparente.png',
                  height: 40,
                ),
                if (isLargeScreen) Expanded(child: _navBarItems()),
              ],
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: _ProfileIcon()),
            ),
          ],
        ),
        drawer: isLargeScreen ? null : _drawer(),

        // ------------------ CUERPO + BOTTOM NAV ------------------
        body: Stack(
          children: [
            // Contenido principal
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFEAF4E1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  // FILA CON DOS BOTONES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FormFinca()),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Agregar Finca',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B7A0B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FincasPage()),
                          );
                        },
                        icon: const Icon(Icons.list_alt),
                        label: const Text(
                          'Mis Fincas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF81B622),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Imagen central
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/Finkia_Transparente.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ------------------ BOTTOM NAV CUSTOM ------------------
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ MENÚ LATERAL ------------------
  Widget _drawer() => Drawer(
        child: ListView(
          children: _menuItems
              .map(
                (item) => ListTile(
                  onTap: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                  title: Text(item),
                ),
              )
              .toList(),
        ),
      );

  // ------------------ NAVBAR SUPERIOR ------------------
  Widget _navBarItems() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _menuItems
            .map(
              (item) => InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16,
                  ),
                  child: Text(item, style: const TextStyle(fontSize: 18)),
                ),
              ),
            )
            .toList(),
      );
}

final List<String> _menuItems = <String>[
  'Acerca de',
  'Contacto',
  'Configuración',
  'Salir',
];

enum Menu { itemOne, itemTwo, itemThree }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.person),
      offset: const Offset(0, 40),
      onSelected: (Menu item) async {
        switch (item) {
          case Menu.itemOne:
            break;
          case Menu.itemTwo:
            break;
          case Menu.itemThree:
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Login()),
              (route) => false,
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(value: Menu.itemOne, child: Text('Cuenta')),
        const PopupMenuItem<Menu>(
          value: Menu.itemTwo,
          child: Text('Configuración'),
        ),
        const PopupMenuItem<Menu>(value: Menu.itemThree, child: Text('Salir')),
      ],
    );
  }
}

// ------------------ CUSTOM BOTTOM NAV BAR ------------------


class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double sectionWidth = size.width / 4;

    // posiciones dinámicas centradas
    final List<double> positions = [
      (sectionWidth * 0.67) / size.width,
      (sectionWidth * 1.54) / size.width,
      (sectionWidth * 2.44) / size.width,
      (sectionWidth * 3.32) / size.width,
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: positions[selectedIndex],
        end: positions[selectedIndex],
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
              // Fondo con la curvatura dinámica
              CustomPaint(
                size: Size(size.width, 90),
                painter: BNBCustomPainter(position: position),
              ),

              // Íconos
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavIcon(Icons.home, 0),
                    _buildNavIcon(Icons.restaurant_menu, 1),
                    _buildNavIcon(Icons.bookmark, 2),
                    _buildNavIcon(Icons.notifications, 3),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
  final isSelected = selectedIndex == index;
  return GestureDetector(
    onTap: () => setState(() => selectedIndex = index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      transform: Matrix4.translationValues(0, isSelected ? -15 : 0, 0),
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              )
            : null,
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected
              ? const Color(0xFFFFC50F)
              : Colors.black.withOpacity(0.7),
          size: isSelected ? 34 : 28,
        ),
      ),
    ),
  );
}

}

class BNBCustomPainter extends CustomPainter {
  final double position; // valor de 0.0 a 1.0

  BNBCustomPainter({required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double centerX = size.width * position;

    final path = Path()..moveTo(0, 20);

    // curva antes del hueco
    path.quadraticBezierTo(centerX - 80, 0, centerX - 20, 6);

    // entrada al hueco
    path.quadraticBezierTo(centerX - 35, 25, centerX - 30, 38);

    // hueco más profundo (efecto flotante)
    path.arcToPoint(
      Offset(centerX + 30, 20),
      radius: const Radius.circular(1),
      clockwise: false,
    );

    // salida del hueco
    path.quadraticBezierTo(centerX + 25, 0, centerX + 25, 0);
    path.quadraticBezierTo(centerX + 55, 0, size.width, 20);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.2), 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BNBCustomPainter oldDelegate) {
    return oldDelegate.position != position;
  }
}


