class Libro {
  String nombre;
  String nombreAutor;
  String apellidoAutor;
  int isbn;
  bool nuevo;
  int id;

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

  factory Libro.copy(Libro libro) {
    return Libro(
      nombre: libro.nombre,
      nombreAutor: libro.nombreAutor,
      apellidoAutor: libro.apellidoAutor,
      isbn: libro.isbn,
      nuevo: true,
      id: libro.id,
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
