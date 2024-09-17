import 'dart:ui';

import 'package:bank_check/src/variables.dart';
import 'package:bank_check/src/widgets/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class Report extends StatelessWidget {
  const Report({
    super.key,
    required this.result,
  });

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
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

                await Printing.sharePdf(
                    bytes: await generatePdf('Relatório', result),
                    filename: 'relatorio-$name.pdf');
                /*  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdfView(
                      result: result,
                    ),
                  ),
                ); */
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
              MediaQuery.of(context).size.height > 570 ? 8.0 : 4),
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
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width - 16,
                padding: EdgeInsets.symmetric(
                    vertical:
                        MediaQuery.of(context).size.height > 570 ? 8.0 : 4,
                    horizontal: 12.0),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 8.0
                              : 4,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 4.0
                              : 2,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.39,
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
                                    const EdgeInsets.symmetric(vertical: 12.0),
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
                                        '${result['missingPayments']!['Valor']![index].toStringAsFixed(2)}'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 4.0
                              : 2,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              result['missingPayments']!.values.first.length > 1
                                  ? 'Total: R\$ ${result['missingPayments']!['Valor']!.fold(0, (a, b) => a + b).toStringAsFixed(2)}'
                                  : '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 8.0
                              : 4,
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
                height: MediaQuery.of(context).size.height * 0.6,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 8.0
                              : 4,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 4.0
                              : 2,
                        ),
                        SizedBox(
                          height: clampDouble(
                              (result['priceDiff']!.values.first.length)
                                      .toDouble() *
                                  40,
                              50.0,
                              MediaQuery.of(context).size.height * 0.3),
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
                                    const EdgeInsets.symmetric(vertical: 12.0),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 4.0
                              : 2,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              result['priceDiff']!.values.first.isNotEmpty
                                  ? 'Total: R\$ ${result['priceDiff']!['Valor']!.fold(0, (a, b) => a + b).toStringAsFixed(2)}'
                                  : '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 20.0
                              : 10,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 8.0
                              : 4.0,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 4.0
                              : 2,
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
                                    const EdgeInsets.symmetric(vertical: 12.0),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 570
                              ? 4.0
                              : 2,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              result['dateDiff']!.values.first.length > 1
                                  ? 'Total: R\$ ${result['dateDiff']!['Valor']!.fold(0, (a, b) => a + b).toStringAsFixed(2)}'
                                  : '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
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
                    'Pagamentos Encontrados',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (result['paymentsFound'] != null)
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width - 16,
                  padding: EdgeInsets.symmetric(
                      vertical:
                          MediaQuery.of(context).size.height > 570 ? 8.0 : 4,
                      horizontal: 12.0),
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
                            result['paymentsFound']!.values.first.isNotEmpty
                                ? result['paymentsFound']!.values.first.length >
                                        1
                                    ? 'Os seguintes ${result['paymentsFound']!.values.first.length} pagamentos foram encontrados no sistema:'
                                    : 'O seguinte pagamento foi encontrado no sistema:'
                                : 'Nenhum pagamento encontrado.',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height > 570
                                ? 8.0
                                : 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                                result['paymentsFound']!.values.first.isNotEmpty
                                    ? [
                                        const Text('Data'),
                                        const Text('Fornecedor'),
                                        const Text('Valor(R\$)'),
                                      ]
                                    : [],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height > 570
                                ? 4.0
                                : 2,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.39,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              restorationId: 'paymentsFound',
                              shrinkWrap: true,
                              itemCount:
                                  result['paymentsFound']!.values.first.length,
                              itemBuilder: (context, index) {
                                DateTime date =
                                    result['paymentsFound']!['Data']![index];
                                String formattedDate =
                                    dateFormatShort.format(date);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          '${result['paymentsFound']!['Fornecedor']![index]}',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                      Text(
                                          '${result['paymentsFound']!['Valor']![index].toStringAsFixed(2)}'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height > 570
                                ? 4.0
                                : 2,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                result['paymentsFound']!.values.first.length > 1
                                    ? 'Total: R\$ ${result['paymentsFound']!['Valor']!.fold(0, (a, b) => a + b).toStringAsFixed(2)}'
                                    : '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height > 570
                                ? 8.0
                                : 4,
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
}
