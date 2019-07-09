import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob/config/my_globals.dart';
import 'package:mob/shared/autocompletar.dart';
import 'package:mob/models/autor.dart';

class BuscadorAutores extends StatefulWidget {
  final Function parentAction;

  const BuscadorAutores({Key key, this.parentAction}) : super(key: key);

  @override
  _BuscadorAutoresState createState() => _BuscadorAutoresState();
}

class _BuscadorAutoresState extends State<BuscadorAutores> {
  List<Autor> sugerencias = [];
  // List<Partido> partidos = [];
  Autor autor;

  Future _getAutores() async {
    // String token =
    //     Provider.of<MyState>(context, listen: false).innerState['token'];
    final response = await http.get(
      MyGlobals.ROUTES['GET_AUTORES'],
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );

    List lista = json.decode(response.body);
    List<Autor> listaAutores = [];
    lista.forEach((u) {
      listaAutores.add(
        Autor(
          nombres: u['nombres'],
          apellidos: u['apellidos'],
          id: u['id'],
        ),
      );
    });
    setState(() {
      sugerencias = listaAutores;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAutores();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: sugerencias.length > 0
              ? Autocompletar(
                  sugerencias: sugerencias,
                  setItem: widget.parentAction,
                )
              : SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(),
                ),
        ),
        // partidos.length == 0
        //     ? Center(
        //         child: Padding(
        //           padding: const EdgeInsets.all(10),
        //           child: Text('No hay partidos'),
        //         ),
        //       )
        //     : ListaPartidos(partidos: partidos),
      ],
    );
  }
}
