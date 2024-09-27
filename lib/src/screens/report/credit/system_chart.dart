import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SystemChart extends StatefulWidget {
  final ResultCredit result;
  const SystemChart({super.key, required this.result});

  @override
  State<SystemChart> createState() => _SystemChartState();
}

class _SystemChartState extends State<SystemChart> {
  late List<MapEntry<String, double>> suppliers;
  late Map<String, double> combinedEntries;
  double total = 0;
  int? touchedIndex;
  @override
  void initState() {
    super.initState();
    combinedEntries = combineEntries(widget.result.systemPriceSums);
    suppliers = getSuppliers(combinedEntries);
    total = suppliers.fold(0, (sum, amount) => sum + amount.value);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: createSections(suppliers, touchedIndex, total),
            ),
          ),
        ),
        SizedBox(
          width: 280,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final isSelected = index == touchedIndex;
              final supplier = suppliers[index];
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
                enabled: touchedIndex == null
                    ? true
                    : isSelected
                        ? true
                        : false,
                leading: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: touchedIndex == null
                          ? pieColors[index]
                          : index == touchedIndex
                              ? pieColors[index]
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8)),
                ),
                title: Text(
                  'R\$ ${supplier.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isSelected ? Colors.yellowAccent : null,
                  ),
                ),
                subtitle: Text(
                  supplier.key,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

List<PieChartSectionData> createSections(
  List<MapEntry<String, double>> entriesToDisplay,
  int? selectedIndex,
  double total,
) {
  List<PieChartSectionData> sections = [];

  // Calculate the total sum of all supplier amounts

  // Iterate over the entries to display
  for (int i = 0; i < entriesToDisplay.length; i++) {
    final entry = entriesToDisplay[i];
    final String supplier = entry.key;
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

List<MapEntry<String, double>> getSuppliers(Map<String, double> priceSums) {
  List<MapEntry<String, double>> suppliers = [];

  final entries = priceSums.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value)); // Sort from highest to lowest
  // Prepare the entries to display

  if (entries.length > 5) {
    // Take the first 4 entries
    suppliers = entries.sublist(0, 4);

    // Sum up the rest of the entries into 'Others'
    double othersAmount =
        entries.sublist(4).fold(0, (sum, entry) => sum + entry.value);
    suppliers.add(MapEntry('Outros', othersAmount));
  } else {
    // If 5 or fewer entries, use them all
    suppliers = entries;
  }
  return suppliers;
}

Map<String, double> combineEntries(Map<String, double> priceSums) {
  double creditSum = 0;
  double debitSum = 0;
  Map<String, double> combinedSums = {};

  priceSums.forEach((key, value) {
    if (key.toLowerCase().contains('credito')) {
      creditSum += value;
    } else if (key.toLowerCase().contains('debito')) {
      debitSum += value;
    } else {
      combinedSums[key] = value;
    }
  });

  if (creditSum > 0) {
    combinedSums['Credito'] = creditSum;
  }
  if (debitSum > 0) {
    combinedSums['Debito'] = debitSum;
  }

  return combinedSums;
}
