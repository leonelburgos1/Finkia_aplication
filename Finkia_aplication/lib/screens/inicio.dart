import 'package:agrou_aplication/screens/form_finca.dart';
import 'package:agrou_aplication/screens/fincas.dart'; // 👈 Nueva importación
import 'package:agrou_aplication/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

        // ------------------ CUERPO ------------------
        body: Container(
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
                    'assets/images/logo_splash.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
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
