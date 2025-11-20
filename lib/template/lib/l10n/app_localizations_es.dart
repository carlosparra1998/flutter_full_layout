// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get email => 'Email';

  @override
  String get password => 'Contraseña';

  @override
  String get access => 'Acceder';

  @override
  String get login => 'Inicio de sesión';

  @override
  String get home => 'Home';

  @override
  String get loggedIn => 'Sesión iniciada';

  @override
  String get emailRequired => 'Debes introducir un email';

  @override
  String get passwordRequired => 'Debes introducir una contraseña';

  @override
  String get serverError => 'Error en el servidor';
}
