// trabajadores.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrabajadoresPage extends StatefulWidget {
  final String fincaId;

  const TrabajadoresPage({super.key, required this.fincaId});

  @override
  State<TrabajadoresPage> createState() => _TrabajadoresPageState();
}

class _TrabajadoresPageState extends State<TrabajadoresPage> {
  final _formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _valorUnidadController = TextEditingController();
  final TextEditingController _otrosDescripcionController =
      TextEditingController();
  final TextEditingController _nombreTrabajadorController =
      TextEditingController();

  // ESTADO
  int _cantidadTrabajadores = 1;
  String _actividad = "Recolección";
  String _tipoCantidad = "Horas"; // Horas o Kilos
  double _total = 0.0;

  final List<String> actividades = [
    "Recolección",
    "Cosecha selectiva",
    "Fumigación",
    "Abonada",
    "Desyerbe",
    "Mantenimiento",
    "Transporte",
    "Otros",
  ];

  @override
  void initState() {
    super.initState();
    _cantidadController.addListener(_calcularTotal);
    _valorUnidadController.addListener(_calcularTotal);
  }

  @override
  void dispose() {
    _cantidadController.removeListener(_calcularTotal);
    _valorUnidadController.removeListener(_calcularTotal);
    _cantidadController.dispose();
    _valorUnidadController.dispose();
    _otrosDescripcionController.dispose();
    _nombreTrabajadorController.dispose();
    super.dispose();
  }

  void _incrementTrabajadores() {
    setState(() {
      _cantidadTrabajadores++;
      _calcularTotal();
    });
  }

  void _decrementTrabajadores() {
    if (_cantidadTrabajadores > 1) {
      setState(() {
        _cantidadTrabajadores--;
        _calcularTotal();
      });
    }
  }

  void _calcularTotal() {
    final cantidad =
        double.tryParse(_cantidadController.text.replaceAll(',', '.')) ?? 0;
    final valorUnidad =
        double.tryParse(_valorUnidadController.text.replaceAll(',', '.')) ?? 0;

    double total = 0.0;
    if (_tipoCantidad == "Horas") {
      // Horas: multiplican trabajadores
      total = _cantidadTrabajadores * cantidad * valorUnidad;
    } else {
      // Kilos: trabajadores no influyen en el cálculo del total
      total = cantidad * valorUnidad;
    }

    setState(() {
      _total = total;
    });
  }

  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) return;

    final actividadFinal = _actividad == "Otros"
        ? _otrosDescripcionController.text.trim()
        : _actividad;

    final cantidad =
        double.tryParse(_cantidadController.text.replaceAll(',', '.')) ?? 0;
    final valorUnidad =
        double.tryParse(_valorUnidadController.text.replaceAll(',', '.')) ?? 0;

    final Map<String, dynamic> data = {
      'tipo': 'trabajador',
      'nombreTrabajador': _nombreTrabajadorController.text.trim().isEmpty
          ? null
          : _nombreTrabajadorController.text.trim(),
      'actividad': actividadFinal,
      'unidad': _tipoCantidad.toLowerCase(), // 'horas' o 'kilos'
      'cantidad': cantidad,
      'valorUnidad': valorUnidad,
      'total': _total,
      'cantidadTrabajadores': _cantidadTrabajadores,
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
          content: Text('Gasto de trabajadores guardado'),
          backgroundColor: Colors.green,
        ),
      );

      // limpiar
      _nombreTrabajadorController.clear();
      _otrosDescripcionController.clear();
      _cantidadController.clear();
      _valorUnidadController.clear();
      setState(() {
        _cantidadTrabajadores = 1;
        _actividad = actividades.first;
        _tipoCantidad = "Horas";
        _total = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error guardando gasto: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String _formatCurrency(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    // header height proporcional a pantalla (no se corta)
    final double screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = (screenHeight * 0.22).clamp(120.0, 260.0);

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

          // BOTÓN ATRÁS encima de la imagen
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // CONTENIDO (empieza después del header)
          Padding(
            padding: EdgeInsets.only(top: headerHeight - 20),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Card contenedor
                    Container(
                      width: double.infinity,
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
                          // Título
                          const Text(
                            "Registrar gasto - Trabajadores",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 40, 116, 36),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // CANTIDAD TRABAJADORES (ahora SIEMPRE visible y antes de actividad)
                          const Text(
                            "Cantidad de trabajadores",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _decrementTrabajadores,
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$_cantidadTrabajadores',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _incrementTrabajadores,
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // ACTIVIDAD realizada
                          const Text(
                            "Actividad realizada",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _actividad,
                            items: actividades
                                .map(
                                  (a) => DropdownMenuItem(
                                    value: a,
                                    child: Text(a),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() {
                                _actividad = v;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),

                          // CAMPO OCULTO SI "Otros"
                          if (_actividad == "Otros") ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _otrosDescripcionController,
                              decoration: const InputDecoration(
                                labelText: "Descripción (Otros)",
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (_actividad == "Otros" &&
                                    (v == null || v.trim().isEmpty)) {
                                  return "Describe la actividad";
                                }
                                return null;
                              },
                            ),
                          ],

                          const SizedBox(height: 18),

                          // CANTIDAD (horas o kilos) + selector unidad
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _tipoCantidad == "Horas"
                                          ? "Horas por trabajador"
                                          : "Kilos recolectados",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _cantidadController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      decoration: InputDecoration(
                                        hintText: _tipoCantidad == "Horas"
                                            ? ""
                                            : "",
                                        border: const OutlineInputBorder(),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty)
                                          return "Ingresa la cantidad";
                                        final n = double.tryParse(
                                          v.replaceAll(',', '.'),
                                        );
                                        if (n == null) return "Número inválido";
                                        if (n < 0) return "Cantidad inválida";
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
                                      "Unidad",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      value: _tipoCantidad,
                                      items: const [
                                        DropdownMenuItem(
                                          value: "Horas",
                                          child: Text("Horas"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Kilos",
                                          child: Text("Kilos"),
                                        ),
                                      ],
                                      onChanged: (v) {
                                        if (v == null) return;
                                        setState(() {
                                          _tipoCantidad = v;
                                          _calcularTotal();
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // VALOR POR UNIDAD
                          const Text(
                            "Valor por unidad",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _valorUnidadController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              hintText: _tipoCantidad == "Horas" ? "" : "",
                              border: const OutlineInputBorder(),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Ingresa el valor";
                              }
                              final n = double.tryParse(v.replaceAll(',', '.'));
                              if (n == null) return "Número inválido";
                              if (n < 0) return "Valor inválido";
                              return null;
                            },
                            onChanged: (_) => _calcularTotal(),
                          ),

                          const SizedBox(height: 20),

                          // TOTAL
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
                                  "Total estimado",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "\$${_formatCurrency(_total)}",
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

                          // BOTÓN GUARDAR
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
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
