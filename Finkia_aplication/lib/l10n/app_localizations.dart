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
