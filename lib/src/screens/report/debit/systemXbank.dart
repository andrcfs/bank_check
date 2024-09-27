import 'dart:ui';

import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
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
          width: MediaQuery.of(context).size.width - 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.priceDiff.isNotEmpty
                    ? result.priceDiff.length > 1
                        ? 'As seguintes ${result.priceDiff.length} contas não foram encontradas no extrato:'
                        : 'A seguinte conta não foi encontrada no extrato:'
                    : 'Todas as contas foram encontradas no extrato',
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
                children: result.priceDiff.isNotEmpty
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
                height: clampDouble((result.priceDiff.length).toDouble() * 40,
                    50.0, MediaQuery.of(context).size.height * 0.3),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  restorationId: 'priceDiff',
                  shrinkWrap: true,
                  itemCount: result.priceDiff.length,
                  itemBuilder: (context, index) {
                    DateTime date = result.priceDiff[index].date;
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
                          const SizedBox(
                            width: 12.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              result.priceDiff[index].supplier,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          const SizedBox(
                            width: 7.0,
                          ),
                          Text('${result.priceDiff[index].price}'),
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
                    result.priceDiff.isNotEmpty
                        ? 'Total: R\$ ${result.priceDiff.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}'
                        : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 20.0 : 10,
              ),
              Text(
                result.dateDiff.isNotEmpty
                    ? result.dateDiff.length > 1
                        ? 'As seguintes ${result.dateDiff.length} contas possuem discrepância maior que 3 dias no seu pagamento:'
                        : 'A seguinte conta possui discrepância maior que 3 dias no seu pagamento:'
                    : 'Nenhuma discrepância de data encontrada.',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 8.0 : 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: result.dateDiff.isNotEmpty
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
                height: result.dateDiff.isNotEmpty
                    ? MediaQuery.of(context).size.height - 490
                    : 10,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  restorationId: 'dateDiff',
                  shrinkWrap: true,
                  itemCount: result.dateDiff.length,
                  itemBuilder: (context, index) {
                    DateTime date = result.dateDiff[index].date;
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
                          const SizedBox(
                            width: 12.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              result.dateDiff[index].supplier,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          const SizedBox(
                            width: 7.0,
                          ),
                          Text('${result.dateDiff[index].price}'),
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
                    result.dateDiff.length > 1
                        ? 'Total: R\$ ${result.dateDiff.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}'
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
    );
  }
}
