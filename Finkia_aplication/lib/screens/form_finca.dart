import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:agrou_aplication/screens/fincas.dart'; // para acceder a la lista compartida
import 'package:agrou_aplication/utils/localization_extension.dart';

class FormFinca extends StatefulWidget {
  const FormFinca({super.key});

  @override
  State<FormFinca> createState() => _FormFincaState();
}

class _FormFincaState extends State<FormFinca> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _actividadController = TextEditingController();
  final TextEditingController _contactoController = TextEditingController();

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  @override
  void dispose() {
    _nombreController.dispose();
    _areaController.dispose();
    _actividadController.dispose();
    _contactoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryYellow,
        title: Text(
          context.local.registrarFinca,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _nombreController,
                label: context.local.nombreFinca,
                icon: Icons.house,
                validator: (v) =>
                    v!.isEmpty ? context.local.ingreseNombre : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _areaController,
                label: context.local.areaFinca,
                icon: Icons.square_foot,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? context.local.ingreseAreaFinca : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _actividadController,
                label: context.local.actividadAgricola,
                icon: Icons.agriculture,
                validator: (v) =>
                    v!.isEmpty ? context.local.describaActividad : null,
              ),
              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.local.ubicacionFinca,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: formBg,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: borderGreen, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SelectState(
                  onCountryChanged: (value) {
                    setState(() => countryValue = value);
                  },
                  onStateChanged: (value) {
                    setState(() => stateValue = value);
                  },
                  onCityChanged: (value) {
                    setState(() => cityValue = value);
                  },
                ),
              ),

              const SizedBox(height: 20),

              _buildTextField(
                controller: _contactoController,
                label: context.local.contactoAdministrador,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                ),
                onPressed: _guardarFinca,
                child: Text(
                  context.local.registrar,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _guardarFinca() {
    if (_formKey.currentState!.validate()) {
      if (countryValue.isEmpty || stateValue.isEmpty || cityValue.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.local.completarUbicacion),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // 💾 Guardar finca temporalmente en memoria
      FincasData.listaFincas.add({
        context.local.nombre: _nombreController.text,
        context.local.area: _areaController.text,
        context.local.actividad: _actividadController.text,
        context.local.ubicacion: "$countryValue, $stateValue, $cityValue",
        context.local.contacto: _contactoController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.local.fincaRegistrada),
          backgroundColor: successGreen,
        ),
      );

      Navigator.pop(context); // 🔙 Volvemos a la lista
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: accentGreen),
        filled: true,
        fillColor: formBg,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderGreen, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentGreen, width: 2.5),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

// 🎨 Paleta de colores
const Color bgColor = Color(0xFFEAF4E1);
const Color primaryYellow = Color(0xFFE8E91E);
const Color accentGreen = Color(0xFF6FC21E);
const Color borderGreen = Color(0xFFB5E550);
const Color successGreen = Color(0xFF60B218);
const Color formBg = Color(0xFFF7FBEE);
