import 'package:bank_check/src/utils/constants.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  final List<MapEntry<String, double>> bankSuppliers;
  final List<MapEntry<Color, double>> bankList;
  double bankTotal;
  Test(
      {super.key,
      required this.bankSuppliers,
      required this.bankList,
      required this.bankTotal});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<int> touchedIndexes = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.bankSuppliers.length,
        itemBuilder: (context, index) {
          final isSelected = touchedIndexes.contains(index);
          final supplier = widget.bankSuppliers[index];
          return ListTile(
            onTap: () {
              setState(() {
                if (touchedIndexes.contains(index)) {
                  touchedIndexes.remove(index);
                  widget.bankList.add(MapEntry(
                      pieColors[widget.bankSuppliers.indexOf(supplier)],
                      supplier.value));
                  widget.bankTotal += supplier.value;
                } else {
                  touchedIndexes.add(index);
                  widget.bankList
                      .removeWhere((item) => item.value == supplier.value);
                  widget.bankTotal -= supplier.value;
                }
              });
            },
            horizontalTitleGap: 12.0,
            selectedColor: Colors.grey[200],
            dense: true,
            leading: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  color: isSelected ? Colors.grey[500] : pieColors[index],
                  borderRadius: BorderRadius.circular(8)),
            ),
            title: Text(
              'R\$ ${supplier.value.toStringAsFixed(2)}',
              style: TextStyle(
                color: isSelected ? Colors.grey[500] : null,
              ),
            ),
            subtitle: Text(
              supplier.key,
              style: TextStyle(
                color: isSelected ? Colors.grey[500] : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
