import 'package:agrou_aplication/screens/form_finca.dart';
import 'package:agrou_aplication/screens/fincas.dart';
import 'package:agrou_aplication/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ------------------ PÁGINA PRINCIPAL ------------------
class ResponsiveNavBarPage extends StatefulWidget {
  const ResponsiveNavBarPage({super.key});

  @override
  State<ResponsiveNavBarPage> createState() => _ResponsiveNavBarPageState();
}

class _ResponsiveNavBarPageState extends State<ResponsiveNavBarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  // Páginas a mostrar según el botón del BottomNavBar
  final List<Widget> _pages = const [
    HomeSection(),
    FincasPage(),
    FormFinca(),
    Center(child: Text("🔔 Notificaciones", style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,

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
              Image.asset('assets/images/Finkia_Transparente.png', height: 40),
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
          // Contenido principal que cambia según el ícono
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _pages[selectedIndex],
          ),

          // BottomNav personalizado
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(
              selectedIndex: selectedIndex,
              onItemTapped: (index) {
                setState(() => selectedIndex = index);
              },
            ),
          ),
        ],
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

// ------------------ PERFIL Y CIERRE DE SESIÓN ------------------
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

// ------------------ SECCIÓN PRINCIPAL (HOME) ------------------
class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
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
                label: const Text('Agregar Finca',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B7A0B),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
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
                label: const Text('Mis Fincas',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF81B622),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
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
    );
  }
}

// ------------------ CUSTOM BOTTOM NAV BAR ------------------
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
                    _buildNavIcon(Icons.eco, 1, isDarkMode),
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
        transform: Matrix4.translationValues(0, isSelected ? -20 : -5, 0),
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  color: const Color(0xFF81B622),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.3),
                    width: 2,
                  ),
                )
              : null,
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: isSelected
                ? Colors.white
                : (isDarkMode ? Colors.white70 : Colors.black87),
            size: isSelected ? 35 : 28,
          ),
        ),
      ),
    );
  }
}

// ------------------ PINTOR RECTO CON HUECO ------------------
class BNBCustomPainter extends CustomPainter {
  final double position;
  final bool isDarkMode;

  BNBCustomPainter({required this.position, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width * position;
    final double height = 18;

    final path = Path()..moveTo(0, height);

    // Línea recta hasta el hueco
    path.lineTo(centerX - 35, height);

    // Curva hacia abajo (hueco)
    path.quadraticBezierTo(centerX - 20, height + 25, centerX, height + 25);
    path.quadraticBezierTo(centerX + 20, height + 25, centerX + 35, height);

    // Línea hasta el final
    path.lineTo(size.width, height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // 🌑 Sombra superior
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.save();
    canvas.translate(0, -4);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // 🎨 Color de la barra (según modo)
    final paint = Paint()
      ..color = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
