import 'dart:io';

import 'package:bank_check/src/methods.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';

// Define the data types to search for
DebitColumns debitColumns = DebitColumns(
  dateNames: [
    'DataPagamento',
    'Data Pagamento',
    /* 'DataVencimento',
    'Data Vencimento' */
  ],
  priceNames: [
    'ValorPago',
    'Valor Pago',
    /* 'ValorPagamento',
    'Valor p/ Pagamento',
    'Valor', */
  ],
  supplierNames: [
    'FornecedorRazaoSocial',
    'Fornecedor Razão Social',
    'FornecedorNomeFantasia',
    'Fornecedor Nome Fantasia',
  ],
);

List<String> columnNamesDebit = [
  'Data Vencimento',
  'Valor p/ Pagamento',
  'Fornecedor Nome Fantasia',
  'Fornecedor Razão Social',
];
List<String> columnNamesCredit = [
  'Data Vencimento',
  'Valor',
  'Tipo Pag.',
  'Vendedor',
];

Result compareDebit(context, File file, File file2) {
  debitColumns.dateIndexes = [];
  debitColumns.priceIndexes = [];
  debitColumns.supplierIndexes = [];
  List<MyData> bankDataList = [];
  List<MyData> systemDataList = [];
  List<MyData> priceDiff = [];
  List<MyData> dateDiff = [];
  List<MyData> missingPayments = [];
  List<MyData> paymentsFound = [];
  List<MyData> duplicates = [];
  List<MyData> supplierDiff = [];
  List<int> valuesUsed = [];
  List<int> systemIndicesUsed = [];
  Sheet table = readSheet(file);
  Sheet table2 = readSheet(file2);
  readDebit(table, bankDataList);
  readSystemDebit(context, table2, systemDataList);
  print(bankDataList.length);
  print(systemDataList.length);
  systemDataList.sort((a, b) => a.date.compareTo(b.date));

  // Create a Map to index bankDataList by price
  // coloca em uma lista todos as contas de preços iguais
  Map<double, List<MyData>> bankDataMap = {};
  for (var data in bankDataList) {
    bankDataMap.putIfAbsent(data.price, () => []).add(data);
  }

  for (int i = 0; i < systemDataList.length; i++) {
    final systemData = systemDataList[i];
    final matchingBankData = bankDataMap[systemData.price];

    if (matchingBankData == null || matchingBankData.isEmpty) {
      priceDiff.add(systemData);
      systemIndicesUsed.add(i);
      continue;
    }

    bool found = false;
    for (var bankData in matchingBankData) {
      if (valuesUsed.contains(bankDataList.indexOf(bankData))) continue;
      int days = bankData.date.difference(systemData.date).inDays.abs();
      if (days <= 2) {
        paymentsFound.add(systemData);
        valuesUsed.add(bankDataList.indexOf(bankData));
        systemIndicesUsed.add(i);
        found = true;
        break;
      }
    }

    if (!found) {
      dateDiff.add(systemData);
      systemIndicesUsed.add(i);
    }
  }

  // Update duplicates list
  duplicates = systemDataList
      .where((element) =>
          !systemIndicesUsed.contains(systemDataList.indexOf(element)))
      .toList();

  //Análise Extrato X Despesas do Sistema

  for (int i = 0; i < bankDataList.length; i++) {
    if (!systemDataList.any((e) => e.price == bankDataList[i].price)) {
      missingPayments.add(bankDataList[i]);
    }
  }
  //print(missingPayments);
  //print(dateDiff);
  //print(indices);
  //print(count);
  missingPayments.sort((a, b) => a.date.compareTo(b.date));
  priceDiff.sort((a, b) => a.date.compareTo(b.date));
  dateDiff.sort((a, b) => a.date.compareTo(b.date));
  paymentsFound.sort((a, b) => a.date.compareTo(b.date));
  final result = ResultDebit(
    name: basename(file.path),
    name2: basename(file2.path),
    type: 'despesas',
    time: DateTime.now(),
    missingPayments: missingPayments,
    priceDiff: priceDiff,
    dateDiff: dateDiff,
    paymentsFound: paymentsFound,
    duplicates: duplicates,
    supplierDiff: supplierDiff,
  );
  return result;
}

Result compareCredit(context, File file, File file2) {
  List<MyData> bankDataList = [];
  List<MyData> systemDataList = [];
  int lastCreditDay = 1;

  Sheet table = readSheet(file);
  Sheet table2 = readSheet(file2);
  lastCreditDay = readCredit(table, bankDataList);
  readSystemCredit(context, table2, systemDataList, lastCreditDay);
  print('length');
  print(bankDataList.length);
  print(systemDataList.length);
  Map<String, double> bankPriceSums = {};
  Map<String, double> systemPriceSums = {};

  for (var data in bankDataList) {
    if (bankPriceSums.containsKey(data.supplier)) {
      bankPriceSums[data.supplier] = bankPriceSums[data.supplier]! + data.price;
    } else {
      bankPriceSums[data.supplier] = data.price;
    }
  }
  for (var data in systemDataList) {
    if (systemPriceSums.containsKey(data.supplier)) {
      systemPriceSums[data.supplier] =
          systemPriceSums[data.supplier]! + data.price;
    } else {
      systemPriceSums[data.supplier] = data.price;
    }
  }

  final result = ResultCredit(
      name: basename(file.path),
      name2: basename(file2.path),
      type: 'receitas',
      time: DateTime.now(),
      bankPriceSums: bankPriceSums,
      systemPriceSums: systemPriceSums,
      bankDataList: bankDataList,
      systemDataList: systemDataList);
  return result;
}

