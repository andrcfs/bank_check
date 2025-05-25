import 'package:flutter/material.dart';

import '../../../../utils/classes.dart';
import '../../../../utils/constants.dart';

class ReportAnalysisEntry extends StatelessWidget {
  final List<MyData> myDataList;
  final String? restorationId;
  final String text;
  final String singularText;
  final String voidText;

  const ReportAnalysisEntry({
    super.key,
    required this.myDataList,
    this.restorationId,
    required this.text,
    required this.singularText,
    required this.voidText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          myDataList.isNotEmpty
              ? myDataList.length > 1
                  ? text
                  : singularText
              : voidText,
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
          children: myDataList.isNotEmpty
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
          height: myDataList.isNotEmpty
              ? MediaQuery.of(context).size.height - 490
              : 10,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            restorationId: restorationId,
            shrinkWrap: true,
            itemCount: myDataList.length,
            itemBuilder: (context, index) {
              DateTime date = myDataList[index].date;
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
                        myDataList[index].supplier,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(
                      width: 7.0,
                    ),
                    Text('${myDataList[index].price}'),
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
              myDataList.length > 1
                  ? 'Total: R\$ ${myDataList.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}'
                  : '',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
