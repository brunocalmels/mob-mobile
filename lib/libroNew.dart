import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './libro.dart';

// class LibroNew extends StatelessWidget {
//   final Libro libro;

//   LibroNew({Key key, @required this.libro}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(libro.nombre),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             Text('Autor: ${libro?.nombreAutor} ${libro?.apellidoAutor}'),
//             Text('ISBN: ${libro?.isbn}'),
//           ],
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           // padding: EdgeInsets.all(16.0),
//         ),
//       ),
//     );
//   }
// }

class LibroNew extends StatefulWidget {
  final Libro libro;

  const LibroNew({Key key, @required this.libro}) : super(key: key);

  @override
  _LibroNewState createState() => _LibroNewState();
}

class _LibroNewState extends State<LibroNew> {
  final String url = 'http://192.168.0.245:3000/libros/';
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Agregar nuevo libro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingresá un nombre';
                  }
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        // Process data.
                        scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                        final String body = jsonEncode({
                          'isbn': widget.libro.isbn,
                          'autor_id': 1,
                          // TODO: reemplazar autor
                          'nombre': 'Libertad libertad libertad',
                        });
                        print('*** Posting: $body');
                        final response = await http.post(
                          url,
                          headers: {
                            'Content-type': 'application/json',
                            'Accept': 'application/json',
                          },
                          body: body,
                        );
                        print('Response: $response.body');
                      }
                    },
                    child: Text('Guardar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
