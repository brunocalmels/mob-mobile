import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:mob/models/autor.dart';

class Autocompletar extends StatefulWidget {
  final List<Autor> sugerencias;
  final Function setItem;

  Autocompletar({this.sugerencias, this.setItem});

  @override
  _AutocompletarState createState() => _AutocompletarState();
}

class _AutocompletarState extends State<Autocompletar> {
  GlobalKey<AutoCompleteTextFieldState<Autor>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return searchTextField = AutoCompleteTextField<Autor>(
      decoration: new InputDecoration(
        hasFloatingPlaceholder: true,
        labelText: "Autor",
        hintText: 'García Márquez',
      ),
      itemBuilder: (BuildContext context, Autor item) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.nombres + ' ' + item.apellidos,
              ),
            ],
          ),
        );
      },
      itemFilter: (Autor item, String query) {
        return (item.apellidos.toLowerCase().contains(query.toLowerCase()) ||
            item.nombres.toLowerCase().contains(query.toLowerCase()));
      },
      itemSorter: (Autor a, Autor b) {
        return a.apellidos.compareTo(b.apellidos);
      },
      clearOnSubmit: false,
      itemSubmitted: (Autor item) {
        setState(() => searchTextField.textField.controller.text =
            item.nombres + ' ' + item.apellidos);
        widget.setItem(item);
      },
      key: key,
      suggestions: widget.sugerencias,
    );
  }
}
