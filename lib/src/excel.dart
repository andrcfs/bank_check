import 'dart:io';

import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

// Define the data types to search for
List<String> columnNames = [
  'Data Vencimento',
  'Valor p/ Pagamento',
  'Fornecedor Nome Fantasia',
  'Fornecedor Razão Social',
];
Map<String, int> columnIndices = {};
List<int> indices = [];
bool isError = false;

Result compare(context, File file, File file2) {
  isError = false;
  List<MyData> transformedData = [];
  List<MyData> transformedData2 = [];
  List<MyData> priceDiff = [];
  List<MyData> dateDiff = [];
  List<MyData> missingPayments = [];
  List<MyData> paymentsFound = [];
  indices = [];
  Sheet table = read(file);
  Sheet table2 = read(file2);
  transform(table, transformedData);
  transform2(context, table2, transformedData2);
  print(transformedData.length);
  print(transformedData2.length);

  for (int i = 0; i < transformedData2.length; i++) {
    final List<MyData> indexes = transformedData
        .where((e) => e.price == transformedData2[i].price)
        .toList();
    final int index =
        transformedData.indexWhere((e) => e.price == transformedData2[i].price);
    final DateTime date;
    if (index < 0) {
      priceDiff.add(transformedData2[i]);
      continue;
    } else {
      date = transformedData[index].date;
    }

    final int days = date.difference(transformedData2[i].date).inDays;

    if (days.abs() <= 2) {
      paymentsFound.add(transformedData2[i]);
      continue;
    } else if (indexes.length < 2 && days.abs() % 7 != 0) {
      dateDiff.add(transformedData2[i]);
    }
  }
  for (int i = 0; i < transformedData.length; i++) {
    if (!transformedData2.any((e) => e.price == transformedData[i].price)) {
      missingPayments.add(transformedData[i]);
    }
  }
  //print(missingPayments);
  //print(dateDiff);
  //print(indices);
  //print(count);
  final result = Result(
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

void transform(Sheet table, List<MyData> transformedData) {
  // Identify the columns that match the specified data types
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
    transformedData.add(data);
  }
}

void transform2(context, Sheet table, List<MyData> transformedData2) {
  // Identify the columns that match the specified data types
  for (var cell in table.rows[0]) {
    if (cell != null && columnNames.contains(cell.value.toString())) {
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
  for (int row = 2; row < table.maxRows - 2; row++) {
    final date =
        DateTime.parse(table.rows[row][valuesList[0]]!.value.toString());

    final price =
        double.parse(table.rows[row][valuesList[1]]!.value.toString());

    var supplier =
        table.rows[row][valuesList[3]]!.value.toString().replaceAll(' ', '');
    if (supplier == '' && valuesList.length > 3) {
      supplier = table.rows[row][valuesList[2]]!.value.toString();
    }
    final data = MyData(date, price, supplier);
    transformedData2.add(data);
  }
}

Sheet read(File file) {
  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var table = excel.tables.values.first;

  return table;
}
