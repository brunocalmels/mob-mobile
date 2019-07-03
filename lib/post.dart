class Post {
  final String nombre;
  final String autor;
  final int isbn;

  Post({this.nombre, this.autor, this.isbn});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      nombre: json['nombre'],
      autor: json['autor'],
      isbn: json['isbn'],
    );
  }
}
