import 'package:bank_check/src/screens/report/debit/widgets/report_entry.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SystemXBankReport extends StatelessWidget {
  const SystemXBankReport({
    super.key,
    required this.result,
  });

  final ResultDebit result;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width - 16,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: defaultTargetPlatform == TargetPlatform.windows
              ? MediaQuery.of(context).size.width - 32
              : MediaQuery.of(context).size.width - 16,
          child: Padding(
            padding: EdgeInsets.only(
              right: defaultTargetPlatform == TargetPlatform.windows ? 32 : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Contas não encontradas no extrato PriceDiff
                ReportAnalysisEntry(
                  myDataList: result.priceDiff,
                  restorationId: 'priceDiff',
                  text:
                      'As seguintes ${result.priceDiff.length} contas não foram encontradas no extrato:',
                  singularText:
                      'A seguinte conta não foi encontrada no extrato:',
                  voidText: 'Todas as contas foram encontradas no extrato',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height > 570 ? 20.0 : 10,
                ),
                //Contas com mesmo preço e diferente fornecedor
                ReportAnalysisEntry(
                  myDataList: result.supplierDiff,
                  restorationId: 'supplierDiff',
                  text:
                      'As seguintes ${result.supplierDiff.length} contas encontradas no extrato porém possuem fornecedor incompatível:',
                  singularText:
                      'A seguinte conta encontrada no extrato porém possui fornecedor incompatível:',
                  voidText: 'Nenhuma conta com fornecedor incompatível.',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height > 570 ? 20.0 : 10,
                ),
                //Contas com discrepância de data DateDiff
                ReportAnalysisEntry(
                    myDataList: result.dateDiff,
                    restorationId: 'dateDiff',
                    text:
                        'As seguintes ${result.dateDiff.length} contas possuem discrepância maior que 3 dias no seu pagamento:',
                    singularText:
                        'A seguinte conta possui discrepância maior que 3 dias no seu pagamento:',
                    voidText: 'Nenhuma discrepância de data encontrada.'),

                SizedBox(
                  height: MediaQuery.of(context).size.height > 570 ? 20.0 : 10,
                ),
                //Duplicates
                ReportAnalysisEntry(
                  myDataList: result.duplicates,
                  restorationId: 'duplicates',
                  text:
                      'As seguintes ${result.duplicates.length} contas estão duplicadas ou são incompatíveis:',
                  singularText:
                      'A seguinte conta está duplicada ou é incompatível:',
                  voidText: 'Nenhuma conta duplicada ou incompatível.',
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
