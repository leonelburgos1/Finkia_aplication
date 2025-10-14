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
        backgroundColor: const Color.fromARGB(255, 118, 235, 15), // 💚 Color de fondo
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

        // 💡 Aquí cambiamos el "Body" por una imagen de fondo
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF4E1), // color base si la imagen no carga
            image: DecorationImage(
              image: AssetImage('assets/images/logo_splash.jpg'),
              fit: BoxFit.contain, // mantiene proporción sin deformar
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }

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
      onSelected: (Menu item) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(value: Menu.itemOne, child: Text('Cuenta')),
        const PopupMenuItem<Menu>(value: Menu.itemTwo, child: Text('Configuración')),
        const PopupMenuItem<Menu>(
          value: Menu.itemThree,
          child: Text('Salir'),
        ),
      ],
    );
  }
}
