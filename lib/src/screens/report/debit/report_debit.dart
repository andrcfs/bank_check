import 'package:bank_check/src/screens/report/debit/bankXsystem.dart';
import 'package:bank_check/src/screens/report/debit/matching_payments.dart';
import 'package:bank_check/src/screens/report/debit/systemXbank.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/widgets/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class ReportDebit extends StatelessWidget {
  const ReportDebit({
    super.key,
    required this.result,
  });

  final ResultDebit result;

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

                await Printing.sharePdf(
                    bytes: await generateDebitPdf('Relatório', result),
                    filename: 'relatorio-$name.pdf');
                /* Navigator.of(context).push(
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
              BankXSystemReport(result: result),
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
              SystemXBankReport(result: result),
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
              if (result.paymentsFound.isNotEmpty)
                MatchingPaymentsReport(result: result),
            ],
          ),
        ),
      ),
    );
  }
}
