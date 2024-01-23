import 'dart:ui';

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
            _buildNumberButton('C', 140.0),
            _buildNumberButton('Intro', 140.0),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNumberButton('7', 80.0),
            _buildNumberButton('8', 80.0),
            _buildNumberButton('9', 80.0),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNumberButton('6', 80.0),
            _buildNumberButton('4', 80.0),
            _buildNumberButton('5', 80.0),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNumberButton('1', 80.0),
            _buildNumberButton('2', 80.0),
            _buildNumberButton('3', 80.0),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNumberButton('0', 80.0),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String value, double Width) {
    return SizedBox(
      width: Width,
      child: ElevatedButton(
        onPressed: () => widget.onKeyPressed(value),
        child: Text(value),
        style: ElevatedButton.styleFrom(
          primary: ColorPalette.darkblueColorApp,
          onPrimary: ColorPalette.whiteColor,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        ),
      ),
    );
  }
}
