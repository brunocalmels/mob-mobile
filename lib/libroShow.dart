import 'package:flutter/material.dart';
import 'package:mob/models/libro.dart';

class LibroShow extends StatelessWidget {
  final Libro libro;

  LibroShow({Key key, @required this.libro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(libro.nombre),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Autor: ${libro?.nombreAutor} ${libro?.apellidoAutor}'),
            Text('ISBN: ${libro?.isbn}'),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // padding: EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
