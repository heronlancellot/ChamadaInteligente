import '../models/usuario.dart';

class UsuarioManager {
  late Usuario _usuario;

  Usuario get usuario => _usuario;

  // Singleton
  static final UsuarioManager _instance = UsuarioManager._internal();

  factory UsuarioManager() {
    return _instance;
  }

  UsuarioManager._internal();

  void setUsuario(Usuario usuario) {
    _usuario = usuario;
  }
}
