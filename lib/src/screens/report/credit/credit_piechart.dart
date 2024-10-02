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
  String others = 'Outros';

  @override
  void initState() {
    super.initState();
    if (widget.others.isNotEmpty) {
      othersList = widget.others.map((e) => e.trim()).toList();
      others = othersList.join(', ');
    } else {
      others = widget.suppliers.last.key;
    }
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
                    'R\$ ${widget.total.toStringAsFixed(2)}',
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
                  sections: createSections(widget.suppliers, touchedIndex),
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
                  final isSelected = index == touchedIndex;
                  final supplier = widget.suppliers[index];
                  return ListTile(
                    onTap: () {
                      setState(() {
                        touchedIndex = touchedIndex == index ? null : index;
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
  List<MapEntry<String, double>> entriesToDisplay,
  int? selectedIndex,
) {
  List<PieChartSectionData> sections = [];

  // Calculate the total sum of all supplier amounts
  double total = entriesToDisplay.fold(0, (sum, amount) => sum + amount.value);

  // Iterate over the entries to display
  for (int i = 0; i < entriesToDisplay.length; i++) {
    final entry = entriesToDisplay[i];
    final double amount = entry.value;
    final isSelected = i == selectedIndex;
    final double radius = isSelected ? 60 : 50;
    final fontSize = selectedIndex == null
        ? 16.0
        : isSelected
            ? 25.0
            : 12.0;

    // Calculate the percentage contribution of each supplier
    double percentage = (amount / total) * 100;

    // Assign color from the predefined list
    Color color = pieColors[i];

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
