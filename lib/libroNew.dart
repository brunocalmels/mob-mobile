import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob/buscadorAutores.dart';
import 'package:mob/main.dart';
import 'package:mob/models/libro.dart';
import 'package:mob/models/autor.dart';
import 'package:mob/libroShow.dart';
import 'package:mob/config/my_globals.dart';

class LibroNew extends StatefulWidget {
  final Libro libro;

  const LibroNew({Key key, @required this.libro}) : super(key: key);

  @override
  _LibroNewState createState() => _LibroNewState();
}

class _LibroNewState extends State<LibroNew> {
  final String urlPost = MyGlobals.ROUTES['POST_LIBROS'];
  final String urlget = MyGlobals.ROUTES['GET_LIBROS'];
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  TextEditingController nombreController = new TextEditingController();
  Autor autor;

  _updateAutor(Autor item) {
    print('*** Setting state: $item ***');
    setState(() => autor = item);
    print('*** Autor: ${autor.id} ***');
  }

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
                decoration: new InputDecoration(
                  hasFloatingPlaceholder: true,
                  labelText: "Nombre del libro",
                  hintText: 'Cien años de soledad',
                ),
                controller: nombreController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingresá un nombre';
                  }
                },
              ),
              BuscadorAutores(
                parentAction: _updateAutor,
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
                        debugger();
                        print('SENDING NEW LIBRO WITH AUTOR: ${autor}');
                        final String body = jsonEncode({
                          ...nuevoLibro.toJson(),
                          'autor_id': autor.id,
                          // 'autor_id': 1,
                        });
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
