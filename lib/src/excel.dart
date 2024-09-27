import 'dart:io';

import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

// Define the data types to search for
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

List<int> indices = [];
bool isError = false;

Result compareDebit(context, File file, File file2) {
  isError = false;
  List<MyData> bankDataList = [];
  List<MyData> systemDataList = [];
  List<MyData> priceDiff = [];
  List<MyData> dateDiff = [];
  List<MyData> missingPayments = [];
  List<MyData> paymentsFound = [];
  indices = [];
  Sheet table = readSheet(file);
  Sheet table2 = readSheet(file2);
  readDebit(table, bankDataList);
  readSystemDebit(context, table2, systemDataList);
  print(bankDataList.length);
  print(systemDataList.length);

  for (int i = 0; i < systemDataList.length; i++) {
    final List<MyData> indexes =
        bankDataList.where((e) => e.price == systemDataList[i].price).toList();
    final int index =
        bankDataList.indexWhere((e) => e.price == systemDataList[i].price);
    final DateTime date;
    if (index < 0) {
      priceDiff.add(systemDataList[i]);
      continue;
    } else {
      date = bankDataList[index].date;
    }

    final int days = date.difference(systemDataList[i].date).inDays;

    if (days.abs() <= 2) {
      paymentsFound.add(systemDataList[i]);
      continue;
    } else if (indexes.length < 2 && days.abs() % 7 != 0) {
      dateDiff.add(systemDataList[i]);
    }
  }
  for (int i = 0; i < bankDataList.length; i++) {
    if (!systemDataList.any((e) => e.price == bankDataList[i].price)) {
      missingPayments.add(bankDataList[i]);
    }
  }
  //print(missingPayments);
  //print(dateDiff);
  //print(indices);
  //print(count);
  final result = ResultDebit(
      name: basename(file.path),
      name2: basename(file2.path),
      type: 'despesas',
      time: DateTime.now(),
      missingPayments: missingPayments,
      priceDiff: priceDiff,
      dateDiff: dateDiff,
      paymentsFound: paymentsFound);
  return result;
}

Result compareCredit(context, File file, File file2) {
  isError = false;
  List<MyData> bankDataList = [];
  List<MyData> systemDataList = [];
  int lastCreditDay = 1;

  indices = [];
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
    if (table.rows[row][9]!.value.toString() != 'D') {
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

void readSystemDebit(context, Sheet table, List<MyData> systemDataList) {
  Map<String, int> columnIndices = {};
  // Identify the columns that match the specified data types
  for (var cell in table.rows[0]) {
    if (cell != null && columnNamesDebit.contains(cell.value.toString())) {
      columnIndices[cell.value.toString()] = cell.columnIndex;
    }
  }
  if (columnIndices.isEmpty || columnIndices.length < 3) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'ERRO: Não foi possível encontrar as colunas necessárias no arquivo 2.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        elevation: 1,
        duration: Duration(seconds: 5),
      ),
    );
    isError = true;
    return;
  }
  List<int> valuesList = columnIndices.values.toList();
  for (int row = 1; row < table.maxRows; row++) {
    String dateString = table.rows[row][valuesList[0]]!.value.toString();
    if (dateString == '') {
      continue;
    }
    final date = DateTime.parse(dateString);
    final price =
        double.parse(table.rows[row][valuesList[1]]!.value.toString());

    var supplier =
        table.rows[row][valuesList[3]]!.value.toString().replaceAll(' ', '');
    if (supplier == '' && valuesList.length > 3) {
      supplier = table.rows[row][valuesList[2]]!.value.toString();
    }
    final data = MyData(date, price, supplier);
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'ERRO: Não foi possível encontrar as colunas necessárias no arquivo 2.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        elevation: 1,
        duration: Duration(seconds: 5),
      ),
    );
    isError = true;
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
