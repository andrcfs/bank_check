import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:flutter/material.dart';

class MatchingPaymentsReport extends StatelessWidget {
  const MatchingPaymentsReport({
    super.key,
    required this.result,
  });

  final ResultDebit result;

  @override
  Widget build(BuildContext context) {
    final double porcentagem = result.paymentsFound.length *
        100 /
        (result.paymentsFound.length +
            result.missingPayments.length +
            result.priceDiff.length +
            result.dateDiff.length +
            result.duplicates.length +
            result.supplierDiff.length);
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width - 16,
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height > 570 ? 8.0 : 4,
          horizontal: 12.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    result.paymentsFound.isNotEmpty
                        ? result.paymentsFound.length > 1
                            ? 'Os seguintes ${result.paymentsFound.length} pagamentos estão conciliados:'
                            : 'Apenas um pagamento está conciliado:'
                        : 'Nenhum pagamento encontrado.',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text('Porcentagem: ${porcentagem.toStringAsFixed(1)}%'),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 8.0 : 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: result.paymentsFound.isNotEmpty
                    ? [
                        const Text('Data'),
                        const Text('Fornecedor'),
                        const Text('Valor(R\$)'),
                      ]
                    : [],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 4.0 : 2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.39,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  restorationId: 'paymentsFound',
                  shrinkWrap: true,
                  itemCount: result.paymentsFound.length,
                  itemBuilder: (context, index) {
                    DateTime date = result.paymentsFound[index].date;
                    String formattedDate = dateFormatShort.format(date);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(fontSize: 11),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              result.paymentsFound[index].supplier,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          Text(result.paymentsFound[index].price
                              .toStringAsFixed(2)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 4.0 : 2,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    result.paymentsFound.length > 1
                        ? 'Total: R\$ ${result.paymentsFound.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}'
                        : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 8.0 : 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
