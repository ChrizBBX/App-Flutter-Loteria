import 'dart:html';

import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:flutter/material.dart';
import '../widgets/num_pad.dart';

class Sale_Screen extends StatefulWidget {
  @override
  _Sale_ScreenState createState() => _Sale_ScreenState();
}

class _Sale_ScreenState extends State<Sale_Screen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _controlador = TextEditingController();
  List<Map<String, dynamic>> arreglonumeros = [];

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        'Venta',
        style: TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 18.0,
          color: ColorPalette.darkblueColorApp,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 16.0),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(
                labelText: 'Número',
                counterText: '',
                errorText: _validateInputNum(),
              ),
              onTap: () {
                _controlador.text = "Num";
              },
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: TextField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(
                labelText: 'Valor',
                counterText: '',
                errorText: _validateInputPrec(),
              ),
              onTap: () {
                _controlador.text = "Prec";
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 20.0),
      NumPad(
        onKeyPressed: _updateTextField,
      ),
      SizedBox(height: 20.0),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 40.0,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                '#',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
              ),
            ),
            DataColumn(
              label: Text(
                'Valor',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
              ),
            ),
            DataColumn(
              label: Text(
                'Editar',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
              ),
            ),
            DataColumn(
              label: Text(
                'Eliminar',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
              ),
            ),
          ],
          rows: _buildDataRows(),
        ),
      )
    ]);
  }

  String? _validateInputNum() {
    if (_numberController.text.isNotEmpty) {
      int? number = int.tryParse(_numberController.text);
      if (number == null) {
        return 'Ingrese un número válido';
      } else if (number < 0) {
        return 'Ingrese un número mayor o igual a 0';
      }
    } else {
      return 'Campo Requerido';
    }
    return null;
  }

  String? _validateInputPrec() {
    if (_precioController.text.isNotEmpty) {
      int? number = int.tryParse(_precioController.text);
      if (number == null) {
        return 'Ingrese un número válido';
      } else if (number < 0) {
        return 'Ingrese un número mayor o igual a 0';
      }
    } else {
      return 'Campo Requerido';
    }
    return null;
  }

  void _updateTextField(String value) {
    setState(() {
      if (_controlador.text == "Num") {
        if (value == "C") {
          _numberController.text = "";
        } else if (value == "Intro") {
          _addArreglo();
        } else {
          if (_numberController.text.length < 2) {
            _numberController.text += value;
          }
        }
      } else if (_controlador.text == "Prec") {
        if (value == "C") {
          _precioController.text = "";
        } else if (value == "Intro") {
          _addArreglo();
        } else {
          _precioController.text += value;
        }
      } else {}
    });
  }

  void _addArreglo() {
    if (_precioController.text != "" && _numberController.text != "") {
      arreglonumeros.add({
        "numeroventa": _numberController.text,
        "valor": _precioController.text,
      });
      _numberController.text = "";
      _precioController.text = "";

      print(arreglonumeros);
    } else {
      CherryToast.warning(
        title: const Text('Ambos campos deben ser llenados',
            style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
            textAlign: TextAlign.start),
        borderRadius: 5,
      ).show(context);
    }
  }

  //rows para el datatable
  List<DataRow> _buildDataRows() {
    return arreglonumeros.map((numero) {
      return DataRow(
        cells: [
          DataCell(Text(numero['numeroventa']!.toString())),
          DataCell(Text('L.' + numero['valor']!.toString())),
          DataCell(IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editRow(numero);
            },
          )),
          DataCell(IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteRow(numero);
            },
          )),
        ],
      );
    }).toList();
  }

void _editRow(Map<String, dynamic> numero) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController _editedNumberController =
          TextEditingController(text: numero['numeroventa']!.toString());
      TextEditingController _editedPrecioController =
          TextEditingController(text: numero['valor']!.toString());

      return AlertDialog(
        title: Text('Editar Registro'),
         contentPadding: EdgeInsets.all(10.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           TextField(
              controller: _editedNumberController,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(
                labelText: 'Número',
                counterText: '',
              ),
            ),
            TextField(
              controller: _editedPrecioController,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(
                labelText: 'Valor',
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                numero['numeroventa'] = _editedNumberController.text;
                numero['valor'] = _editedPrecioController.text;
              });

              Navigator.of(context).pop();
            },
            child: Text('Guardar'),
          ),
        ],
      );
    },
  );
}

void _deleteRow(Map<String, dynamic> numero) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Eliminar Registro'),
        content: Text('¿Estás seguro de que quieres eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                arreglonumeros.remove(numero);
              });

              Navigator.of(context).pop();
            },
            child: Text('Eliminar'),
          ),
        ],
      );
    },
  );
}
 
}
