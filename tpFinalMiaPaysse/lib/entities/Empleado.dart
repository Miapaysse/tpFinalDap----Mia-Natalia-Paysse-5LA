class Empleado {
  final String nombre;
  final String area;
  final String apellido;
  final String poster;

  Empleado({
    required this.nombre,
    required this.area,
    required this.apellido,
    required this.poster,
  });

  factory Empleado.fromFirestore(Map<String, dynamic> data) {
    return Empleado(
      nombre: data['nombre'],
      apellido: data['apellido'],
      area: data['area'],
      poster: data['poster'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'area': area,
      'poster': poster,
    };
  }
}