void readDebit(Sheet table, List<MyData> bankDataList) {
  for (int row = 4; row < table.maxRows - 3; row++) {
    if (table.rows[row][9] == null ||
        table.rows[row][9]!.value.toString() != 'D') {
      continue;
    }

    final date = dateFormat.parse(table.rows[row][0]!.value.toString());
    final price = double.parse(table.rows[row][8]!.value
        .toString()
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var supplier = table.rows[row][10]!.value.toString();

    if (supplier.replaceAll(' ', '') == '') {
      supplier = table.rows[row][7]!.value.toString();
    }

    final data = MyData(date, price, supplier);

    bankDataList.add(data);
  }
}

int readCredit(Sheet table, List<MyData> bankDataList) {
  int lastCreditDay = 1;
  for (int row = 4; row < table.maxRows - 3; row++) {
    if (table.rows[row][9]!.value.toString() != 'C') {
      continue;
    }
    final date = dateFormat.parse(table.rows[row][0]!.value.toString());
    if (date.day == 1) {
      continue;
    }
    if (date.day > lastCreditDay) {
      lastCreditDay = date.day;
    }
    final price = double.parse(table.rows[row][8]!.value
        .toString()
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var supplier = table.rows[row][7]!.value.toString();

    final data = MyData(date, price, supplier);
    bankDataList.add(data);
  }
  return lastCreditDay;
}

// Read the data from the user's system table file
void readSystemDebit(context, Sheet table, List<MyData> systemDataList) {
  for (String name in debitColumns.dateNames) {
    for (var cell in table.rows[0]) {
      if (cell != null && name == cell.value.toString()) {
        debitColumns.dateIndexes.add(cell.columnIndex);
      }
    }
  }
  for (String name in debitColumns.priceNames) {
    for (var cell in table.rows[0]) {
      if (cell != null && name == cell.value.toString()) {
        debitColumns.priceIndexes.add(cell.columnIndex);
      }
    }
  }
  for (String name in debitColumns.supplierNames) {
    for (var cell in table.rows[0]) {
      if (cell != null && name == cell.value.toString()) {
        debitColumns.supplierIndexes.add(cell.columnIndex);
      }
    }
  }
  //List<int> valuesList = columnIndices.values.toList();
  print(debitColumns.columnIndexes);
  print(debitColumns.indexesFound);
  if (debitColumns.indexesFound == false) {
    showErrorSnackBar(context,
        'ERRO: Não foi possível encontrar as colunas necessárias no arquivo 2.');

    return;
  }
  print("table.maxRows ${table.maxRows}");
  for (int row = 1; row < table.maxRows; row++) {
    DateTime date = DateTime.now();
    double price = 0.0;
    String supplier = '';
    if (table.rows[row][debitColumns.priceIndexes[0]] == null) {
      //##!!PODE CAUSAR ERRO??!!
      continue;
    }
    for (int i = 0; i < debitColumns.dateIndexes.length; i++) {
      if (table.rows[row][debitColumns.dateIndexes[i]] == null) {
        break;
      }
      String dateString =
          table.rows[row][debitColumns.dateIndexes[i]]!.value.toString();
      if (dateString == '') {
        continue;
      }
      date = DateTime.parse(dateString);
    }
    for (int i = 0; i < debitColumns.priceIndexes.length; i++) {
      final test =
          table.rows[row][debitColumns.priceIndexes[i]]!.value.toString();
      if (test == '') {
        continue;
      }
      price = double.parse(test);
    }
    for (int i = 0; i < debitColumns.supplierIndexes.length; i++) {
      final test =
          table.rows[row][debitColumns.supplierIndexes[i]]!.value.toString();
      if (test == '') {
        continue;
      }
      supplier = test;
    }
    final data = MyData(date, price, supplier);
    print(data);
    systemDataList.add(data);
  }
}

void readSystemCredit(
    context, Sheet table, List<MyData> systemDataList, int lastCreditDay) {
  Map<String, int> columnIndices = {};

  // Identify the columns that match the specified data types
  for (var cell in table.rows[0]) {
    if (cell != null && columnNamesCredit.contains(cell.value.toString())) {
      columnIndices[cell.value.toString()] = cell.columnIndex;
    }
  }
  if (columnIndices.isEmpty || columnIndices.length < 3) {
    showErrorSnackBar(context,
        'ERRO: Não foi possível encontrar as colunas necessárias no arquivo 2.');

    return;
  }
  List<int> valuesList = columnIndices.values.toList();
  for (int row = 1; row < table.maxRows; row++) {
    String dateString = table.rows[row][valuesList[0]]!.value.toString();
    if (dateString == '') {
      continue;
    }
    final date = DateTime.parse(dateString);
    if (date.day >= lastCreditDay) {
      continue;
    }
    final price =
        double.parse(table.rows[row][valuesList[1]]!.value.toString());

    final supplier = table.rows[row][valuesList[2]]!.value.toString();
    final seller = table.rows[row][valuesList[3]]!.value.toString();
    final data = MyData(date, price, supplier, seller);
    systemDataList.add(data);
  }
}

Sheet readSheet(File file) {
  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var table = excel.tables.values.first;

  return table;
}
