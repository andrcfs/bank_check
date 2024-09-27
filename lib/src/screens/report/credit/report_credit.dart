import 'package:bank_check/src/screens/report/credit/bank_chart.dart';
import 'package:bank_check/src/screens/report/credit/system_chart.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:bank_check/src/widgets/pdf_view.dart';
import 'package:flutter/material.dart';

class ReportCredit extends StatelessWidget {
  const ReportCredit({
    super.key,
    required this.result,
  });

  final ResultCredit result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
        actions: [
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                final String name = result.name
                    .toString()
                    .replaceAll('.xlsx', '')
                    .replaceAll(' ', '');

                /* await Printing.sharePdf(
                    bytes: await generatePdf('Relatório', result),
                    filename: 'relatorio-$name.pdf'); */
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdfView(
                      result: result,
                    ),
                  ),
                );
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
                    'Extrato Bancário',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: BankChart(
                  result: result,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sistema',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SystemChart(
                  result: result,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Comparativo',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
