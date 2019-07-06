import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './main.dart';
import './libro.dart';
import './libroShow.dart';

class LibroNew extends StatefulWidget {
  final Libro libro;

  const LibroNew({Key key, @required this.libro}) : super(key: key);

  @override
  _LibroNewState createState() => _LibroNewState();
}

class _LibroNewState extends State<LibroNew> {
  final String urlPost = 'http://192.168.0.245:3000/libros/';
  final String urlget = 'http://192.168.0.245:3000/libros/';
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  TextEditingController nombreController = new TextEditingController();

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
                controller: nombreController,
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
                        scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Guardando libro')));
                        Libro nuevoLibro = Libro.fromJson({
                          ...widget.libro.toJson(),
                          'nombre': nombreController.text,
                        });
                        final String body = jsonEncode({
                          ...nuevoLibro.toJson(),
                          'autor_id': 1,
                        });
                        print('*** Posting: $body');
                        final responseNew = await http.post(
                          urlPost,
                          headers: {
                            'Content-type': 'application/json',
                            'Accept': 'application/json',
                          },
                          body: body,
                        );
                        if (responseNew.statusCode == 201) {
                          scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Libro guardado')));

                          final responseShow = await http.get(
                            jsonDecode(responseNew.body)['url'],
                          );
                          if (responseShow.statusCode == 200) {
                            Libro libroGuardado =
                                Libro.fromJson(json.decode(responseShow.body));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LibroShow(
                                      libro: libroGuardado,
                                    ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHome()),
                            );
                          }
                        } else {
                          scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Error guardando libro')));
                        }
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
