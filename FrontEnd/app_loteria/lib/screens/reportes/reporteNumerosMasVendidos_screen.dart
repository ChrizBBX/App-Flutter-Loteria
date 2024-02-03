// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'dart:typed_data';
import 'package:app_loteria/api.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportePDFTopNumeros extends StatefulWidget {
  final DateTime fechaInicio;
  final DateTime fechaFin;

  const ReportePDFTopNumeros({
    Key? key,
    required this.fechaInicio,
    required this.fechaFin,
  }) : super(key: key);

  @override
  _ReportePDFTopNumerosState createState() => _ReportePDFTopNumerosState();
}

class _ReportePDFTopNumerosState extends State<ReportePDFTopNumeros> {
  late Uint8List _pdfBytes;
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataAndGeneratePDF();
  }

  Future<void> fetchDataAndGeneratePDF() async {
    try {
      String formattedFechaInicio =
          DateFormat('yyyy-dd-MM').format(widget.fechaInicio);
      String formattedFechaFin =
          DateFormat('yyyy-dd-MM').format(widget.fechaFin);

      final response = await http.get(Uri.parse(
          '${apiUrl}Reporte/TopNumeros?fecha_inicio=$formattedFechaInicio&fecha_fin=$formattedFechaFin'));

      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);

        if (responseData is List) {
          _data = List<Map<String, dynamic>>.from(responseData);
        } else {
          _data = [Map<String, dynamic>.from(responseData)];
        }
      }
    } catch (e) {
      print('Error al obtener datos: $e');
    }

    setState(() {
      _isLoading = false;
    });

    await generatePDF();
  }

 Future<Uint8List> generatePDF() async {
  final pw.Document pdf = pw.Document();
  if (_data.isNotEmpty) {
    final List<dynamic>? dataList = _data[0]['data'] as List<dynamic>?;

    pdf.addPage(
      pw.MultiPage(
        header: (pw.Context context) {
          return pw.Container(
            color: PdfColor.fromHex("001F3F"),
            width: double.infinity,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'NUMERITO'.toUpperCase(),
                  style: const pw.TextStyle(
                      fontSize: 16, color: PdfColors.white),
                ),
                pw.Text(
                  'Reporte números más vendidos'.toUpperCase(),
                  style: const pw.TextStyle(
                      fontSize: 12, color: PdfColors.white),
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Text(
              'Fecha y Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 8),
            ),
          );
        },
        build: (pw.Context context) {
          return [
            pw.SizedBox(height: 5.00),
            pw.Table.fromTextArray(
              headers: ['ID', 'Descripción', 'Cantidad'],
              data: dataList?.map((row) {
                return [
                  row['idNumero']?.toString() ?? '',
                  row['descripcionNumero']?.toString() ?? '',
                  row['cantidad']?.toString() ?? '',
                ];
              }).toList() ?? [], // Asegúrate de manejar el caso en que dataList sea nulo
              border: const pw.TableBorder(
                horizontalInside: pw.BorderSide.none,
                verticalInside: pw.BorderSide.none,
                bottom: pw.BorderSide.none,
                top: pw.BorderSide.none,
                left: pw.BorderSide.none,
                right: pw.BorderSide.none,
              ),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.cyan,
              ),
              rowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
              },
              context: context,
            ),
            pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 5),
              child: pw.Divider(color: PdfColors.grey),
            ),
          ];
        },
      ),
    );
  }

  final Uint8List pdfBytes = Uint8List.fromList(await pdf.save());

  setState(() {
    _pdfBytes = pdfBytes;
  });

  return pdfBytes;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Ventas'),
        backgroundColor: ColorPalette.darkblueColorApp,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: ColorPalette.darkblueColorApp,
              ),
            )
          : _pdfBytes.isNotEmpty
              ? PdfPreview(
                  canChangeOrientation: true,
                  pdfFileName: 'Copia Facturas',
                  build: (format) => _generatePdfPreview(format, _pdfBytes),
                )
              : const Center(
                  child: Text('No se pudo generar el PDF'),
                ),
    );
  }

  Uint8List _generatePdfPreview(PdfPageFormat format, Uint8List data) {
    return data;
  }
}

void main() {
  runApp(
    MaterialApp(
      home: ReportePDFTopNumeros(
        fechaInicio: DateTime.now(),
        fechaFin: DateTime.now(),
      ),
    ),
  );
}
