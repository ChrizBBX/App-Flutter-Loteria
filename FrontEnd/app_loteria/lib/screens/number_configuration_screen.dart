// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:app_loteria/api.dart';
import 'package:app_loteria/models/Numero.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/num_pad.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NumberConfigurationScreen extends StatefulWidget {
  @override
  _NumberConfigurationScreenState createState() =>
      _NumberConfigurationScreenState();
}

class _NumberConfigurationScreenState extends State<NumberConfigurationScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _limiteController = TextEditingController();
  String _currentController = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Configurar Permisos de Números',
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 18.0,
            color: ColorPalette.darkblueColorApp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _numberController,
          keyboardType: TextInputType.number,
          maxLength: 2,
          decoration: InputDecoration(
            labelText: 'Número',
            counterText: '',
            errorText: _validateInput(_currentController == "Num"),
          ),
          onTap: () {
            _setCurrentController("Num");
          },
        ),
        TextField(
          controller: _limiteController,
          keyboardType: TextInputType.number,
          maxLength: 2,
          decoration: InputDecoration(
            labelText: 'Limite',
            counterText: '',
            errorText: _validateInput(_currentController == "Lim"),
          ),
          onTap: () {
            _setCurrentController("Lim");
          },
        ),
        const SizedBox(height: 20.0),
        NumPad(
          onKeyPressed: _handleKeyPress,
        ),
      ],
    );
  }

  String? _validateInput(bool isNumField) {
    TextEditingController currentController =
        isNumField ? _numberController : _limiteController;

    if (currentController.text.isNotEmpty) {
      int? number = int.tryParse(currentController.text);
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

  void _handleKeyPress(String value) {
    if (value == "C") {
      _handleTextFieldUpdate(value, _numberController);
    } else if (value == "Intro") {
      if (_numberController.text == '' || _numberController.text == '') {
        CherryToast.warning(
          title: const Text('Ambos campos son requeridos',
              style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
              textAlign: TextAlign.start),
          borderRadius: 5,
        ).show(context);
      } else {
        _showConfirmationDialog();
      }
    } else {
      if (_currentController == "Num") {
        _handleTextFieldUpdate(value, _numberController);
      } else if (_currentController == "Lim") {
        _handleTextFieldUpdate(value, _limiteController);
      } else {
        CherryToast.warning(
          title: const Text('No se ha seleccionado ningún campo',
              style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
              textAlign: TextAlign.start),
          borderRadius: 5,
        ).show(context);
      }
    }
  }

  void _handleTextFieldUpdate(String value, TextEditingController controller) {
    setState(() {
      if (value == "C") {
        controller.text = "";
      } else if (value == "OK") {
        _validateInput(controller == _numberController);
      } else {
        if (controller.text.length < 2) {
          controller.text += value;
        }
      }
    });
  }

  void _setCurrentController(String controller) {
    setState(() {
      _currentController = controller;
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text(
            '¿Está seguro de que desea asignar el límite de ${_limiteController.text} al Número ${_numberController.text}?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _editarLimite();
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _editarLimite() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Numero numero = Numero(
        numeroId: int.parse(_numberController.text),
        numeroDescripcion: null,
        limite: int.parse(_limiteController.text),
        usuarioCreacion: 0,
        fechaCreacion: DateTime.now(),
        usuarioModificacion: prefs.getInt('usuarioId') ?? 0,
        fechaModificacion: DateTime.now(),
        estado: null,
      );

      String numeroConfiguracionJson = jsonEncode(numero);

      final response = await http.put(
        Uri.parse('${apiUrl}Numero/EditarLimite'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: numeroConfiguracionJson,
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final message = decodedJson["message"];

        if (message == 'El numero seleccionado no existe') {
          CherryToast.warning(
            title: const Text('El numero seleccionado no existe',
                style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        } else if (message == 'El limite ha sido editado exitosamente') {
          CherryToast.success(
            title: const Text('El limite ha sido editado exitosamente',
                style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        }
      } else {}
    } catch (e) {}
  }
}
