// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'dart:typed_data';
import 'package:app_loteria/api.dart';
import 'package:app_loteria/screens/home_screen.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FacturaPDF extends StatefulWidget {
  final String ID;

  const FacturaPDF({
    Key? key,
    required this.ID,
  }) : super(key: key);

  @override
  _FacturaPDFState createState() => _FacturaPDFState();
}

class _FacturaPDFState extends State<FacturaPDF> {
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
      String ventaID = widget.ID;
      final response = await http
          .get(Uri.parse('${apiUrl}Ventas/GenerarFactura?ID=$ventaID'));

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
    final PdfPageFormat pageFormat = const PdfPageFormat(
        8.0 * PdfPageFormat.cm, 15.0 * PdfPageFormat.cm,
        marginAll: 1.0 * PdfPageFormat.mm);
    final pw.Document pdf = pw.Document();

    for (var saleData in _data) {
      if (saleData['data'] is List) {
        final List<dynamic> dataList = saleData['data'];

        for (var row in dataList) {
          if (row['detalles'] is List) {
            final List<dynamic> detalles = row['detalles'];

            pdf.addPage(
              pw.MultiPage(
                pageFormat: pageFormat,
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
                          'Recibo de Venta'.toUpperCase(),
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
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Factura #${row['ventaId']?.toString()}'),
                        pw.Text(
                          'Fecha ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(row['fechaCreacion']))}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5.00),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Cliente: ${row['nombres']?.toString()} ${row['apellidos']?.toString() ?? ''}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5.00),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Identidad ${row['identidad']?.toString() ?? 'N/A'}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5.00),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Identidad ${row['metodoPagoDescripcion']?.toString() ?? 'N/A'}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5.00),
                    pw.Table.fromTextArray(
                      headers: ['ID', 'Número', 'Descripción', 'Valor Apuesta'],
                      data: detalles.map((detalle) {
                        return [
                          detalle['ventaDetalleId']?.toString() ?? 'N/A',
                          detalle['numeroId']?.toString() ?? 'N/A',
                          detalle['numeroDescripcion']?.toString() ?? 'N/A',
                          detalle['valor'] != null
                              ? NumberFormat.currency(
                                  locale: 'es_HN',
                                  symbol: 'LPS',
                                ).format(detalle['valor'])
                              : 'N/A',
                        ];
                      }).toList(),
                      border: const pw.TableBorder(
                        horizontalInside: pw.BorderSide.none,
                        verticalInside: pw.BorderSide.none,
                        bottom: pw.BorderSide.none,
                        top: pw.BorderSide.none,
                        left: pw.BorderSide.none,
                        right: pw.BorderSide.none,
                      ),
                      headerStyle: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 8),
                      headerDecoration: const pw.BoxDecoration(
                        color: PdfColors.cyan,
                      ),
                      rowDecoration:
                          const pw.BoxDecoration(color: PdfColors.grey100),
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
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text('Total Venta: ',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        pw.Text(
                          NumberFormat.currency(
                            locale: 'es_HN',
                            symbol: 'LPS',
                          ).format(detalles.fold<double>(
                              0.0,
                              (prev, detalle) =>
                                  prev +
                                  (detalle['valor'] != null
                                      ? detalle['valor']
                                      : 0.0))),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8),
                        ),
                      ],
                    ),
                  ];
                },
              ),
            );
          }
        }
      }
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
        title: const Text('Impresión Factura'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
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
                  pdfFileName: 'Copia de Factura',
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
      home: FacturaPDF(
        ID: '',
      ),
    ),
  );
}
