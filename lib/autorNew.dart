import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mob/config/my_globals.dart';
import 'package:mob/models/autor.dart';

class AutorNew extends StatefulWidget {
  // final Autor autor;

  const AutorNew({Key key}) : super(key: key);

  @override
  _AutorNewState createState() => _AutorNewState();
}

class _AutorNewState extends State<AutorNew> {
  final String urlPost = MyGlobals.ROUTES['POST_AUTORES'];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nombresController = new TextEditingController();
  TextEditingController apellidosController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Nuevo autor"),
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
                  labelText: "Nombres",
                  hintText: 'Jorge Luis',
                ),
                controller: nombresController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingresá un nombre';
                  }
                },
              ),
              TextFormField(
                decoration: new InputDecoration(
                  hasFloatingPlaceholder: true,
                  labelText: "Apellidos",
                  hintText: 'Borges',
                ),
                controller: apellidosController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingresá un apellido';
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
                          SnackBar(
                            content: Text('Guardando autor'),
                          ),
                        );
                        Autor nuevoAutor = Autor.fromJson({
                          'nombres': nombresController.text,
                          'apellidos': apellidosController.text,
                        });
                        final String body = jsonEncode(nuevoAutor.toJson());
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
                              SnackBar(content: Text('Autor guardado')));
                          final responseShow = await http.get(
                            jsonDecode(responseNew.body)['url'],
                          );
                          if (responseShow.statusCode == 200) {
                            Autor autorGuardado =
                                Autor.fromJson(json.decode(responseShow.body));
                            Navigator.pop(context, autorGuardado);
                          }
                        } else {
                          scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Error guardando libro')));
                        }
                      } else {
                        scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Error guardando libro')));
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
