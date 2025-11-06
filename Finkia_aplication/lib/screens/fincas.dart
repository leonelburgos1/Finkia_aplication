import 'package:flutter/material.dart';
import 'package:agrou_aplication/utils/localization_extension.dart';

class FincasData {
  // 🌱 Lista estática que guarda temporalmente las fincas registradas
  static List<Map<String, String>> listaFincas = [];
}

class FincasPage extends StatefulWidget {
  const FincasPage({super.key});

  @override
  State<FincasPage> createState() => _FincasPageState();
}

class _FincasPageState extends State<FincasPage> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> fincas = FincasData.listaFincas;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: Text(
          context.local.misFincas,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: fincas.isEmpty ? _buildEmptyState() : _buildFincasList(fincas),
      ),
    );
  }

  // 🌾 Estado cuando no hay fincas
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.landscape_rounded,
            size: 100,
            color: AppColors.primaryColor.withOpacity(0.6),
          ),
          const SizedBox(height: 20),
          Text(
            context.local.sinRegistro,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.local.primeraFinca,
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  // 🌾 Lista de fincas
  Widget _buildFincasList(List<Map<String, String>> fincas) {
    return ListView.builder(
      itemCount: fincas.length,
      itemBuilder: (context, index) {
        final finca = fincas[index];
        return Card(
          color: AppColors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              finca[context.local.nombre] ?? context.local.sinNombre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              "${context.local.ubicacion}: ${finca[context.local.ubicacion] ?? context.local.desconocida}\n"
              "${context.local.area}: ${finca[context.local.area] ?? 'N/A'} ha",
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: AppColors.primaryColor.withOpacity(0.8),
            ),
            onTap: () {
              _mostrarDetalles(context, finca);
            },
          ),
        );
      },
    );
  }

  // 📋 Modal con la información completa
  void _mostrarDetalles(BuildContext context, Map<String, String> finca) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          finca[context.local.nombre] ?? context.local.sinNombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${context.local.area}: ${finca[context.local.area]} ha"),
            Text(
              "${context.local.actividad}: ${finca[context.local.actividad]}",
            ),
            Text(
              "${context.local.ubicacion}: ${finca[context.local.ubicacion]}",
            ),
            Text(
              "${context.local.administrador}: ${finca[context.local.contacto] ?? context.local.noEspecificado}",
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              context.local.cerrado,
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

// 🎨 Colores de la pantalla
class AppColors {
  static const Color backgroundColor = Color(0xFFEAF4E1);
  static const Color appBarColor = Color(0xFF2B7A0B);
  static const Color primaryColor = Color(0xFF81B622);
  static const Color cardColor = Color(0xFFD9F8C4);
}
