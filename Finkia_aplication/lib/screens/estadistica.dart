// estadistica.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EstadisticaPage extends StatefulWidget {
  final String fincaId;
  const EstadisticaPage({super.key, required this.fincaId});

  @override
  State<EstadisticaPage> createState() => _EstadisticaPageState();
}

class _EstadisticaPageState extends State<EstadisticaPage> {
  // colores consistentes con tu app
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color accentGreen = Color(0xFFA4E726);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color pageBg = Color(0xFFF5F5F5);

  String _selectedSpecific = 'comida'; // comida, trabajador, insumo, transporte

  @override
  Widget build(BuildContext context) {
    final gastosStream = FirebaseFirestore.instance
        .collection('fincas')
        .doc(widget.fincaId)
        .collection('gastos')
        .snapshots();

    return Scaffold(
      backgroundColor: pageBg,
      body: Stack(
        children: [
          // header image (igual que tus pantallas)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/gastos.png',
              fit: BoxFit.cover,
              height: 110,
            ),
          ),

          // back button
          Positioned(
            top: 28,
            left: 12,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.20),
                border: Border.all(color: Colors.white, width: 1.2),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // contenido principal
          Padding(
            padding: const EdgeInsets.only(top: 130, left: 16, right: 16),
            child: SafeArea(
              top: false,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: gastosStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  // --- CALCULOS AGREGADOS ---
                  double totalGeneral = 0.0;
                  final Map<String, double> totalPorTipo = {
                    'comida': 0.0,
                    'trabajador': 0.0,
                    'insumo': 0.0,
                    'transporte': 0.0,
                    'otros': 0.0,
                  };

                  // datos específicos:
                  final Map<String, double> comidaPorCategoria = {};
                  final Map<String, double> trabajadoresPorActividad = {};
                  final Map<String, double> insumosPorNombre = {};
                  double transportePropio = 0.0;
                  double transporteContratado = 0.0;

                  for (var d in docs) {
                    final data = d.data();
                    final tipo =
                        (data['tipo'] as String?)?.toLowerCase() ?? 'otros';
                    // determinamos valor del gasto para sumar al total general.
                    double valorDoc = 0.0;
                    if (data.containsKey('total')) {
                      valorDoc = (data['total'] is num)
                          ? (data['total'] as num).toDouble()
                          : double.tryParse('${data['total']}') ?? 0.0;
                    } else if (data.containsKey('precio')) {
                      valorDoc = (data['precio'] is num)
                          ? (data['precio'] as num).toDouble()
                          : double.tryParse('${data['precio']}') ?? 0.0;
                    } else if (data.containsKey('valorPorBulto')) {
                      final cant = (data['cantidadBultos'] is num)
                          ? (data['cantidadBultos'] as num).toDouble()
                          : double.tryParse('${data['cantidadBultos'] ?? 0}') ??
                                0.0;
                      final val = (data['valorPorBulto'] is num)
                          ? (data['valorPorBulto'] as num).toDouble()
                          : double.tryParse('${data['valorPorBulto'] ?? 0}') ??
                                0.0;
                      valorDoc = cant * val;
                    } else if (data.containsKey('precioPorLitro') &&
                        data.containsKey('litros')) {
                      final litros = (data['litros'] is num)
                          ? (data['litros'] as num).toDouble()
                          : double.tryParse('${data['litros'] ?? 0}') ?? 0.0;
                      final precioL = (data['precioPorLitro'] is num)
                          ? (data['precioPorLitro'] as num).toDouble()
                          : double.tryParse('${data['precioPorLitro'] ?? 0}') ??
                                0.0;
                      valorDoc =
                          litros * precioL +
                          ((data['otrosGastos'] is num)
                              ? (data['otrosGastos'] as num).toDouble()
                              : double.tryParse(
                                      '${data['otrosGastos'] ?? 0}',
                                    ) ??
                                    0.0);
                    } else if (data.containsKey('valorUnidad') &&
                        data.containsKey('cantidadTrabajadores')) {
                      final cantidadTrab = (data['cantidadTrabajadores'] is num)
                          ? (data['cantidadTrabajadores'] as num).toDouble()
                          : double.tryParse(
                                  '${data['cantidadTrabajadores'] ?? 0}',
                                ) ??
                                0.0;
                      final cantidad = (data['cantidad'] is num)
                          ? (data['cantidad'] as num).toDouble()
                          : double.tryParse('${data['cantidad'] ?? 0}') ?? 0.0;
                      final valorUnidad = (data['valorUnidad'] is num)
                          ? (data['valorUnidad'] as num).toDouble()
                          : double.tryParse('${data['valorUnidad'] ?? 0}') ??
                                0.0;
                      valorDoc = cantidadTrab * cantidad * valorUnidad;
                    } else {
                      if (data.containsKey('valorUnidad')) {
                        valorDoc = (data['valorUnidad'] is num)
                            ? (data['valorUnidad'] as num).toDouble()
                            : double.tryParse('${data['valorUnidad']}') ?? 0.0;
                      } else {
                        valorDoc = 0.0;
                      }
                    }

                    // sumar a totales
                    totalGeneral += valorDoc;
                    totalPorTipo[tipo] = (totalPorTipo[tipo] ?? 0) + valorDoc;

                    // datos específicos por tipo
                    if (tipo == 'comida') {
                      final cat =
                          (data['categoria'] as String?) ?? 'Sin categoría';
                      comidaPorCategoria[cat] =
                          (comidaPorCategoria[cat] ?? 0) + valorDoc;
                    } else if (tipo == 'trabajador') {
                      final actividad =
                          (data['actividad'] as String?) ?? 'Sin actividad';
                      trabajadoresPorActividad[actividad] =
                          (trabajadoresPorActividad[actividad] ?? 0) + valorDoc;
                    } else if (tipo == 'insumo') {
                      final nombre =
                          (data['nombreInsumo'] as String?) ?? 'Sin nombre';
                      insumosPorNombre[nombre] =
                          (insumosPorNombre[nombre] ?? 0) + valorDoc;
                    } else if (tipo == 'transporte') {
                      final modo = (data['modo'] as String?) ?? '';
                      if (modo == 'propio')
                        transportePropio += valorDoc;
                      else
                        transporteContratado += valorDoc;
                    }
                  } // fin for docs

                  // preparar PieChartSections por tipo (no mostrar si 0)
                  final List<PieChartSectionData> pieSections = [];
                  final tipoList = totalPorTipo.entries
                      .where((e) => e.value > 0)
                      .toList();
                  double sumTipos = tipoList.fold(0.0, (p, e) => p + e.value);
                  int colorIndex = 0;
                  final List<Color> palette = [
                    primaryGreen,
                    accentGreen,
                    Colors.orange,
                    Colors.blueGrey,
                  ];
                  for (var e in tipoList) {
                    final pct = sumTipos == 0
                        ? 0.0
                        : (e.value / sumTipos) * 100;
                    pieSections.add(
                      PieChartSectionData(
                        color: palette[colorIndex % palette.length],
                        value: e.value,
                        title: '${pct.toStringAsFixed(0)}%',
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        radius: 50,
                      ),
                    );
                    colorIndex++;
                  }

                  // UI: tarjeta resumen + graficas + especifica
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Resumen tarjetas
                        _buildResumenCards(totalPorTipo, totalGeneral),

                        const SizedBox(height: 16),

                        // Contenedor principal: general arriba (pie)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Visión general',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Pie chart + leyenda (nota: quité el texto "Distribución por tipo")
                              Column(
                                children: [
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    height: 210,
                                    child: pieSections.isEmpty
                                        ? const Center(
                                            child: Text('No hay datos'),
                                          )
                                        : PieChart(
                                            PieChartData(
                                              sections: pieSections,
                                              sectionsSpace: 6,
                                              centerSpaceRadius: 30,
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 10),
                                  // leyenda: ahora en Wrap con cada ítem en su propio contenedor
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: totalPorTipo.entries
                                          .where((e) => e.value > 0)
                                          .map((e) {
                                            final color = (e.key == 'comida')
                                                ? primaryGreen
                                                : (e.key == 'trabajador'
                                                      ? accentGreen
                                                      : (e.key == 'insumo'
                                                            ? Colors.orange
                                                            : Colors.blueGrey));
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 6,
                                                    horizontal: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.12),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    color: color,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '${_capitalize(e.key)}: ${_formatCurrency(e.value)}',
                                                  ),
                                                ],
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // SECCION ESPECÍFICA
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Estadística específica',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // selector de tipo específico
                              Row(
                                children: [
                                  DropdownButton<String>(
                                    value: _selectedSpecific,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'comida',
                                        child: Text('Comida'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'trabajador',
                                        child: Text('Trabajadores'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'insumo',
                                        child: Text('Insumos'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'transporte',
                                        child: Text('Transporte'),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() => _selectedSpecific = v);
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Filtrar / ver detalles',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // contenido dinámico según selección
                              if (_selectedSpecific == 'comida') ...[
                                const Text(
                                  'Comida — gasto por categoría',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                comidaPorCategoria.isEmpty
                                    ? const Text('No hay registros de comida')
                                    : SizedBox(
                                        height: 200,
                                        child: PieChart(
                                          PieChartData(
                                            sections: comidaPorCategorySections(
                                              comidaPorCategoria,
                                            ),
                                            sectionsSpace: 6,
                                            centerSpaceRadius: 30,
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 12),
                                // lista top
                                ...comidaPorCategoria.entries
                                    .toList()
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e.key),
                                        trailing: Text(
                                          _formatCurrency(e.value),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ] else if (_selectedSpecific == 'trabajador') ...[
                                const Text(
                                  'Trabajadores — gasto por actividad',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                trabajadoresPorActividad.isEmpty
                                    ? const Text(
                                        'No hay registros de trabajadores',
                                      )
                                    : Column(
                                        children: trabajadoresPorActivityBars(
                                          trabajadoresPorActivity:
                                              trabajadoresPorActividad,
                                        ),
                                      ),
                                const SizedBox(height: 12),
                                ...trabajadoresPorActividad.entries
                                    .toList()
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e.key),
                                        trailing: Text(
                                          _formatCurrency(e.value),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ] else if (_selectedSpecific == 'insumo') ...[
                                const Text(
                                  'Insumos — top insumos por gasto',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                insumosPorNombre.isEmpty
                                    ? const Text('No hay registros de insumos')
                                    : SizedBox(
                                        height: 200,
                                        child: PieChart(
                                          PieChartData(
                                            sections: _mapToPieSections(
                                              insumosPorNombre,
                                              [
                                                Colors.orange.shade700,
                                                Colors.orange.shade400,
                                                Colors.deepOrange,
                                                Colors.amber,
                                                Colors.brown,
                                              ],
                                            ),
                                            sectionsSpace: 6,
                                            centerSpaceRadius: 30,
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 12),
                                // lista top insumos
                                ...insumosPorNombre.entries
                                    .toList()
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e.key),
                                        trailing: Text(
                                          _formatCurrency(e.value),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ] else if (_selectedSpecific == 'transporte') ...[
                                const Text(
                                  'Transporte — propio vs contratado',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 160,
                                  child: PieChart(
                                    PieChartData(
                                      sections: transportePieSections(
                                        transportePropio,
                                        transporteContratado,
                                      ),
                                      centerSpaceRadius: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ListTile(
                                  title: const Text('Propio'),
                                  trailing: Text(
                                    _formatCurrency(transportePropio),
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Contratado'),
                                  trailing: Text(
                                    _formatCurrency(transporteContratado),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------
  // WIDGETS & HELPERS
  // -------------------------------------------

  // resumen cards horizontales (adaptable)
  Widget _buildResumenCards(Map<String, double> totals, double totalGeneral) {
    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 2),
          _smallCard(
            'Total general',
            _formatCurrency(totalGeneral),
            Colors.black87,
          ),
          const SizedBox(width: 8),
          _smallCard(
            'Comida',
            _formatCurrency(totals['comida'] ?? 0),
            const Color(0xFF2E7D32),
          ),
          const SizedBox(width: 8),
          _smallCard(
            'Trabajadores',
            _formatCurrency(totals['trabajador'] ?? 0),
            const Color(0xFFA4E726),
          ),
          const SizedBox(width: 8),
          _smallCard(
            'Insumos',
            _formatCurrency(totals['insumo'] ?? 0),
            Colors.orange,
          ),
          const SizedBox(width: 8),
          _smallCard(
            'Transporte',
            _formatCurrency(totals['transporte'] ?? 0),
            Colors.blueGrey,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _smallCard(String title, String value, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double v) {
    if (v == 0) return '\$0';
    if (v.abs() >= 1000000)
      return '\$' + (v / 1000000).toStringAsFixed(1) + 'M';
    if (v.abs() >= 1000) return '\$' + (v / 1000).toStringAsFixed(1) + 'K';
    return '\$' + v.toStringAsFixed(0);
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  // pie sections de comida por categoria (usa paleta por defecto)
  static List<PieChartSectionData> comidaPorCategorySections(
    Map<String, double> map,
  ) {
    return _mapToPieSectionsStatic(map, [
      const Color(0xFF2E7D32),
      const Color(0xFFA4E726),
      Colors.orange,
      Colors.blueGrey,
      Colors.purple,
    ]);
  }

  // helpers estáticos para crear secciones (no accede a this)
  static List<PieChartSectionData> _mapToPieSectionsStatic(
    Map<String, double> map,
    List<Color> colors, {
    double radius = 44,
  }) {
    final total = map.values.fold(0.0, (p, e) => p + e);
    int i = 0;
    return map.entries.map((e) {
      final value = e.value;
      final pct = total == 0 ? 0.0 : (value / total) * 100;
      final sec = PieChartSectionData(
        color: colors[i % colors.length],
        value: value,
        title: pct >= 4 ? '${pct.toStringAsFixed(0)}%' : '',
        radius: radius,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
      i++;
      return sec;
    }).toList();
  }

  // versión de instancia (útil si quieres pasar colores dinámicos)
  static List<PieChartSectionData> _mapToPieSections(
    Map<String, double> map,
    List<Color> colors, {
    double radius = 44,
  }) {
    return _mapToPieSectionsStatic(map, colors, radius: radius);
  }

  // barras para actividades de trabajadores (horizontal simple con ListTiles)
  List<Widget> trabajadoresPorActivityBars({
    required Map<String, double> trabajadoresPorActivity,
  }) {
    final entries = trabajadoresPorActivity.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.map((e) {
      final percent = e.value == 0
          ? 0.0
          : (e.value / (entries.first.value == 0 ? 1 : entries.first.value));
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 3, child: Text(e.key)),
                Expanded(
                  flex: 7,
                  child: Stack(
                    children: [
                      Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percent,
                        child: Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(_formatCurrency(e.value)),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  // pie para transporte
  static List<PieChartSectionData> transportePieSections(
    double propio,
    double contratado,
  ) {
    final total = propio + contratado;
    final List<PieChartSectionData> s = [];
    if (propio > 0) {
      s.add(
        PieChartSectionData(
          color: const Color(0xFF2E7D32),
          value: propio,
          title: total == 0
              ? ''
              : '${((propio / total) * 100).toStringAsFixed(0)}%',
          radius: 44,
          titleStyle: const TextStyle(color: Colors.white),
        ),
      );
    }
    if (contratado > 0) {
      s.add(
        PieChartSectionData(
          color: Colors.blueGrey,
          value: contratado,
          title: total == 0
              ? ''
              : '${((contratado / total) * 100).toStringAsFixed(0)}%',
          radius: 44,
          titleStyle: const TextStyle(color: Colors.white),
        ),
      );
    }
    return s;
  }
}
