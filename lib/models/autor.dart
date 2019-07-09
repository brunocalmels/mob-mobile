class Autor {
  String nombres;
  String apellidos;
  int id;

  Autor({
    this.nombres,
    this.apellidos,
    this.id,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'id': id,
    };
  }
}
