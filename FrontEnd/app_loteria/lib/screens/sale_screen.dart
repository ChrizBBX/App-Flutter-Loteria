import 'dart:convert';
import 'dart:html';
import 'package:app_loteria/models/Venta.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';
import '../widgets/num_pad.dart';
import 'package:http/http.dart' as http;

class Sale_Screen extends StatefulWidget {
  @override
  _Sale_ScreenState createState() => _Sale_ScreenState();
}

class _Sale_ScreenState extends State<Sale_Screen> {
  int selectedPerson = 0;
  int selectedPaymentMethod = 0;
  List<Map<String, dynamic>> detalles = [];
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _controlador = TextEditingController();

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecciona Persona'),
            SizedBox(height: 8.0),
            DropdownButton<int>(
              value: selectedPerson,
              onChanged: (value) {
                setState(() {
                  selectedPerson = value ?? 0;
                });
              },
              items: [
                DropdownMenuItem<int>(
                  value:
                      0, // Puedes asignar un valor numérico que represente cada opción
                  child: Text('Seleecione'),
                  enabled: false,
                ),
                DropdownMenuItem(
                  value: 1, // Reemplaza con el valor que desees para Persona 1
                  child: Text('Persona 1'),
                ),
                DropdownMenuItem(
                  value: 2, // Reemplaza con el valor que desees para Persona 2
                  child: Text('Persona 2'),
                ),
                // Agrega más opciones según tus necesidades
              ],
              isExpanded: true,
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecciona Método de Pago'),
            SizedBox(height: 8.0),
            DropdownButton<int>(
              value: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value ?? 0;
                });
              },
              items: [
                DropdownMenuItem<int>(
                  value:
                      0, // Puedes asignar un valor numérico que represente cada opción
                  child: Text('Seleecione'),
                  enabled: false,
                ),
                DropdownMenuItem<int>(
                  value:
                      1, // Puedes asignar un valor numérico que represente cada opción
                  child: Text('Efectivo'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Tarjeta de Crédito'),
                ),
                // Agrega más opciones según tus necesidades
              ],
              isExpanded: true,
            ),
          ],
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
        ),
        SizedBox(height: 16.0),
        if (selectedPerson != 0 &&
            selectedPaymentMethod != 0 &&
            detalles.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              sendData(
                  context, selectedPerson, selectedPaymentMethod, detalles);
            },
            child: Text('Realizar Venta'),
          ),
      ],
    );
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
      } else {
        CherryToast.warning(title: Text("Campos Vacios"));
      }
    });
  }

  void _addArreglo() {
    if (_precioController.text != "" && _numberController.text != "") {
      detalles.add({
        "NumeroId": int.parse(_numberController.text),
        "valor": int.parse(_precioController.text),
      });
      _numberController.text = "";
      _precioController.text = "";

      print(detalles);
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
    return detalles.map((numero) {
      return DataRow(
        cells: [
          DataCell(Text(numero['NumeroId']!.toString())),
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
            TextEditingController(text: numero['NumeroId']!.toString());
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
                  numero['NumeroId'] = int.parse(_editedNumberController.text);
                  numero['valor'] = int.parse(_editedPrecioController.text);
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
                  detalles.remove(numero);
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

  Future<void> sendData(BuildContext context, int personaId, int metodoPagoId,
      List<Map<String, dynamic>> detalles) async {
    try {
      int usuarioId = 0;
      String fechaVenta = DateTime.now().toUtc().toIso8601String();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        usuarioId = prefs.getInt('usuarioId') ?? 0;
      });

      List<VentaJsonDetalle> ventaDetalles = detalles
          .map((detalle) => VentaJsonDetalle(
                numeroId: detalle['NumeroId'],
                valor: detalle['valor'],
              ))
          .toList();

      VentaJsonEncabezado ventaJsonEncabezado = VentaJsonEncabezado(
        personaId: personaId,
        usuarioId: usuarioId,
        metodoPagoId: metodoPagoId,
        fechaVenta: fechaVenta,
        usuarioCreacion: usuarioId,
        ventaDetalles: ventaDetalles,
      );

      final peticionJson = jsonEncode(ventaJsonEncabezado);
      final response = await http.post(
        Uri.parse('${apiUrl}Ventas/AgregarVenta'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: peticionJson,
      );

      final decodedJson = jsonDecode(response.body);
      final respuesta = decodedJson["Message"];
      if (respuesta.toString().contains("La venta")) {
        CherryToast.success(title: respuesta);
        selectedPerson = 0;
        selectedPaymentMethod = 0;
        _numberController.text = '';
        _precioController.text = '';
        _controlador.text = '';
        detalles = [];
      } else if (respuesta.toString().contains("El numero")) {
        CherryToast.warning(title: respuesta);
      } else if (respuesta.toString().contains("Limite")) {
        CherryToast.warning(title: respuesta);
      }
      else{
        CherryToast.warning(title: Text("Ha ocurrido un error Inesperado"));
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
