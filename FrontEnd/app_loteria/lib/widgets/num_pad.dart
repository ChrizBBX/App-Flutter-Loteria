import 'package:app_loteria/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class NumPad extends StatefulWidget {
  final Function(String) onKeyPressed;

  NumPad({required this.onKeyPressed});

  @override
  State<NumPad> createState() => _NumPadState();
}

class _NumPadState extends State<NumPad> {
  @override
  Widget build(BuildContext context) {
    return Column(
       children: [
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNumberButton('6'),
            _buildNumberButton('4'),
            _buildNumberButton('5'),
          ],
        ),
        SizedBox(height: 10.0),
          
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNumberButton('0'),
            _buildNumberButton('OK'),
            _buildNumberButton('C'),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String value) {
    return ElevatedButton(
      onPressed: () => widget.onKeyPressed(value),
      child: Text(value),
      style: ElevatedButton.styleFrom(
        primary:  ColorPalette.darkblueColorApp,
        onPrimary: ColorPalette.whiteColor,
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 25),
      ),
    );
  }
}
