import 'package:agrou_aplication/screens/transporte.dart';
import 'package:flutter/material.dart';
import 'package:agrou_aplication/screens/comida.dart';
import 'package:agrou_aplication/screens/trabajadores.dart'; // <-- Import nuevo
import 'package:agrou_aplication/screens/insumos.dart';

class GastosPage extends StatelessWidget {
  final String fincaId;

  const GastosPage({super.key, required this.fincaId});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categorias = [
      {"titulo": "Alimentación", "imagen": "assets/images/comida.jpg"},
      {"titulo": "Trabajadores", "imagen": "assets/images/trabajador1.jpg"},
      {"titulo": "Insumos", "imagen": "assets/images/abono.png"},
      {"titulo": "Transporte", "imagen": "assets/images/carro.jpg"},
      {"titulo": "Herramientas", "imagen": "assets/images/maquina.png"},
      {"titulo": "Siembra y cultivo", "imagen": "assets/images/cultivo.jpg"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/gastos.png',
              fit: BoxFit.cover,
              height: 100,
            ),
          ),

          // BOTÓN ATRÁS
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
                    offset: const Offset(2, 2),
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

          // CONTENIDO
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const int crossAxisCount = 2;
                      const double crossAxisSpacing = 20;
                      const double mainAxisSpacing = 24;

                      final double totalSpacing =
                          crossAxisSpacing * (crossAxisCount - 1);
                      final double itemWidth =
                          (constraints.maxWidth - totalSpacing) /
                          crossAxisCount;

                      final double targetItemHeight = itemWidth * 1.15;
                      final double childAspectRatio =
                          itemWidth / targetItemHeight;

                      return GridView.builder(
                        itemCount: categorias.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: mainAxisSpacing,
                          crossAxisSpacing: crossAxisSpacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          final item = categorias[index];

                          return _BotonCategoria(
                            titulo: item["titulo"]!,
                            imagen: item["imagen"]!,
                            itemWidth: itemWidth,
                            onTap: () {
                              // *******************************
                              //   RUTAS POR CATEGORÍA
                              // *******************************
                              switch (item["titulo"]) {
                                case "Alimentación":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ComidaPage(fincaId: fincaId),
                                    ),
                                  );
                                  break;

                                case "Trabajadores":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TrabajadoresPage(fincaId: fincaId),
                                    ),
                                  );
                                  break;

                                case "Insumos":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => InsumosAgricolasPage(
                                        fincaId: fincaId,
                                      ),
                                    ),
                                  );
                                  break;

                                case "Transporte":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TransportePage(fincaId: fincaId),
                                    ),
                                  );
                                  break;

                                case "Herramientas":
                                  // Navigator.push(context,
                                  // MaterialPageRoute(builder: (_) =>
                                  // HerramientasPage(fincaId: fincaId)));
                                  break;

                                case "Siembra y cultivo":
                                  // Navigator.push(context,
                                  // MaterialPageRoute(builder: (_) =>
                                  // SiembraCultivoPage(fincaId: fincaId)));
                                  break;
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
//   WIDGET DE BOTÓN DE CATEGORÍA
// ---------------------------------------------------------------
class _BotonCategoria extends StatelessWidget {
  final String titulo;
  final String imagen;
  final VoidCallback onTap;
  final double itemWidth;

  const _BotonCategoria({
    required this.titulo,
    required this.imagen,
    required this.onTap,
    required this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    final double circleSize = itemWidth * 0.7;
    final double shadowOffset = circleSize * 0.03;
    final double labelWidth = itemWidth * 0.9;
    const double labelHeight = 40.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: shadowOffset,
                top: shadowOffset,
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9CCC65),
                    borderRadius: BorderRadius.circular(circleSize / 2),
                  ),
                ),
              ),
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(circleSize / 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: Offset(shadowOffset, shadowOffset),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(circleSize * 0.03),
                  child: ClipOval(
                    child: Image.asset(
                      imagen,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => Icon(
                        Icons.image_not_supported,
                        size: circleSize * 0.35,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Etiqueta
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: _EtiquetaClipper(),
                child: Container(
                  width: labelWidth,
                  height: labelHeight,
                  color: const Color.fromARGB(255, 38, 95, 5),
                ),
              ),
              Positioned(
                top: 4,
                left: -6,
                child: ClipPath(
                  clipper: _EtiquetaClipper(),
                  child: Container(
                    width: labelWidth * 0.9,
                    height: labelHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 164, 231, 38),
                          const Color(0xFF2E7D32),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 2,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EtiquetaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final slant = size.height * 0.5;

    path.moveTo(slant, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - slant * 0.4, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_) => false;
}
