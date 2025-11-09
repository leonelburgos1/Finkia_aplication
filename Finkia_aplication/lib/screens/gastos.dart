import 'package:flutter/foundation.dart';
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
              'assets/images/header2.png',
              fit: BoxFit.cover,
              height: 100,
            ),
          ),

          // 🔙 Botón de retroceso (opcional)
          Positioned(
            top: 25,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(2), // margen interno
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25), // fondo semitransparente
                border: Border.all(
                  color: Colors.white, // color del borde
                  width: 1, // grosor del borde
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 35, // tamaño del ícono
                ),
                onPressed: () => Navigator.pop(context),
                splashRadius: 28,
              ),
            ),
          ),


          // 🧾 Contenido principal
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 16, right: 16),
            child: Column(
              children: [
                const Text(
                  "Gastos",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33691E),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: categorias.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final item = categorias[index];
                      return _BotonCircular(
                        titulo: item["titulo"]!,
                        imagen: item["imagen"]!,
                        onTap: () {
                          // Aquí luego podrás navegar a otra página
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => OtraPagina()));
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

class _BotonCircular extends StatelessWidget {
  final String titulo;
  final String imagen;
  final VoidCallback onTap;

  const _BotonCircular({
    required this.titulo,
    required this.imagen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF7CB342),
                width: 3,
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(imagen, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF8BC34A),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
