import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberConfigurationScreen extends StatefulWidget {
  @override
  _NumberConfigurationScreenState createState() =>
      _NumberConfigurationScreenState();
}

class _NumberConfigurationScreenState extends State<NumberConfigurationScreen> {
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Configurar Permisos de Números',
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
          decoration: InputDecoration(
            labelText: 'Número',
            errorText: _validateInput(),
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            _showValidationToast();
          },
          child: Text('Buscar'),
        ),
        SizedBox(height: 50.0),
        Image.asset('images/Informacion.png', width: 150, height: 150),
        SizedBox(height: 8.0),
        Text(
          'La información relacionada aparecerá aquí',
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.bold,
            color: ColorPalette.darkblueColorApp,
          ),
          textAlign: TextAlign.center,
        ),
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

  void _showValidationToast() {
    String? validationMessage = _validateInput();
    if (validationMessage != null) {
      CherryToast.warning(
        title: Text(
          validationMessage,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.justify,
        ),
        borderRadius: 5,
      ).show(context);
    } else {
      // Lógica para la búsqueda exitosa
      // ...

      // Muestra el toast de éxito
      CherryToast.success(
        title: Text(
          'Búsqueda exitosa',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.justify,
        ),
        borderRadius: 5,
      ).show(context);
    }
  }
}
