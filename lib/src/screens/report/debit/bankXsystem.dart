import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:flutter/material.dart';

class BankXSystemReport extends StatelessWidget {
  const BankXSystemReport({
    super.key,
    required this.result,
  });

  final ResultDebit result;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width - 16,
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height > 570 ? 8.0 : 4,
          horizontal: 12.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        /* border: Border.all(
          color: Colors.blue,
          width: 1.5,
        ), */
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
                result.missingPayments.isNotEmpty
                    ? result.missingPayments.length > 1
                        ? 'Os seguintes ${result.missingPayments.length} pagamentos não constam nas contas do sistema:'
                        : 'O seguinte pagamento não consta nas contas do sistema:'
                    : 'Todos os pagamentos do extrato foram encontrados no sistema.',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 8.0 : 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: result.missingPayments.isNotEmpty
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
                  restorationId: 'missingPayments',
                  shrinkWrap: true,
                  itemCount: result.missingPayments.length,
                  itemBuilder: (context, index) {
                    DateTime date = result.missingPayments[index].date;
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
                              result.missingPayments[index].supplier,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          Text(result.missingPayments[index].price
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
                    result.missingPayments.length > 1
                        ? 'Total: R\$ ${result.missingPayments.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}'
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
