import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @nombreFinca.
  ///
  /// In en, this message translates to:
  /// **'Farm name.'**
  String get nombreFinca;

  /// No description provided for @misFincas.
  ///
  /// In en, this message translates to:
  /// **'My farms'**
  String get misFincas;

  /// No description provided for @sinRegistro.
  ///
  /// In en, this message translates to:
  /// **'You have no registered farms yet.'**
  String get sinRegistro;

  /// No description provided for @primeraFinca.
  ///
  /// In en, this message translates to:
  /// **'Add your first farm from the start 🌱'**
  String get primeraFinca;

  /// No description provided for @nombre.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nombre;

  /// No description provided for @sinNombre.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get sinNombre;

  /// No description provided for @ubicacion.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get ubicacion;

  /// No description provided for @desconocida.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get desconocida;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @actividad.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get actividad;

  /// No description provided for @contacto.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contacto;

  /// No description provided for @administrador.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrador;

  /// No description provided for @noEspecificado.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get noEspecificado;

  /// No description provided for @cerrado.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get cerrado;

  /// No description provided for @registrarFinca.
  ///
  /// In en, this message translates to:
  /// **'Register farm'**
  String get registrarFinca;

  /// No description provided for @ingreseNombre.
  ///
  /// In en, this message translates to:
  /// **'Enter the name'**
  String get ingreseNombre;

  /// No description provided for @areaFinca.
  ///
  /// In en, this message translates to:
  /// **'Farm area (ha)'**
  String get areaFinca;

  /// No description provided for @ingreseAreaFinca.
  ///
  /// In en, this message translates to:
  /// **'Enter the area'**
  String get ingreseAreaFinca;

  /// No description provided for @actividadAgricola.
  ///
  /// In en, this message translates to:
  /// **'Agricultural activity (e.g., coffee, potato, corn...)'**
  String get actividadAgricola;

  /// No description provided for @describaActividad.
  ///
  /// In en, this message translates to:
  /// **'Describe the activity'**
  String get describaActividad;

  /// No description provided for @ubicacionFinca.
  ///
  /// In en, this message translates to:
  /// **'Farm location'**
  String get ubicacionFinca;

  /// No description provided for @contactoAdministrador.
  ///
  /// In en, this message translates to:
  /// **'Administrator contact (optional)'**
  String get contactoAdministrador;

  /// No description provided for @registrar.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registrar;

  /// No description provided for @completarUbicacion.
  ///
  /// In en, this message translates to:
  /// **'Please complete the location 🌍'**
  String get completarUbicacion;

  /// No description provided for @fincaRegistrada.
  ///
  /// In en, this message translates to:
  /// **'Farm successfully registered 🌱'**
  String get fincaRegistrada;

  /// No description provided for @notificaciones.
  ///
  /// In en, this message translates to:
  /// **'🔔 Notifications'**
  String get notificaciones;

  /// No description provided for @acercaDe.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get acercaDe;

  /// No description provided for @configuracion.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get configuracion;

  /// No description provided for @salir.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get salir;

  /// No description provided for @cuenta.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get cuenta;

  /// No description provided for @completarCampos.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get completarCampos;

  /// No description provided for @sesionExitosa.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get sesionExitosa;

  /// No description provided for @correoNoEncontrado.
  ///
  /// In en, this message translates to:
  /// **'No user found with that email.'**
  String get correoNoEncontrado;

  /// No description provided for @contrasenaIncorrecta.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get contrasenaIncorrecta;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @iniciarSesion.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get iniciarSesion;

  /// No description provided for @correoElectronico.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get correoElectronico;

  /// No description provided for @contrasena.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get contrasena;

  /// No description provided for @ingresar.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get ingresar;

  /// No description provided for @noTienesCuenta.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get noTienesCuenta;

  /// No description provided for @contrasenasNoCoinciden.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get contrasenasNoCoinciden;

  /// No description provided for @camposObligatorios.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required fields'**
  String get camposObligatorios;

  /// No description provided for @registroExitoso.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registroExitoso;

  /// No description provided for @crearCuenta.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get crearCuenta;

  /// No description provided for @confirmarContrasena.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmarContrasena;

  /// No description provided for @registrarse.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registrarse;

  /// No description provided for @yaTienesCuenta.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get yaTienesCuenta;

  /// No description provided for @agregarFinca.
  ///
  /// In en, this message translates to:
  /// **'Add Farm'**
  String get agregarFinca;

  /// No description provided for @pais.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get pais;

  /// No description provided for @ciudad.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get ciudad;

  /// No description provided for @departamento.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get departamento;

  /// No description provided for @historia_origen.
  ///
  /// In en, this message translates to:
  /// **'Our History and Origin'**
  String get historia_origen;

  /// No description provided for @finkia_aplicacion.
  ///
  /// In en, this message translates to:
  /// **'Finkia is an application developed in'**
  String get finkia_aplicacion;

  /// No description provided for @nacemos_de.
  ///
  /// In en, this message translates to:
  /// **'We are born from local knowledge and the firm conviction to boost the agrarian economy of our region.'**
  String get nacemos_de;

  /// No description provided for @equipo.
  ///
  /// In en, this message translates to:
  /// **'Founding Team'**
  String get equipo;

  /// No description provided for @desarrollador.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get desarrollador;

  /// No description provided for @finkia_nace.
  ///
  /// In en, this message translates to:
  /// **'Finkia is born as a digital solution, created thinking about the real needs of the Colombian farmer, with an initial specialization in the coffee sector.'**
  String get finkia_nace;

  /// No description provided for @permite_registrar.
  ///
  /// In en, this message translates to:
  /// **'Allows registering one or more farms, organizing your operation by property.'**
  String get permite_registrar;

  /// No description provided for @controla_deta.
  ///
  /// In en, this message translates to:
  /// **'Detailedly controls key expenses: Supplies, Transport, Workers, and Food.'**
  String get controla_deta;

  /// No description provided for @genera_esta.
  ///
  /// In en, this message translates to:
  /// **'Generates intuitive statistics to visualize and optimize your agricultural profitability.'**
  String get genera_esta;

  /// No description provided for @hola_ia.
  ///
  /// In en, this message translates to:
  /// **'Hello! I am your virtual Agricultural Advisor. Ask me anything about crops, weather, or any topic.'**
  String get hola_ia;

  /// No description provided for @error_ia.
  ///
  /// In en, this message translates to:
  /// **'ERROR: The Gemini API key is not configured. Please add it to the code to make real queries.'**
  String get error_ia;

  /// No description provided for @actua_como.
  ///
  /// In en, this message translates to:
  /// **'Act as a friendly and very knowledgeable agricultural advisor.'**
  String get actua_como;

  /// No description provided for @lo_siento.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I could not get a response.'**
  String get lo_siento;

  /// No description provided for @ia_escribiendo.
  ///
  /// In en, this message translates to:
  /// **'AI Advisor writing...'**
  String get ia_escribiendo;

  /// No description provided for @pregunta_ia.
  ///
  /// In en, this message translates to:
  /// **'Ask the AI Advisor...'**
  String get pregunta_ia;

  /// No description provided for @carne.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get carne;

  /// No description provided for @verduras.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get verduras;

  /// No description provided for @grano.
  ///
  /// In en, this message translates to:
  /// **'Grain'**
  String get grano;

  /// No description provided for @frutas.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get frutas;

  /// No description provided for @otros.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get otros;

  /// No description provided for @unidad.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unidad;

  /// No description provided for @gasto_comida_guardado.
  ///
  /// In en, this message translates to:
  /// **'Food expense saved'**
  String get gasto_comida_guardado;

  /// No description provided for @error_comida.
  ///
  /// In en, this message translates to:
  /// **'Error saving expense:'**
  String get error_comida;

  /// No description provided for @gasto_comida.
  ///
  /// In en, this message translates to:
  /// **'Food Expense'**
  String get gasto_comida;

  /// No description provided for @detalle.
  ///
  /// In en, this message translates to:
  /// **'Detail (optional)'**
  String get detalle;

  /// No description provided for @descripcion_alimento.
  ///
  /// In en, this message translates to:
  /// **'Describe the food or expense'**
  String get descripcion_alimento;

  /// No description provided for @detalle_op.
  ///
  /// In en, this message translates to:
  /// **'Optional detail (e.g., Beef, Tomato...)'**
  String get detalle_op;

  /// No description provided for @describe_descripcion.
  ///
  /// In en, this message translates to:
  /// **'Write a description'**
  String get describe_descripcion;

  /// No description provided for @cantidad_precio.
  ///
  /// In en, this message translates to:
  /// **'Quantity and Price'**
  String get cantidad_precio;

  /// No description provided for @cantidad.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get cantidad;

  /// No description provided for @ingresa_cant.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get ingresa_cant;

  /// No description provided for @num_invalido.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get num_invalido;

  /// No description provided for @ingresa_precio.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get ingresa_precio;

  /// No description provided for @fecha.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fecha;

  /// No description provided for @notas.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notas;

  /// No description provided for @guardar_gasto.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get guardar_gasto;

  /// No description provided for @comida.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get comida;

  /// No description provided for @cambiar_finca.
  ///
  /// In en, this message translates to:
  /// **'Change farm'**
  String get cambiar_finca;

  /// No description provided for @gastos_generales.
  ///
  /// In en, this message translates to:
  /// **'General expenses'**
  String get gastos_generales;

  /// No description provided for @total_general.
  ///
  /// In en, this message translates to:
  /// **'General total'**
  String get total_general;

  /// No description provided for @trabajadores.
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get trabajadores;

  /// No description provided for @insumos.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get insumos;

  /// No description provided for @transporte.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transporte;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
