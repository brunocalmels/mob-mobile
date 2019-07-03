class Libro {
  final String nombre;
  final String nombreAutor;
  final String apellidoAutor;
  final int isbn;

  Libro({this.nombre, this.nombreAutor, this.apellidoAutor, this.isbn});

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      nombre: json['nombre'],
      nombreAutor: json['autor']['nombres'],
      apellidoAutor: json['autor']['apellidos'],
      isbn: json['isbn'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'autor': {
          'nombres': nombreAutor,
          'apellidos': apellidoAutor,
        },
        'isbn': isbn,
      };
}
