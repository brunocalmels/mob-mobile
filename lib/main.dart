import 'dart:async';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mob/models/libro.dart';
import 'package:mob/libroShow.dart';
import 'package:mob/libroNew.dart';
import 'package:mob/config/my_globals.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => new _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String barcode = "";
  Libro libro;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Organizer of Books'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: RaisedButton(
                  onPressed: barcodeScanning,
                  child: Text("Escanear código de barras")),
              padding: const EdgeInsets.all(8.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Text("Código de barras escaneado : " + barcode),
            if (libro != null)
              Baseline(
                baselineType: TextBaseline.ideographic,
                baseline: 60,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (libro != null)
                        ListTile(
                          leading: Icon(Icons.book),
                          title: Text(
                              libro.nuevo ? "Libro desconocido" : libro.nombre),
                          subtitle: Text(!libro.nuevo
                              ? 'Autor: ${libro?.nombreAutor} ${libro?.apellidoAutor}.'
                              : ''),
                        ),
                      if (libro != null && !libro.nuevo)
                        RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LibroShow(
                                      libro: libro,
                                    ),
                              ),
                            );
                          },
                          child: Text("Más info"),
                        ),
                      if (libro != null && libro.nuevo)
                        RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LibroNew(
                                      libro: libro,
                                    ),
                              ),
                            );
                          },
                          child: Text("Agregar"),
                        ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  // Hace un POST para buscar el barcode
  Future<Libro> fetchLibroByBarcode(String barcode) async {
    final String url = MyGlobals.ROUTES['POST_BARCODE'];
    // final String url = 'http://192.168.0.245:3000/libros/barcode';
    final String body = jsonEncode({'isbn': barcode});
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      return Libro.fromJson(json.decode(response.body));
    } else {
      return Libro.nuevoIsbn(int.parse(barcode));
      // throw Exception('Failed to load Libro');
    }
  }

// Method for scanning barcode....
  Future barcodeScanning() async {
//imageSelectorGallery();
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      Libro libro = await fetchLibroByBarcode(barcode);
      setState(() {
        this.libro = libro;
      });
      print('***** LibroJson: ${libro.toJson()}');
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}

// // Hace un GET para buscar el libro por ID
// Future getLibro() async {
//   final String url = 'http://192.168.0.245:3000/libros/1.json';
//   print('****** Fetching');
//   final response = await http.get(
//     url,
//     headers: {
//       'Content-type': 'application/json',
//       'Accept': 'application/json',
//     },
//   );
//   if (response.statusCode == 200) {
//     print('****** Libro: ${response.body}');
//     return Libro.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Failed to load Libro');
//   }
// }
