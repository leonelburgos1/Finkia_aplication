import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agrou_aplication/utils/localization_extension.dart';

// ======================= PALETA DE COLORES (Duplicadas para que el archivo sea independiente) =======================
const Color darkBg = Color.fromARGB(255, 1, 34, 2);
const Color primaryDark = Color.fromARGB(255, 2, 78, 7);
const Color primaryLight = Color.fromARGB(210, 2, 78, 7);
const Color accentLight = Color.fromARGB(255, 235, 235, 235);
const Color accentGreen = Color.fromARGB(255, 164, 231, 38);
// ===================================================================================================================

class AcercaDePage extends StatelessWidget {
  const AcercaDePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? darkBg : accentLight,
      body: Stack(
        children: [
          // ================= 1. HEADER (Imagen de fondo) =================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              isDark ? 'assets/images/header2.png' : 'assets/images/header.png',
              fit: BoxFit.cover,
              height: 100,
            ),
          ),

          // ================= 2. BOTÓN ATRÁS y TÍTULO =================
          Positioned(
            top: 40,
            left: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ================= 3. CONTENIDO PRINCIPAL (Scrollable) =================
          Padding(
            padding: const EdgeInsets.only(
              top: 130,
            ), // Empieza justo debajo del header
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= MISIÓN Y VALOR =================
                  _buildMissionCard(context),
                  const SizedBox(height: 30),

                  // ================= CREACIÓN Y ORIGEN =================
                  const Text(
                    'Nuestra Historia y Origen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryDark,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color.fromARGB(255, 30, 70, 30)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: accentGreen, size: 30),
                        const SizedBox(width: 15),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                              children: const <TextSpan>[
                                TextSpan(
                                  text:
                                      'Finkia es una aplicación desarrollada en ',
                                ),
                                TextSpan(
                                  text: 'Pasto, Nariño, Colombia.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      ' Nacemos del conocimiento local y la firme convicción de impulsar la economía agraria de nuestra región.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ================= EQUIPO FUNDADOR =================
                  const Text(
                    'Equipo Fundador',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryDark,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildCreatorCard(
                    context,
                    name: 'Leonel Burgos',
                    email: 'alezander.burgos@gmail.com',
                    phone: '318 329 6282',
                    role: 'Desarrollador ',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 15),
                  _buildCreatorCard(
                    context,
                    name: 'Fernando Guevara',
                    email: 'fernando123@gmail.com',
                    phone: '313 245 2737',
                    role: 'Desarrollador ',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta principal de la misión de la aplicación
  Widget _buildMissionCard(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [primaryDark, darkBg],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color.fromARGB(255, 230, 255, 230), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentGreen.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentGreen.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.spa, color: accentGreen, size: 36),
              const SizedBox(width: 10),
              Text(
                'Finkia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? accentGreen : primaryDark,
                ),
              ),
            ],
          ),
          const Divider(height: 25, thickness: 0.5, color: Colors.white38),
          Text(
            'Finkia nace como una solución digital, creada pensando en las necesidades reales del campesino colombiano, con una especialización inicial en el sector cafetero.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          _buildFeatureRow(
            context,
            icon: Icons.grass,
            text:
                'Permite registrar una o varias fincas, organizando tu operación por propiedad.',
            isDark: isDark,
          ),
          _buildFeatureRow(
            context,
            icon: Icons.money_off_csred,
            text:
                'Controla detalladamente gastos clave: Insumos, Transporte, Trabajadores y Comida.',
            isDark: isDark,
          ),
          _buildFeatureRow(
            context,
            icon: Icons.leaderboard,
            text:
                'Genera estadísticas intuitivas para visualizar y optimizar tu rentabilidad agrícola.',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // Widget para las filas de características
  Widget _buildFeatureRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta para los creadores
  Widget _buildCreatorCard(
    BuildContext context, {
    required String name,
    required String email,
    required String phone,
    required String role,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark
            ? const Color.fromARGB(255, 2, 60, 2)
            : const Color.fromARGB(255, 235, 255, 235),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentGreen.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : primaryDark,
            ),
          ),
          Text(
            role,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? accentGreen.withOpacity(0.9)
                  : primaryDark.withOpacity(0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
          const Divider(height: 15, thickness: 0.5, color: Colors.white38),
          _buildContactRow(
            icon: Icons.email,
            value: email,
            color: isDark ? Colors.white70 : primaryDark,
            onTap: () => launchUrl(Uri.parse('mailto:$email')),
          ),
          const SizedBox(height: 8),
          _buildContactRow(
            icon: Icons.phone,
            value: phone,
            color: isDark ? Colors.white70 : primaryDark,
            onTap: () => launchUrl(Uri.parse('tel:$phone'.replaceAll(' ', ''))),
          ),
        ],
      ),
    );
  }

  // Fila para información de contacto
  Widget _buildContactRow({
    required IconData icon,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: accentGreen),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              decoration: TextDecoration.underline,
              decorationColor: accentGreen,
            ),
          ),
        ],
      ),
    );
  }
}
