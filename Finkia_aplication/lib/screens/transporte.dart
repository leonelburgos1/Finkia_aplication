// transporte.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransportePage extends StatefulWidget {
  final String fincaId;

  const TransportePage({super.key, required this.fincaId});

  @override
  State<TransportePage> createState() => _TransportePageState();
}

class _TransportePageState extends State<TransportePage> {
  final _formKey = GlobalKey<FormState>();

  // Campos comunes / controllers
  final TextEditingController _vehiculoController =
      TextEditingController(); // para propio
  final TextEditingController _litrosController = TextEditingController();
  final TextEditingController _precioLitroController = TextEditingController();
  final TextEditingController _otrosGastosController = TextEditingController();

  final TextEditingController _transportistaController =
      TextEditingController(); // para contratado
  final TextEditingController _cantidadBultosController =
      TextEditingController();
  final TextEditingController _valorPorBultoController =
      TextEditingController();

  String _tipoTransporte = 'Propio'; // 'Propio' o 'Contratado'
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _litrosController.addListener(_calcularTotal);
    _precioLitroController.addListener(_calcularTotal);
    _otrosGastosController.addListener(_calcularTotal);
    _cantidadBultosController.addListener(_calcularTotal);
    _valorPorBultoController.addListener(_calcularTotal);
  }

  @override
  void dispose() {
    _vehiculoController.dispose();
    _litrosController.dispose();
    _precioLitroController.dispose();
    _otrosGastosController.dispose();
    _transportistaController.dispose();
    _cantidadBultosController.dispose();
    _valorPorBultoController.dispose();
    super.dispose();
  }

  void _calcularTotal() {
    double total = 0.0;
    if (_tipoTransporte == 'Propio') {
      final valorCombustible =
          double.tryParse(_litrosController.text.replaceAll(',', '.')) ?? 0;

      final otros =
          double.tryParse(_otrosGastosController.text.replaceAll(',', '.')) ??
          0;

      total = valorCombustible + otros;
    } else {
      final bultos =
          double.tryParse(
            _cantidadBultosController.text.replaceAll(',', '.'),
          ) ??
          0;
      final valor =
          double.tryParse(_valorPorBultoController.text.replaceAll(',', '.')) ??
          0;
      total = bultos * valor;
    }
    setState(() => _total = total);
  }

  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) return;

    final data = <String, dynamic>{
      'tipo': 'transporte',
      'modo': _tipoTransporte.toLowerCase(), // 'propio' o 'contratado'
      'total': _total,
      'fecha': Timestamp.now(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (_tipoTransporte == 'Propio') {
      data.addAll({
        'vehiculo': _vehiculoController.text.trim(),
        'litros':
            double.tryParse(_litrosController.text.replaceAll(',', '.')) ?? 0,
        'precioPorLitro':
            double.tryParse(_precioLitroController.text.replaceAll(',', '.')) ??
            0,
        'otrosGastos':
            double.tryParse(_otrosGastosController.text.replaceAll(',', '.')) ??
            0,
      });
    } else {
      data.addAll({
        'transportista': _transportistaController.text.trim(),
        'cantidadBultos':
            double.tryParse(
              _cantidadBultosController.text.replaceAll(',', '.'),
            ) ??
            0,
        'valorPorBulto':
            double.tryParse(
              _valorPorBultoController.text.replaceAll(',', '.'),
            ) ??
            0,
      });
    }

    try {
      await FirebaseFirestore.instance
          .collection('fincas')
          .doc(widget.fincaId)
          .collection('gastos')
          .add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gasto de transporte guardado'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpiar formulario
      _vehiculoController.clear();
      _litrosController.clear();
      _precioLitroController.clear();
      _otrosGastosController.clear();
      _transportistaController.clear();
      _cantidadBultosController.clear();
      _valorPorBultoController.clear();
      setState(() {
        _total = 0.0;
        _tipoTransporte = 'Propio';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String _formatCurrency(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
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

          // Botón atrás encima imagen
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Registrar gasto - Transporte',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 40, 116, 36),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Selector tipo transporte
                      const Text(
                        'Tipo de transporte',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _tipoTransporte,
                        items: const [
                          DropdownMenuItem(
                            value: 'Propio',
                            child: Text('Propio'),
                          ),
                          DropdownMenuItem(
                            value: 'Contratado',
                            child: Text('Contratado'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() {
                            _tipoTransporte = v;
                            _calcularTotal();
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ---------- PROPIO ----------
                      if (_tipoTransporte == 'Propio') ...[
                        const Text(
                          'Vehículo (Nombre )',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _vehiculoController,
                          decoration: const InputDecoration(
                            hintText: '',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'valor combustible',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _litrosController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: '', // opcional
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty)
                                        return 'Ingresa los litros';
                                      if (double.tryParse(
                                            v.replaceAll(',', '.'),
                                          ) ==
                                          null)
                                        return 'Número inválido';
                                      return null;
                                    },
                                    onChanged: (_) => _calcularTotal(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),

                        const Text(
                          'Otros gastos (opcional)',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _otrosGastosController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (_) => _calcularTotal(),
                        ),
                      ],

                      // ---------- CONTRATADO ----------
                      if (_tipoTransporte == 'Contratado') ...[
                        const Text(
                          'Transportista / Empresa',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),

                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '', // opcional
                          ),
                          controller: _transportistaController,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Ingresa el transportista';
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Cantidad de bultos',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _cantidadBultosController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: '', // opcional
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty)
                                        return 'Ingresa la cantidad de bultos';
                                      if (double.tryParse(
                                            v.replaceAll(',', '.'),
                                          ) ==
                                          null)
                                        return 'Número inválido';
                                      return null;
                                    },
                                    onChanged: (_) => _calcularTotal(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Valor por bulto',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _valorPorBultoController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: '', // opcional
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty)
                                        return 'Ingresa el valor por bulto';
                                      if (double.tryParse(
                                            v.replaceAll(',', '.'),
                                          ) ==
                                          null)
                                        return 'Número inválido';
                                      return null;
                                    },
                                    onChanged: (_) => _calcularTotal(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 18),

                      // Mostrar total
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8FFE9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total estimado',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '\$${_formatCurrency(_total)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Botón guardar
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Guardar gasto',
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
