import 'dart:async';
// import 'dart:io';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import './libro.dart';
// import 'package:image_picker/image_picker.dart';

// TODO: Actualizar vista del libro en función de la data devuelta

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  // File galleryFile;
//   imageSelectorGallery() async {
//     galleryFile = await ImagePicker.pickImage(
//       source: ImageSource.gallery,
// // maxHeight: 50.0,
// // maxWidth: 50.0,
//     );
//     print("You selected gallery image : " + galleryFile.path);
//     setState(() {});
//   }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Mobile Organizer of Books'),
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new RaisedButton(
                      onPressed: barcodeScanning,
                      child: new Text("Escanear código de barras")),
                  padding: const EdgeInsets.all(8.0),
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                new Text("Código de barras escaneado : " + barcode),
                // Container(
                //   child: RaisedButton(
                //       onPressed: getLibro, child: Text('Buscar libro 1')),
                // ),
                // displayImage(),
              ],
            ),
          )),
    );
  }

  // Widget displayImage() {
  //   return new SizedBox(
  //     height: 300.0,
  //     width: 400.0,
  //     child: galleryFile == null
  //         ? new Text('Sorry nothing to display')
  //         : new Image.file(galleryFile),
  //   );
  // }

  // Hace un GET para buscar el libro por ID
  Future getLibro() async {
    final String url = 'http://192.168.0.245:3000/libros/1.json';
    print('****** Fetching');
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('****** Libro: ${response.body}');
      return Libro.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load Libro');
    }
  }

  // Hace un POST para buscar el barcode
  Future<Libro> fetchLibroByBarcode(String barcode) async {
    final String url = 'http://192.168.0.245:3000/libros/barcode';
    final String body = jsonEncode({'isbn': barcode});
    print('**** Fetching');
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('Libro: ${response.body}');
      return Libro.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load Libro');
    }
  }

// Method for scanning barcode....
  Future barcodeScanning() async {
//imageSelectorGallery();
    try {
      String barcode = await BarcodeScanner.scan();
      print('***** Barcode: $barcode');
      setState(() => this.barcode = barcode);
      Libro libro = await fetchLibroByBarcode(barcode);
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
