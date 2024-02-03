import 'dart:convert';

import 'package:app_loteria/models/Venta.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';
import '../widgets/num_pad.dart';
import 'package:http/http.dart' as http;

class SaleScreen extends StatefulWidget {
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class Persona {
  final int personaId;
  final String nombres;
  final String? apellidos;
  final String? identidad;

  Persona({
    required this.personaId,
    required this.nombres,
    this.apellidos,
    this.identidad,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      personaId: json['personaId'] as int,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String?,
      identidad: json['identidad'] as String?,
    );
  }

  // Cambia el nombre de las propiedades
  int get id => personaId;
  String get descripcion => '$nombres ${apellidos ?? ''}';

  Map<String, dynamic> toJson() {
    return {
      "personaId": personaId,
      "nombres": nombres,
      "apellidos": apellidos,
      "identidad": identidad,
    };
  }
}

class MetodoPago {
  final int metodoPagoId;
  final String descripcion;

  MetodoPago({
    required this.metodoPagoId,
    required this.descripcion,
  });

  factory MetodoPago.fromJson(Map<String, dynamic> json) {
    return MetodoPago(
      metodoPagoId: json['metodoPagoId'] as int,
      descripcion: json['descripcion'] as String,
    );
  }

  // Cambia el nombre de las propiedades
  int get id => metodoPagoId;

  Map<String, dynamic> toJson() {
    return {
      "metodoPagoId": metodoPagoId,
      "descripcion": descripcion,
    };
  }
}

class _SaleScreenState extends State<SaleScreen> {
  int selectedPerson = 0;
  int selectedPaymentMethod = 0;
  List<Map<String, dynamic>> detalles = [];
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _controlador = TextEditingController();
  List<Persona> personas = [];
  List<MetodoPago> metodosPago = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Venta',
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 18.0,
            color: ColorPalette.darkblueColorApp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        buildDropdown('Selecciona Persona', selectedPerson, personas, (value) {
          setState(() {
            selectedPerson = value ?? 0;
          });
        }),
        const SizedBox(height: 16.0),
        buildDropdown(
            'Selecciona Método de Pago', selectedPaymentMethod, metodosPago,
            (value) {
          setState(() {
            selectedPaymentMethod = value ?? 0;
          });
        }),
        const SizedBox(height: 16.0),
        buildTextFields(),
        const SizedBox(height: 20.0),
        NumPad(
          onKeyPressed: _updateTextField,
        ),
        const SizedBox(height: 20.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: buildDataTable(),
        ),
        const SizedBox(height: 16.0),
        if (selectedPerson != 0 &&
            selectedPaymentMethod != 0 &&
            detalles.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              sendData(
                  context, selectedPerson, selectedPaymentMethod, detalles);
            },
            child: const Text('Realizar Venta'),
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
        CherryToast.warning(title: const Text("Campos Vacios"));
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

  Widget buildDropdown(
      String label, int value, List<dynamic> items, Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8.0),
        DropdownButton<int>(
          value: value,
          onChanged: onChanged,
          items: [
            DropdownMenuItem<int>(
              value: 0,
              enabled: false,
              child: Text('Seleccione'),
            ),
            ...items.map((item) {
              return DropdownMenuItem<int>(
                value: item.id,
                child: Text(item.descripcion),
              );
            }),
          ],
          isExpanded: true,
        ),
      ],
    );
  }

  Widget buildTextFields() {
    return Row(
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
    );
  }

  Widget buildDataTable() {
    return DataTable(
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
    );
  }

  List<DataRow> _buildDataRows() {
    return detalles.map((numero) {
      return DataRow(
        cells: [
          DataCell(Text(numero['NumeroId']!.toString())),
          DataCell(Text('L.' + numero['valor']!.toString())),
          DataCell(IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _editRow(numero);
            },
          )),
          DataCell(IconButton(
            icon: const Icon(Icons.delete),
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
          title: const Text('Editar Registro'),
          contentPadding: const EdgeInsets.all(10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editedNumberController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: const InputDecoration(
                  labelText: 'Número',
                  counterText: '',
                ),
              ),
              TextField(
                controller: _editedPrecioController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: const InputDecoration(
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
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  numero['NumeroId'] = int.parse(_editedNumberController.text);
                  numero['valor'] = int.parse(_editedPrecioController.text);
                });

                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
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
          title: const Text('Eliminar Registro'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  detalles.remove(numero);
                });

                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
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
      final respuesta = decodedJson["message"];
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
      } else {
        CherryToast.warning(
            title: const Text("Ha ocurrido un error Inesperado"));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final responsePersona =
          await http.get(Uri.parse('${apiUrl}Persona/Listado'));
      final responseMetodoPago =
          await http.get(Uri.parse('${apiUrl}MetodoPago/Listado'));

      if (responsePersona.statusCode == 200) {
        final List<dynamic> dataPersona =
            json.decode(responsePersona.body)['data'];
        List<Persona> fetchedPersonas =
            dataPersona.map((json) => Persona.fromJson(json)).toList();

        setState(() {
          personas = fetchedPersonas;
          selectedPerson =
              fetchedPersonas.isNotEmpty ? fetchedPersonas.first.personaId : 0;
        });

        print(personas);
      } else {
        print(
            'Error en la solicitud HTTP para Persona/Listado: ${responsePersona.statusCode}');
      }

      if (responseMetodoPago.statusCode == 200) {
        final List<dynamic> dataMetodoPago =
            json.decode(responseMetodoPago.body)['data'];
        List<MetodoPago> fetchedMetodosPago =
            dataMetodoPago.map((json) => MetodoPago.fromJson(json)).toList();

        setState(() {
          metodosPago = fetchedMetodosPago;
          selectedPaymentMethod = fetchedMetodosPago.isNotEmpty
              ? fetchedMetodosPago.first.metodoPagoId
              : 0;
        });

        print(metodosPago.toString());
      } else {
        print(
            'Error en la solicitud HTTP para MetodoPago/Listado: ${responseMetodoPago.statusCode}');
      }
    } catch (e) {
      print('Error en fetchData: $e');
    }
  }
}
