import 'package:bank_check/src/screens/report/credit/comparison.dart';
import 'package:bank_check/src/screens/report/credit/credit_piechart.dart';
import 'package:bank_check/src/screens/report/credit/report_section.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/methods.dart';
import 'package:flutter/material.dart';

class ReportCredit extends StatefulWidget {
  const ReportCredit({
    super.key,
    required this.result,
  });
  final ResultCredit result;

  @override
  State<ReportCredit> createState() => _ReportCreditState();
}

class _ReportCreditState extends State<ReportCredit> {
  late List<MapEntry<String, double>> bankSuppliers;
  late List<MapEntry<String, double>> systemSuppliers;
  late Map<String, double> combinedEntries;
  List<String> bankOthers = [];
  List<String> systemOthers = [];
  double bankTotal = 0;
  double systemTotal = 0;

  @override
  void initState() {
    super.initState();
    bankSuppliers = getSuppliers(widget.result.bankPriceSums, bankOthers);
    combinedEntries = combineEntries(widget.result.systemPriceSums);
    systemSuppliers = getSuppliers(combinedEntries, systemOthers);
    bankTotal = bankSuppliers.fold(0, (sum, amount) => sum + amount.value);
    systemTotal = systemSuppliers.fold(0, (sum, amount) => sum + amount.value);
    print('dnv');
    print(systemOthers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
        /* actions: [
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                final String name = widget.result.name
                    .toString()
                    .replaceAll('.xlsx', '')
                    .replaceAll(' ', '');

                await Printing.sharePdf(
                    bytes: await generatePdf('Relatório', result),
                    filename: 'relatorio-$name.pdf');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdfView(
                      result: widget.result,
                    ),
                  ),
                );
              }),
        ], */
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
              MediaQuery.of(context).size.height > 570 ? 8.0 : 4),
          child: Column(
            children: [
              ReportSection(
                title: 'Extrato Bancário',
                widget: CreditPieChart(
                  total: bankTotal,
                  suppliers: bankSuppliers,
                  others: bankOthers,
                ),
              ),
              ReportSection(
                title: 'Sistema',
                widget: CreditPieChart(
                  total: systemTotal,
                  suppliers: systemSuppliers,
                  others: systemOthers,
                ),
              ),
              ReportSection(
                title: 'Comparativo',
                widget: ComparisonSection(
                    bankSuppliers: bankSuppliers,
                    systemSuppliers: systemSuppliers),
              )
            ],
          ),
        ),
      ),
    );
  }
}
