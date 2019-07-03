class Libro {
  final String nombre;
  final String nombreAutor;
  final String apellidoAutor;
  final int isbn;
  final bool nuevo;

  Libro(
      {this.nombre,
      this.nombreAutor,
      this.apellidoAutor,
      this.isbn,
      this.nuevo});

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      nombre: json['nombre'],
      nombreAutor: json['autor']['nombres'],
      apellidoAutor: json['autor']['apellidos'],
      isbn: json['isbn'],
      nuevo: false,
    );
  }

  factory Libro.nuevoIsbn(int isbn) {
    return Libro(
      nombre: '',
      nombreAutor: '',
      apellidoAutor: '',
      isbn: isbn,
      nuevo: true,
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
