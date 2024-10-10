import 'package:bank_check/src/screens/report/credit/comparison_chart.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:flutter/material.dart';

class ComparisonSection extends StatefulWidget {
  final List<MapEntry<String, double>> bankSuppliers;
  final List<MapEntry<String, double>> systemSuppliers;
  const ComparisonSection(
      {super.key, required this.bankSuppliers, required this.systemSuppliers});

  @override
  State<ComparisonSection> createState() => _ComparisonSectionState();
}

class _ComparisonSectionState extends State<ComparisonSection> {
  List<MapEntry<Color, double>> bankList = [];
  List<MapEntry<Color, double>> systemList = [];
  double bankTotal = 0;
  double systemTotal = 0;
  List<int> touchedIndexes = [];
  List<int> touchedIndexes2 = [];
  @override
  void initState() {
    super.initState();
    bankList = widget.bankSuppliers
        .map((supplier) => MapEntry(
            pieColors[widget.bankSuppliers.indexOf(supplier)], supplier.value))
        .toList();
    systemList = widget.systemSuppliers
        .map((supplier) => MapEntry(
            pieColors[widget.systemSuppliers.indexOf(supplier)],
            supplier.value))
        .toList();
    bankTotal =
        widget.bankSuppliers.fold(0, (sum, amount) => sum + amount.value);
    systemTotal =
        widget.systemSuppliers.fold(0, (sum, amount) => sum + amount.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ComparisonChart(
          bankTotal: bankTotal,
          systemTotal: systemTotal,
          bankSuppliers: bankList,
          systemSuppliers: systemList,
        ),
        Row(
          children: [
            SizedBox(
              width: 160,
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
                          bankList.add(MapEntry(
                              pieColors[widget.bankSuppliers.indexOf(supplier)],
                              supplier.value));
                          bankTotal += supplier.value;
                        } else {
                          touchedIndexes.add(index);
                          bankList.removeWhere(
                              (item) => item.value == supplier.value);
                          bankTotal -= supplier.value;
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
                          color:
                              isSelected ? Colors.grey[500] : pieColors[index],
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected ? Colors.grey[500] : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 160,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.systemSuppliers.length,
                itemBuilder: (context, index) {
                  final isSelected = touchedIndexes2.contains(index);
                  final supplier = widget.systemSuppliers[index];
                  return ListTile(
                    onTap: () {
                      setState(() {
                        if (touchedIndexes2.contains(index)) {
                          touchedIndexes2.remove(index);
                          systemList.add(MapEntry(
                              pieColors[
                                  widget.systemSuppliers.indexOf(supplier)],
                              supplier.value));
                          systemTotal += supplier.value;
                        } else {
                          touchedIndexes2.add(index);
                          systemList.removeWhere(
                              (item) => item.value == supplier.value);
                          systemTotal -= supplier.value;
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
                          color:
                              isSelected ? Colors.grey[500] : pieColors[index],
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected ? Colors.grey[500] : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
