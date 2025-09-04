class MaestroTipo {
  final int id;
  final String nombre;

  MaestroTipo({required this.id, required this.nombre});

  factory MaestroTipo.fromJson(Map<String, dynamic> json) {
    return MaestroTipo(id: json['MaeestroID'], nombre: json['nombre']);
  }
}
