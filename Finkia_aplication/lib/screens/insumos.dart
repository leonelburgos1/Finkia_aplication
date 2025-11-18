import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsumosAgricolasPage extends StatefulWidget {
  final String fincaId;

  const InsumosAgricolasPage({super.key, required this.fincaId});

  @override
  State<InsumosAgricolasPage> createState() => _InsumosAgricolasPageState();
}

class _InsumosAgricolasPageState extends State<InsumosAgricolasPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreInsumoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  String _unidad = "kg";

  @override
  void dispose() {
    _nombreInsumoController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarInsumo() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'tipo': 'insumo',
      'nombreInsumo': _nombreInsumoController.text.trim(),
      'cantidad':
          double.tryParse(_cantidadController.text.replaceAll(',', '.')) ?? 0,
      'unidad': _unidad,
      'precio':
          double.tryParse(_precioController.text.replaceAll(',', '.')) ?? 0,
      'descripcion': _descripcionController.text.trim(),
      'fecha': Timestamp.now(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('fincas')
          .doc(widget.fincaId)
          .collection('gastos')
          .add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insumo guardado correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      _nombreInsumoController.clear();
      _cantidadController.clear();
      _precioController.clear();
      _descripcionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = (screenHeight * 0.22).clamp(120.0, 260.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Imagen de header
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

          // Botón de regreso
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Contenido
          Padding(
            padding: EdgeInsets.only(top: headerHeight - 20),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Registrar Insumo Agrícola",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 40, 116, 36),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Nombre del insumo
                      const Text(
                        "Nombre del insumo",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nombreInsumoController,
                        decoration: const InputDecoration(
                          hintText: "Ej: Urea, Fertilizante, Mancozeb...",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Ingresa el nombre del insumo"
                            : null,
                      ),

                      const SizedBox(height: 18),

                      // Cantidad + unidad
                      const Text(
                        "Cantidad comprada",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: TextFormField(
                              controller: _cantidadController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                hintText: "Cantidad",
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return "Ingresa la cantidad";
                                if (double.tryParse(v.replaceAll(',', '.')) ==
                                    null) {
                                  return "Número inválido";
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            flex: 4,
                            child: DropdownButtonFormField<String>(
                              value: _unidad,
                              items: const [
                                DropdownMenuItem(
                                  value: "kg",
                                  child: Text("Kg"),
                                ),
                                DropdownMenuItem(
                                  value: "bultos",
                                  child: Text("Bultos"),
                                ),
                                DropdownMenuItem(
                                  value: "ml",
                                  child: Text("Mililitros"),
                                ),
                                DropdownMenuItem(
                                  value: "L",
                                  child: Text("Litros"),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) setState(() => _unidad = v);
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Precio
                      const Text(
                        "Precio total de la compra",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _precioController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          hintText: "",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return "Ingresa el precio";
                          if (double.tryParse(v.replaceAll(',', '.')) == null) {
                            return "Número inválido";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Descripción
                      const Text(
                        "Descripción (opcional)",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descripcionController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          hintText: "",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Botón guardar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _guardarInsumo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              77,
                              199,
                              83,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Guardar insumo",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
