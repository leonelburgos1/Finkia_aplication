// comida.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComidaPage extends StatefulWidget {
  final String fincaId;
  final String? fincaNombre;

  const ComidaPage({super.key, required this.fincaId, this.fincaNombre});

  @override
  State<ComidaPage> createState() => _ComidaPageState();
}

class _ComidaPageState extends State<ComidaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _detalleController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();

  // Firestore + Auth
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _saving = false;

  String _categoria = 'Carne';
  DateTime _fecha = DateTime.now();

  final List<String> _categorias = [
    'Carne',
    'Verduras',
    'Grano',
    'Frutas',
    'Otros',
  ];

  String _unidadSugeridaPorCategoria(String categoria) {
    switch (categoria) {
      case 'Carne':
      case 'Verduras':
      case 'Grano':
      case 'Frutas':
        return 'KG';
      default:
        return 'Unidad';
    }
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _fecha = picked);
    }
  }

  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final user = _auth.currentUser;

      final Map<String, dynamic> data = {
        'tipo': 'comida',
        'categoria': _categoria,
        'detalle': _categoria == 'Otros'
            ? _detalleController.text.trim()
            : (_detalleController.text.trim().isEmpty
                  ? null
                  : _detalleController.text.trim()),
        'unidad': _unidadSugeridaPorCategoria(_categoria),
        'cantidad': double.tryParse(_cantidadController.text.trim()) ?? 0,
        'precio': double.tryParse(_precioController.text.trim()) ?? 0,
        'fecha': Timestamp.fromDate(_fecha),
        'notas': _notasController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'uid': user?.uid,
      };

      await _db
          .collection('fincas')
          .doc(widget.fincaId)
          .collection('gastos')
          .add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gasto de comida guardado'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error guardando gasto: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _detalleController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('yyyy-MM-dd').format(_fecha);

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
              height: 115,
            ),
          ),

          // Botón atrás
          Positioned(
            top: 25,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.20),
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

          // TARJETA PRINCIPAL
          Padding(
            padding: const EdgeInsets.only(top: 140, left: 16, right: 16),
            child: SafeArea(
              top: false,
              child: _saving
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TITULO
                              Text(
                                "Gasto de comida",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 40, 116, 36),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // CATEGORÍA
                              Text(
                                'Categoría',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _categoria,
                                items: _categorias
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => _categoria = v);
                                  }
                                },
                              ),
                              const SizedBox(height: 20),

                              // DETALLE
                              Text(
                                _categoria == 'Otros'
                                    ? 'Descripción (Otros)'
                                    : 'Detalle (opcional)',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _detalleController,
                                decoration: InputDecoration(
                                  hintText: _categoria == 'Otros'
                                      ? 'Describe el alimento o gasto'
                                      : 'Detalle opcional (ej: Res, Tomate...)',
                                ),
                                validator: (v) {
                                  if (_categoria == 'Otros' &&
                                      (v == null || v.trim().isEmpty)) {
                                    return 'Escribe una descripción';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // CANTIDAD Y PRECIO
                              Text(
                                'Cantidad y Precio',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      controller: _cantidadController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      decoration: InputDecoration(
                                        labelText: 'Cantidad',
                                        suffixText: _unidadSugeridaPorCategoria(
                                          _categoria,
                                        ),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Ingresa cantidad';
                                        }
                                        final n = double.tryParse(v.trim());
                                        return n == null
                                            ? 'Número inválido'
                                            : null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      controller: _precioController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      decoration: const InputDecoration(
                                        labelText: 'Precio total',
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Ingresa precio';
                                        }
                                        final n = double.tryParse(v.trim());
                                        return n == null
                                            ? 'Número inválido'
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // FECHA
                              Text(
                                'Fecha',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _seleccionarFecha,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateFormatted,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Icon(Icons.calendar_month),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // NOTAS
                              Text(
                                'Notas (opcional)',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextFormField(controller: _notasController),
                              const SizedBox(height: 25),

                              // BOTÓN
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _guardarGasto,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      77,
                                      199,
                                      83,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Guardar gasto",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
