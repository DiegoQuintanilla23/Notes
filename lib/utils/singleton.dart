class Singleton {
  static Singleton? _instance;

  Singleton._internal() {
    _instance = this;
  }

  factory Singleton() => _instance ?? Singleton._internal();

  String usuario = '';
  String correo = '';
  String contrasenia = '';
  String docIDuser = '';

  String datosusuario = '';

  bool isDarkMode = false;
  bool isSquare = false;
  bool isStroke = true;
  bool order = false;
}
