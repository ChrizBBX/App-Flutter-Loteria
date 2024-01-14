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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        TextField(
          controller: _numberController,
          keyboardType: TextInputType.number,
          maxLength: 2,
          decoration: InputDecoration(
            labelText: 'Número',
            counterText: '',
            errorText: _validateInput(),
          ),
          onTap: () {
            _controlador.text = "Num";
          },
        ),
        TextField(
          controller: _precioController,
          keyboardType: TextInputType.number,
          maxLength: 2,
          decoration: InputDecoration(
            labelText: 'L.',
            counterText: '',
            errorText: _validateInput(),
          ),
          onTap: () {
            _controlador.text = "Prec";
          },
        ),
        SizedBox(height: 20.0),
        NumPad(
          onKeyPressed: _updateTextField,
        ),
        SizedBox(height: 20.0),
        DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text(
                  '#',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Valor',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                ),
              ),
            ),
          ],
          rows: _buildDataRows(),
        )
      ],
    );
  }

  String? _validateInput() {
    if (_numberController.text.isNotEmpty) {
      int? number = int.tryParse(_numberController.text);
      if (number == null) {
        return 'Ingrese un número válido';
      } else if (number < 0) {
        return 'Ingrese un número mayor o igual a 0';
      }
    } else {
      return 'El campo no puede estar vacío';
    }
    return null;
  }

  void _updateTextField(String value) {
    setState(() {
      if (_controlador.text == "Num") {
        if (value == "C") {
          _numberController.text = "";
        } else if (value == "OK") {
          _addArreglo();
        } else {
          if (_numberController.text.length < 2) {
            _numberController.text += value;
          }
        }
      } else if (_controlador.text == "Prec") {
        if (value == "C") {
          _precioController.text = "";
        } else if (value == "OK") {
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
          DataCell(Text(numero['valor']!.toString())),
        ],
      );
    }).toList();
  }
}
