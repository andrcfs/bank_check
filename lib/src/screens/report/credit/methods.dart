List<MapEntry<String, double>> getSuppliers(
    Map<String, double> bankPriceSums, List<String> others) {
  List<MapEntry<String, double>> suppliers = [];
  final entries = bankPriceSums.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value)); // Sort from highest to lowest

  // Prepare the entries to display

  if (entries.length > 5) {
    // Take the first 4 entries
    suppliers = entries.sublist(0, 4);
    others.addAll(entries.sublist(4).map((entry) => entry.key).toList());
    print(others);

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
