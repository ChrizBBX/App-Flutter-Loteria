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
import 'package:shared_preferences/shared_preferences.dart';

class ReportePDF_Cierre extends StatefulWidget {
  const ReportePDF_Cierre({Key? key}) : super(key: key);

  @override
  _ReportePDF_CierreState createState() => _ReportePDF_CierreState();
}

class _ReportePDF_CierreState extends State<ReportePDF_Cierre> {
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int id = prefs.getInt('usuarioId') ?? 0;
      final response = await http.get(Uri.parse(
          '${apiUrl}Reporte/ReporteCierres?fecha=${DateTime.now()}&id=$id'));

      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);

        if (responseData is List) {
          _data = List<Map<String, dynamic>>.from(responseData);
        } else {
          _data = [Map<String, dynamic>.from(responseData)];
        }
      }
    } catch (e) {}

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
                  pw.SizedBox(height: 5.00),
                  pw.Text(
                    'NUMERITO'.toUpperCase(),
                    style: pw.TextStyle(fontSize: 20, color: PdfColors.white),
                  ),
                  pw.Text(
                    'Reporte de Cierre ${DateFormat('dd/MM/yyyy').format(DateTime.parse(DateTime.now().toString()))}'
                        .toUpperCase(),
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
                'Fecha y Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10),
              ),
            );
          },
          build: (pw.Context context) {
            return [
              pw.SizedBox(height: 5.00),
              pw.Table.fromTextArray(
                headers: ['N° Factura', 'Hora y Fecha', 'Total'],
                data: dataList?.map((row) {
                      return [
                        row['ventaId']?.toString() ?? '',
                        DateFormat('HH:mm dd/MM/yyyy').format(
                            DateTime.parse(row['fechaCreacion'].toString())),
                        row['cantidad'] != null
                            ? NumberFormat.currency(
                                locale: 'es_HN',
                                symbol: 'LPS',
                              ).format(row['cantidad'])
                            : 'N/A',
                      ];
                    }).toList() ??
                    [],
                border: const pw.TableBorder(
                  horizontalInside: pw.BorderSide.none,
                  verticalInside: pw.BorderSide.none,
                  bottom: pw.BorderSide.none,
                  top: pw.BorderSide.none,
                  left: pw.BorderSide.none,
                  right: pw.BorderSide.none,
                ),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.cyan,
                ),
                rowDecoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                ),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.centerRight,
                },
                context: context,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Total: ',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      )),
                  pw.Text(
                    NumberFormat.currency(
                      locale: 'es_HN',
                      symbol: 'LPS',
                    ).format(dataList?.fold<double>(
                          0.0,
                          (prev, data) =>
                              prev +
                              (data['cantidad'] != null
                                  ? data['cantidad']
                                  : 0.0),
                        ) ??
                        0.0),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 8,
                    ),
                  ),
                ],
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
        title: const Text('Reporte Cierre de Dia'),
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
  runApp(const MaterialApp(home: ReportePDF_Cierre()));
}
