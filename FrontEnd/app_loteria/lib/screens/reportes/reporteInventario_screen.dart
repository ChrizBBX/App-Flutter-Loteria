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

class ReportePDFInventario extends StatefulWidget {
  const ReportePDFInventario({Key? key}) : super(key: key);

  @override
  _ReportePDFInventarioState createState() => _ReportePDFInventarioState();
}

class _ReportePDFInventarioState extends State<ReportePDFInventario> {
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
      final response = await http.get(Uri.parse('${apiUrl}Reporte/Inventario'));

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
      final netImage =
      //     await networkImage('https://i.ibb.co/dP0sMXh/Logo-Blanco.png');
      // await Future.delayed(Duration(seconds: 10));

      pdf.addPage(
        pw.MultiPage(
          header: (pw.Context context) {
            return pw.Container(
              color: PdfColor.fromHex("001F3F"),
              width: double.infinity,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  // pw.SizedBox(
                  //   width: 100,
                  //   height: 100,
                  //   child: pw.Image(netImage),
                  // ),
                  pw.Text(
                    'NUMERITO'.toUpperCase(),
                    style: pw.TextStyle(fontSize: 20, color: PdfColors.white),
                  ),
                  pw.Text(
                    'Reporte de Inventario'.toUpperCase(),
                    style: pw.TextStyle(fontSize: 14, color: PdfColors.white),
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
                'Fecha y Hora: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10),
              ),
            );
          },
          build: (pw.Context context) {
            return [
              pw.Table.fromTextArray(
                headers: ['Numero', 'Descripcion', 'Limite de Hoy'],
                data: dataList?.map((row) {
                      return [
                        row['numeroId']?.toString() ?? '',
                        row['numeroDescripcion']?.toString() ?? '',
                        row['limite']?.toString() ?? '',
                      ];
                    }).toList() ??
                    [],
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.cyan,
                ),
                rowDecoration: const pw.BoxDecoration(
                    color: PdfColors.grey100), // Updated this line
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.centerRight,
                },
                context: context,
              ),
            ];
          },
        ),
      );
    } else {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('No hay datos disponibles',
                      style: pw.TextStyle(fontSize: 18)),
                ],
              ),
            );
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
        title: const Text('Reporte Inventario'),
        backgroundColor: ColorPalette.darkblueColorApp,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _pdfBytes.isNotEmpty
              ? PdfPreview(
                  build: (format) => _generatePdfPreview(format, _pdfBytes),
                )
              : Center(
                  child: Text('No se pudo generar el PDF'),
                ),
    );
  }

  Uint8List _generatePdfPreview(PdfPageFormat format, Uint8List data) {
    return data;
  }
}

void main() {
  runApp(const MaterialApp(home: ReportePDFInventario()));
}
