import 'dart:typed_data';

import 'package:bank_check/src/variables.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfView extends StatelessWidget {
  const PdfView({super.key, required this.result});
  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    print(result['missingPayments'].values.first.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF Visualization'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => generatePdf('Relatório', result),
      ),
    );
  }

//
  pw.Widget contentTable2(pw.Context context, String dataTitle) {
    const List<String> tableHeaders = ['Data', 'Fornecedor', 'Valor'];

    return pw.TableHelper.fromTextArray(
      context: context,
      data: List<List<String>>.generate(
        result[dataTitle].values.first.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => '$col x $row',
        ),
      ),
    );
  }
}

Future<Uint8List> generatePdf(String title, Map<String, dynamic> result) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  List<pw.Widget> content = [
    pw.Header(level: 0, text: 'Relatório de Conciliação Bancária'),
    pw.Header(level: 2, text: 'Extrato X Despesas'),
  ];

  if (result['missingPayments']!.values.first.isNotEmpty) {
    content.add(
      pw.Paragraph(
        text: result['missingPayments']!.values.first.length > 1
            ? 'Os seguintes ${result['missingPayments']!.values.first.length} pagamentos não constam nas contas do sistema:'
            : 'O seguinte pagamento não consta nas contas do sistema:',
      ),
    );
    content.add(contentTable('missingPayments', result));
  } else {
    content.add(
      pw.Paragraph(
        text: 'Todos os pagamentos do extrato foram encontrados no sistema.',
      ),
    );
  }
  content.add(
    pw.SizedBox(height: 20),
  );
  content.add(pw.Header(level: 2, text: 'Despesas X Extrato'));

  if (result['priceDiff']!.values.first.isNotEmpty) {
    content.add(
      pw.Paragraph(
        text: result['priceDiff']!.values.first.length > 1
            ? 'As seguintes despesas ${result['priceDiff']!.values.first.length} não foram encontradas no extrato:'
            : 'A seguinte despesa não foi encontrada no extrato:',
      ),
    );
    content.add(contentTable('priceDiff', result));
  } else {
    content.add(
      pw.Paragraph(
        text: 'Todas as despesas do sistema foram encontradas no extrato.',
      ),
    );
  }
  content.add(
    pw.SizedBox(height: 20),
  );
  if (result['dateDiff']!.values.first.isNotEmpty) {
    content.add(
      pw.Paragraph(
        text: result['dateDiff']!.values.first.length > 1
            ? 'As seguintes ${result['dateDiff']!.values.first.length} contas possuem discrepância maior que 3 dias no seu pagamento:'
            : 'A seguinte conta possui discrepância maior que 3 dias no seu pagamento:',
      ),
    );
    content.add(contentTable('dateDiff', result));
  } else {
    content.add(
      pw.Paragraph(
        text: 'Todas as contas possuem data de pagamento compatível.',
      ),
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => content,
    ),
  );

  return pdf.save();
}

pw.Widget contentTable(String dataTitle, Map<String, dynamic> result) {
  const List<String> tableHeaders = ['Data', 'Fornecedor', 'Valor'];

  return pw.TableHelper.fromTextArray(
    border: null,
    cellAlignment: pw.Alignment.centerLeft,
    headerDecoration: const pw.BoxDecoration(
      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
      color: PdfColors.blue,
    ),
    headerHeight: 25,
    cellHeight: 40,
    cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerLeft,
      2: pw.Alignment.centerRight,
    },
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(
      color: PdfColors.black,
      fontSize: 10,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: PdfColors.black,
          width: .5,
        ),
      ),
    ),
    headers: List<String>.generate(
      tableHeaders.length,
      (col) => tableHeaders[col] == 'Valor'
          ? '${tableHeaders[col]} R\$'
          : tableHeaders[col],
    ),
    data: List<List<String>>.generate(
      result[dataTitle].values.first.length,
      (row) => List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col] == 'Data'
            ? dateFormatShort.format(result[dataTitle][tableHeaders[col]][row])
            : result[dataTitle][tableHeaders[col]][row].toString(),
      ),
    ),
  );
}
