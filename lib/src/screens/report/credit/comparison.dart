import 'package:bank_check/src/screens/report/credit/comparison_chart.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:flutter/material.dart';

class ComparisonSection extends StatefulWidget {
  final double bankTotal;
  final List<MapEntry<String, double>> bankSuppliers;
  final double systemTotal;
  final List<MapEntry<String, double>> systemSuppliers;
  const ComparisonSection(
      {super.key,
      required this.bankTotal,
      required this.bankSuppliers,
      required this.systemTotal,
      required this.systemSuppliers});

  @override
  State<ComparisonSection> createState() => _ComparisonSectionState();
}

class _ComparisonSectionState extends State<ComparisonSection> {
  List<MapEntry<Color, double>> bankList = [];
  List<MapEntry<Color, double>> systemSupplier = [];
  double bankTotal = 0;
  double systemTotal = 0;
  int? touchedIndex;
  @override
  void initState() {
    super.initState();
    bankList = widget.bankSuppliers
        .map((supplier) => MapEntry(
            pieColors[widget.bankSuppliers.indexOf(supplier)], supplier.value))
        .toList();
    systemSupplier = widget.systemSuppliers
        .map((supplier) => MapEntry(
            pieColors[widget.systemSuppliers.indexOf(supplier)],
            supplier.value))
        .toList();
    bankTotal = widget.bankTotal;
    systemTotal = widget.systemTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ComparisonChart(
          bankTotal: bankTotal,
          bankSuppliers: bankList,
          systemTotal: systemTotal,
          systemSuppliers: systemSupplier,
        ),
        SizedBox(
          width: 280,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.bankSuppliers.length,
            itemBuilder: (context, index) {
              final isSelected = index == touchedIndex;
              final supplier = widget.bankSuppliers[index];
              return ListTile(
                onTap: () {
                  setState(() {
                    touchedIndex = touchedIndex == index ? null : index;
                    bankList.removeAt(index);
                  });
                },
                horizontalTitleGap: 12.0,
                selected: isSelected,
                selectedColor: Colors.grey[200],
                dense: true,
                leading: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: touchedIndex == null
                          ? pieColors[index]
                          : index == touchedIndex
                              ? pieColors[index]
                              : Colors.grey[500],
                      borderRadius: BorderRadius.circular(8)),
                ),
                title: Text(
                  'R\$ ${supplier.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: touchedIndex == null
                        ? null
                        : index == touchedIndex
                            ? Colors.yellowAccent
                            : Colors.grey[500],
                  ),
                ),
                subtitle: Text(
                  supplier.key,
                  style: TextStyle(
                    color: touchedIndex == null
                        ? null
                        : index == touchedIndex
                            ? null
                            : Colors.grey[500],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
