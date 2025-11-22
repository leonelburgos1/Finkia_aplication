import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrou_aplication/utils/localization_extension.dart';

class FormFinca extends StatefulWidget {
  const FormFinca({super.key});

  @override
  State<FormFinca> createState() => _FormFincaState();
}

class _FormFincaState extends State<FormFinca> {
  final _formKey = GlobalKey<FormState>();

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

  Future<void> _guardarFinca() async {
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

      try {
        final user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection('fincas').add({
          'nombre': _nombreController.text.trim(),
          'area': double.tryParse(_areaController.text.trim()) ?? 0,
          'actividad': _actividadController.text.trim(),
          'pais': countryValue,
          'departamento': stateValue,
          'ciudad': cityValue,
          'contacto': _contactoController.text.trim(),
          'uid': user?.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.local.fincaRegistrada),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al registrar la finca: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color.fromARGB(192, 2, 20, 3) : Colors.white,
      body: Stack(
        children: [
          // ------------------------------
          //       IMAGEN HEADER (Dark/Light)
          // ------------------------------
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Image.asset(
              isDark
                  ? 'assets/images/registrarfinca_dark.png'
                  : 'assets/images/registrarFinca.png',
              height: 130,
              fit: BoxFit.cover,
            ),
          ),

          // ------------------------------
          //  BOTÓN ATRÁS REDONDO
          // ------------------------------
          Positioned(
            top: 30,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
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

          // ------------------------------
          //   CONTENIDO DEL FORMULARIO
          // ------------------------------
          Padding(
            padding: const EdgeInsets.only(top: 140, left: 18, right: 18),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color.fromARGB(157, 3, 34, 5) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ------------------------------
                      //       TÍTULO FORMULARIO
                      // ------------------------------
                      Text(
                        context.local.registrarFinca,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _nombreController,
                        label: context.local.nombreFinca,
                        icon: Icons.house,
                        validator: (v) => v!.isEmpty ? context.local.ingreseNombre : null,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _areaController,
                        label: context.local.areaFinca,
                        icon: Icons.square_foot,
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? context.local.ingreseAreaFinca : null,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _actividadController,
                        label: context.local.actividadAgricola,
                        icon: Icons.agriculture,
                        validator: (v) => v!.isEmpty ? context.local.describaActividad : null,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 25),

                      // ------------------------------
                      //      UBICACIÓN (CSCPICKER)
                      // ------------------------------
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.local.ubicacionFinca,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color.fromARGB(211, 1, 61, 5) : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            width: 1.4,
                          ),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: CSCPickerPlus(
                          showStates: true,
                          showCities: true,
                          countryStateLanguage: CountryStateLanguage.englishOrNative,
                          cityLanguage: CityLanguage.native,
                          countryDropdownLabel: context.local.pais,
                          stateDropdownLabel: context.local.departamento,
                          cityDropdownLabel: context.local.ciudad,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            color: isDark ? const Color.fromARGB(210, 2, 78, 7) : Colors.white,
                            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 1.4),
                          ),
                          selectedItemStyle: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                          dropdownItemStyle: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                              stateValue = "";
                              cityValue = "";
                            });
                          },
                          onStateChanged: (value) {
                            setState(() {
                              stateValue = value ?? "";
                              cityValue = "";
                            });
                          },
                          onCityChanged: (value) {
                            setState(() {
                              cityValue = value ?? "";
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _contactoController,
                        label: context.local.contactoAdministrador,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 30),

                      // ------------------------------
                      //      BOTÓN REGISTRAR
                      // ------------------------------
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    const Color.fromARGB(210, 2, 78, 7),  // Dark mode color 1
                                    const Color.fromARGB(255, 1, 34, 2),  // Dark mode color 2
                                  ]
                                : [
                                    const Color.fromARGB(255, 164, 231, 38), // Light mode color 1
                                    const Color(0xFF2E7D32),                 // Light mode color 2
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white)
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                            shadowColor: const Color.fromARGB(0, 255, 255, 255),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _guardarFinca,
                          child: Text(
                            context.local.registrar,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
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

  // ------------------------------
  //     ESTILO DE INPUTS
  // ------------------------------
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? const Color.fromARGB(255, 255, 255, 255) : Colors.black54),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 255, 255, 255)),
        filled: true,
        fillColor: isDark ? const Color.fromARGB(211, 1, 61, 5) : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 1.3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 2,
          ),
        ),
      ),
    );
  }
}
