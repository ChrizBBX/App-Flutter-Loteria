import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:flutter/material.dart';
import '../widgets/num_pad.dart';

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
          maxLength: 2,
          decoration: InputDecoration(
            labelText: 'Número',
            counterText: '',
            errorText: _validateInput(),
          ),
        ),
        SizedBox(height: 20.0),
        NumPad(
          onKeyPressed: _updateTextField,
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

  void _updateTextField(String value) {
    setState(() {
      if (value == "C") {
        _numberController.text = "";
      } else if (value == "OK") {
        _validateInput();
      } else {
        if (_numberController.text.length < 2) {
          _numberController.text += value;
        }
      }
    });
  }
}
