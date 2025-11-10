import 'package:flutter/material.dart';

class GastosPage extends StatelessWidget {
  const GastosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categorias = [
      {"titulo": "Alimentación", "imagen": "assets/images/comida.jpg"},
      {"titulo": "Trabajadores", "imagen": "assets/images/trabajador1.jpg"},
      {"titulo": "Insumos Agrícolas", "imagen": "assets/images/abono.png"},
      {"titulo": "Transporte", "imagen": "assets/images/carro.jpg"},
      {"titulo": "Herramientas", "imagen": "assets/images/maquina.png"},
      {"titulo": "Siembra y cultivo", "imagen": "assets/images/cultivo.jpg"},
      {"titulo": "Proceso de café", "imagen": "assets/images/cultivo.jpg"},
      {"titulo": "Gastos Hogar", "imagen": "assets/images/luz.jpg"},
      {"titulo": "Otros Gastos", "imagen": "assets/images/otros_gastos.jpg"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // 🖼️ Imagen del header
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

          // 🔙 Botón de retroceso mejorado
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
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 🧾 Contenido principal
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
            child: Column(
              children: [

                // 🔲 Cuadrícula de categorías
                Expanded(
                  child: GridView.builder(
                    itemCount: categorias.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 60,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final item = categorias[index];
                      return _BotonCategoria(
                        titulo: item["titulo"]!,
                        imagen: item["imagen"]!,
                        onTap: () {},
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

// 🌿 Botón de categoría con estilo moderno e inclinación en el texto
class _BotonCategoria extends StatelessWidget {
  final String titulo;
  final String imagen;
  final VoidCallback onTap;

  const _BotonCategoria({
    required this.titulo,
    required this.imagen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🟢 Círculo con efecto 3D
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 2,
                top: 2,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9CCC65),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipOval(
                    child: Image.asset(
                      imagen,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

            // 🔰 Etiqueta con inclinación y efecto 3D realista (capa superior desplazada)
            Stack(
              clipBehavior: Clip.none,
              children: [
                // 🟩 Capa base (inferior, más oscura)
                ClipPath(
                  clipper: _EtiquetaClipper(),
                  child: Container(
                    
                    width: 190,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 38, 95, 5), // verde oscuro
                    ),
                  ),
                ),

                // 🟢 Capa superior (ligeramente desplazada y translúcida)
                Positioned(
                  top: 4, // se eleva un poco para dar efecto de relieve
                  left: -6, // leve inclinación hacia la izquierda
                  child: ClipPath(
                    clipper: _EtiquetaClipper(),
                    child: Container(
                      width: 170,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 164, 231, 38).withOpacity(0.9), // verde claro translúcido
                            const Color(0xFF2E7D32).withOpacity(0.9), // verde medio translúcido
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          letterSpacing: 0.3,
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
    path.moveTo(20, 0); // esquina superior izquierda (más inclinación)
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


