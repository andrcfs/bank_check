import 'package:bank_check/src/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CreditPieChart extends StatefulWidget {
  final double total;
  final List<MapEntry<String, double>> suppliers;
  final List<String> others;
  const CreditPieChart(
      {super.key,
      required this.total,
      required this.suppliers,
      required this.others});

  @override
  State<CreditPieChart> createState() => _CreditPieChartState();
}

class _CreditPieChartState extends State<CreditPieChart> {
  int? touchedIndex;
  List<String> othersList = [];
  Set<int> selectedList = {};
  String others = 'Outros';
  double total = 0.0;
  List<MapEntry<Color, double>> selectedSupplier = [];

  @override
  void initState() {
    super.initState();
    selectedSupplier = widget.suppliers
        .map((supplier) => MapEntry(
            pieColors[widget.suppliers.indexOf(supplier)], supplier.value))
        .toList();
    if (widget.others.isNotEmpty) {
      othersList = widget.others.map((e) => e.trim()).toList();
      others = othersList.join(', ');
    } else {
      others = widget.suppliers.last.key;
    }
    total = widget.total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Receitas',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'R\$ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 180,
              width: 180,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = null;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: createSections(widget.suppliers, selectedSupplier,
                      selectedList, touchedIndex),
                ),
              ),
            ),
            SizedBox(
              width: 280,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.suppliers.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedList.contains(index);
                  final supplier = widget.suppliers[index];
                  return ListTile(
                    onLongPress: () {
                      setState(() {
                        if (isSelected) return;
                        touchedIndex = touchedIndex == index ? null : index;
                      });
                    },
                    onTap: () {
                      setState(() {
                        touchedIndex = null;
                        if (selectedList.contains(index)) {
                          selectedSupplier.add(MapEntry(
                              pieColors[widget.suppliers.indexOf(supplier)],
                              supplier.value));
                          selectedList.remove(index);
                          total += supplier.value;
                        } else {
                          if (selectedSupplier.length == 1) return;
                          selectedSupplier.removeWhere(
                              (item) => item.value == supplier.value);
                          selectedList.add(index);
                          total -= supplier.value;
                        }
                      });
                    },
                    horizontalTitleGap: 12.0,
                    selected: touchedIndex == index,
                    selectedColor: Colors.grey[200],
                    dense: true,
                    leading: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color:
                              !isSelected ? pieColors[index] : Colors.grey[500],
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    /* trailing: IconButton(
                        onPressed: () {
                          setState(() {
                           
                        },
                        icon: Icon(isChecked
                            ? Icons.indeterminate_check_box_rounded
                            : Icons.check_box_outline_blank)), */
                    title: Text(
                      'R\$ ${supplier.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: touchedIndex == null
                            ? null
                            : index == touchedIndex
                                ? Colors.yellowAccent
                                : null,
                      ),
                    ),
                    subtitle: Text(
                      touchedIndex == 4 && index == 4 ? others : supplier.key,
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
        ),
      ],
    );
  }
}

List<PieChartSectionData> createSections(
  List<MapEntry<String, double>> entries,
  List<MapEntry<Color, double>> entriesToDisplay,
  Set<int> selectedList,
  int? focusedIndex,
) {
  List<PieChartSectionData> sections = [];

  // Calculate the total sum of all supplier amounts
  double total = entriesToDisplay.fold(0, (sum, amount) => sum + amount.value);

  // Iterate over the entries to display
  for (int i = 0; i < entriesToDisplay.length; i++) {
    final entry = entriesToDisplay[i];
    final double amount = entry.value;

    bool isFocused = false;
    double fontSize = 16.0;
    if (focusedIndex != null && focusedIndex > 0) {
      isFocused = entries[focusedIndex].value == entry.value;
      fontSize = isFocused ? 25.0 : 12.0;
    }
    final double radius = isFocused ? 60 : 50;

    // Calculate the percentage contribution of each supplier
    double percentage = (amount / total) * 100;

    // Assign color from the predefined list
    Color color = entry.key;

    // Create the PieChartSectionData
    PieChartSectionData section = PieChartSectionData(
      color: color,
      value: amount,
      title: '${percentage.toStringAsFixed(1)}%',
      radius: radius, // Adjust the radius as needed
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
      ),

      /* badgeWidget: isSelected
          ? Column(
              children: [
                Text(
                  supplier,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'R\$ ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : null, */
      // Optionally, add badge widgets or other properties
    );

    sections.add(section);
  }

  // Return the list of sections
  return sections;
}
