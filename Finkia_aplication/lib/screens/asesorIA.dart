import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrou_aplication/utils/localization_extension.dart';

// ======================= PALETA DE COLORES (Reutilizando tus constantes) =======================
const Color darkBg = Color.fromARGB(255, 1, 34, 2);
const Color primaryDark = Color.fromARGB(255, 2, 78, 7);
const Color primaryLight = Color.fromARGB(210, 2, 78, 7);
const Color accentGreen = Color.fromARGB(255, 164, 231, 38);
const Color userBubbleColor = Color.fromARGB(255, 230, 255, 230);
const Color aiBubbleColor = Colors.white;
// ===================================================================================================

// Clase simple para representar un mensaje
class _Message {
  final String text;
  final bool isUser; // true para usuario, false para IA
  _Message({required this.text, required this.isUser});
}

class AsesorAgricolaPage extends StatefulWidget {
  const AsesorAgricolaPage({super.key});

  @override
  State<AsesorAgricolaPage> createState() => _AsesorAgricolaPageState();
}

class _AsesorAgricolaPageState extends State<AsesorAgricolaPage> {
  // ⚠️ Reemplaza esta línea con tu CLAVE de API de Gemini ⚠️
  // No la compartas ni la subas a repositorios públicos.
  static const String _apiKey = 'AIzaSyBYaPa7E6JGLeD0QY12DHHXVwtZ9tQW8Mo';

  final TextEditingController _textController = TextEditingController();
  final List<_Message> _messages = [];
  bool _isLoading = false; // Estado para el indicador "IA escribiendo..."

  @override
  void initState() {
    super.initState();
    _messages.add(
      _Message(
        text:
            '¡Hola! Soy tu Asesor Agrícola virtual. Pregúntame lo que desees sobre cultivos, clima, o cualquier tema.',
        isUser: false,
      ),
    );
  }

  // ================================================================
  // FUNCIÓN CLAVE: ENVÍO DE CONSULTA A LA API DE GEMINI
  // ================================================================
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    _textController.clear();
    if (text.isEmpty || _isLoading) return;

    // 1. Añadir el mensaje del usuario a la lista
    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _isLoading = true; // Mostrar indicador de carga
    });

    if (_apiKey.isEmpty) {
      // Si la clave no está configurada, devolver un error local
      setState(() {
        _messages.add(
          _Message(
            text:
                'ERROR: La clave de API de Gemini no está configurada. Por favor, añádela al código para hacer consultas reales.',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
      return;
    }

    // 2. Preparar la solicitud HTTP a la API de Gemini
    const String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent';

    final headers = {
      'Content-Type': 'application/json',
      // No necesitas el encabezado Authorization si usas la clave en la URL
    };

    final payload = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': text},
          ],
        },
      ],
      // Instrucción de sistema ligera para guiar el tono
      'systemInstruction': {
        'parts': [
          {'text': 'Actúa como un asesor agrícola amigable y muy conocedor.'},
        ],
      },
    });

    try {
      // 3. Enviar la solicitud POST
      final response = await http.post(
        Uri.parse('$apiUrl?key=$_apiKey'),
        headers: headers,
        body: payload,
      );

      // 4. Procesar la respuesta
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        String aiResponse =
            jsonResponse['candidates'][0]['content']['parts'][0]['text'] ??
            'Lo siento, no pude obtener una respuesta.';

        // 5. Añadir la respuesta de la IA
        setState(() {
          _messages.add(_Message(text: aiResponse, isUser: false));
          _isLoading = false;
        });
      } else {
        // Manejar errores del servidor o API
        setState(() {
          _messages.add(
            _Message(
              text:
                  'Error de conexión (${response.statusCode}): No se pudo contactar al Asesor IA. Revisa tu clave API y conexión a internet.',
              isUser: false,
            ),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      // Manejar errores de red
      setState(() {
        _messages.add(
          _Message(
            text:
                'Error de red: Parece que no hay conexión a internet o la API Key es incorrecta. ($e)',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    }
  }

  // ================================================================
  // PINTAR BURBUJAS DE CHAT
  // ================================================================
  Widget _buildMessage(BuildContext context, _Message message) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColor = message.isUser
        ? (isDark ? userBubbleColor.withOpacity(0.9) : userBubbleColor)
        : (isDark ? primaryDark.withOpacity(0.9) : aiBubbleColor);
    final textColor = message.isUser
        ? Colors.black87
        : (isDark ? Colors.white : Colors.black87);
    final alignment = message.isUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
                bottomLeft: message.isUser
                    ? const Radius.circular(16.0)
                    : const Radius.circular(4.0),
                bottomRight: message.isUser
                    ? const Radius.circular(4.0)
                    : const Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 15.0, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? darkBg : const Color(0xFFF0F4F8);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                  'Asesor IA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ================= 3. CUERPO DEL CHAT =================
          Padding(
            padding: const EdgeInsets.only(top: 120, bottom: 80),
            child: ListView.builder(
              reverse: true, // Para que la lista crezca de abajo hacia arriba
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0 && _isLoading) {
                  // Indicador de "Escribiendo..."
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: aiBubbleColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Asesor IA escribiendo...',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                final message =
                    _messages[_messages.length -
                        1 -
                        index +
                        (_isLoading ? 1 : 0)];
                return _buildMessage(context, message);
              },
            ),
          ),

          // ================= 4. CAMPO DE ENTRADA (BOTTOM) =================
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: isDark ? primaryDark : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Pregunta al Asesor IA...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: accentGreen),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
