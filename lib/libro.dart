class Libro {
  final String nombre;
  final String nombreAutor;
  final String apellidoAutor;
  final int isbn;
  final bool nuevo;
  final int id;

  Libro(
      {this.nombre,
      this.nombreAutor,
      this.apellidoAutor,
      this.isbn,
      this.nuevo,
      this.id});

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      nombre: json['nombre'],
      nombreAutor: json['autor']['nombres'],
      apellidoAutor: json['autor']['apellidos'],
      isbn: json['isbn'],
      id: json['id'],
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
      id: 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'autor': {
          'nombres': nombreAutor,
          'apellidos': apellidoAutor,
        },
        'isbn': isbn,
        'id': id,
      };
}
