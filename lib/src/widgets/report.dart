import 'dart:ui';

import 'package:bank_check/src/variables.dart';
import 'package:bank_check/src/widgets/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Report extends StatelessWidget {
  const Report({
    super.key,
    required this.result,
  });

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    const List<String> tableHeaders = ['Data', 'Fornecedor', 'Valor'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
        actions: [
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                final String name = result['name']
                    .toString()
                    .replaceAll('.xlsx', '')
                    .replaceAll(' ', '');
                print(name);
                await Printing.sharePdf(
                    bytes: await generatePdf('Relatório', result),
                    filename: 'relatorio-$name.pdf');
                /* Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdfView(
                      result: result,
                    ),
                  ),
                ); */
              }
              //sharePdf,
              ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Extrato X Despesas',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 410,
                width: MediaQuery.of(context).size.width - 16,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result['missingPayments']!.values.first.isNotEmpty
                              ? result['missingPayments']!.values.first.length >
                                      1
                                  ? 'Os seguintes ${result['missingPayments']!.values.first.length} pagamentos não constam nas contas do sistema:'
                                  : 'O seguinte pagamento não consta nas contas do sistema:'
                              : 'Todos os pagamentos do extrato foram encontrados no sistema.',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                              result['missingPayments']!.values.first.isNotEmpty
                                  ? [
                                      const Text('Data'),
                                      const Text('Fornecedor'),
                                      const Text('Valor(R\$)'),
                                    ]
                                  : [],
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 490,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            restorationId: 'missingPayments',
                            shrinkWrap: true,
                            itemCount:
                                result['missingPayments']!.values.first.length,
                            itemBuilder: (context, index) {
                              DateTime date =
                                  result['missingPayments']!['Data']![index];
                              String formattedDate =
                                  dateFormatShort.format(date);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${result['missingPayments']!['Fornecedor']![index]}',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                    Text(
                                        '${result['missingPayments']!['Valor']![index]}'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Despesas X Extrato',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width - 16,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result['priceDiff']!.values.first.isNotEmpty
                              ? result['priceDiff']!.values.first.length > 1
                                  ? 'As seguintes ${result['priceDiff']!.values.first.length} contas não foram encontradas no extrato:'
                                  : 'A seguinte conta não foi encontrada no extrato:'
                              : 'Todas as contas foram encontradas no extrato',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: result['priceDiff']!.values.first.isNotEmpty
                              ? [
                                  const Text('Data'),
                                  const Text('Fornecedor'),
                                  const Text('Valor(R\$)'),
                                ]
                              : [],
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        SizedBox(
                          height: clampDouble(
                              (result['priceDiff']!.values.first.length)
                                      .toDouble() *
                                  40,
                              50.0,
                              MediaQuery.of(context).size.height - 490),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            restorationId: 'priceDiff',
                            shrinkWrap: true,
                            itemCount: result['priceDiff']!.values.first.length,
                            itemBuilder: (context, index) {
                              DateTime date =
                                  result['priceDiff']!['Data']![index];
                              String formattedDate =
                                  dateFormatShort.format(date);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${result['priceDiff']!['Fornecedor']![index]}',
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 7.0,
                                    ),
                                    Text(
                                        '${result['priceDiff']!['Valor']![index]}'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          result['dateDiff']!.values.first.isNotEmpty
                              ? result['dateDiff']!.values.first.length > 1
                                  ? 'As seguintes ${result['dateDiff']!.values.first.length} contas possuem discrepância maior que 3 dias no seu pagamento:'
                                  : 'A seguinte conta possui discrepância maior que 3 dias no seu pagamento:'
                              : 'Nenhuma discrepância de data encontrada.',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: result['dateDiff']!.values.first.isNotEmpty
                              ? [
                                  const Text('Data'),
                                  const Text('Fornecedor'),
                                  const Text('Valor(R\$)'),
                                ]
                              : [],
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        SizedBox(
                          height: result['dateDiff']!.values.first.isNotEmpty
                              ? MediaQuery.of(context).size.height - 490
                              : 10,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            restorationId: 'dateDiff',
                            shrinkWrap: true,
                            itemCount: result['dateDiff']!.values.first.length,
                            itemBuilder: (context, index) {
                              DateTime date =
                                  result['dateDiff']!['Data']![index];
                              String formattedDate =
                                  dateFormatShort.format(date);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${result['dateDiff']!['Fornecedor']![index]}',
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 7.0,
                                    ),
                                    Text(
                                        '${result['dateDiff']!['Valor']![index]}'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sharePdf() async {
    // Share the report
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          contentTable(context, 'missingPayments'),
          contentTable(context, 'priceDiff'),
          contentTable(context, 'dateDiff')
        ],
      ),
    );
    // Page
    //final String name = result['name'].toString().trim().replaceAll(' ', '');
    //final file = File("$name.pdf");
    //await file.writeAsBytes(await pdf.save());
  }

  pw.Widget contentTable(pw.Context context, String dataTitle) {
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
      /* cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.center,
          4: pw.Alignment.centerRight,
        }, */
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      /* cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 10,
        ), */
      /* rowDecoration: pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: accentColor,
              width: .5,
            ),
          ),
        ), */
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        result.values.first.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => result[dataTitle][tableHeaders[col]][row],
        ),
      ),
    );
  }
}
