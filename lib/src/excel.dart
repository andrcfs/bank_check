import 'dart:io';

import 'package:bank_check/src/constants.dart';
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

Map<String, dynamic> compare(context, File file, File file2) {
  isError = false;
  List<Data> transformedData = [];
  List<Data> transformedData2 = [];
  List<Data> priceDiff = [];
  List<Data> dateDiff = [];
  List<Data> missingPayments = [];
  List<Data> paymentsFound = [];
  indices = [];
  Sheet table = read(file);
  Sheet table2 = read(file2);
  transform(table, transformedData);
  transform2(context, table2, transformedData2);
  print(transformedData.length);
  print(transformedData2.length);

  for (int i = 0; i < transformedData2.length; i++) {
    final List indexes = [];
    indexes.addAll(transformedData['Valor']
        .where((e) => e == transformedData2['Valor'][i]));
    final int index =
        transformedData['Valor'].indexOf(transformedData2['Valor'][i]);
    final DateTime date;
    if (index < 0) {
      priceDiff['Data'].add(transformedData2['Data'][i]);
      priceDiff['Valor'].add(transformedData2['Valor'][i]);
      priceDiff['Fornecedor'].add(transformedData2['Fornecedor'][i]);
      indices.add(i);
      continue;
    } else {
      date = transformedData['Data'][index];
    }

    final int days = date.difference(transformedData2['Data'][i]).inDays;

    if (days.abs() <= 2) {
      paymentsFound['Data'].add(transformedData2['Data'][i]);
      paymentsFound['Valor'].add(transformedData2['Valor'][i]);
      paymentsFound['Fornecedor'].add(transformedData2['Fornecedor'][i]);
      continue;
    } else if (indexes.length < 2 && days.abs() % 7 != 0) {
      dateDiff['Data'].add(transformedData2['Data'][i]);
      dateDiff['Valor'].add(transformedData2['Valor'][i]);
      dateDiff['Fornecedor'].add(transformedData2['Fornecedor'][i]);
      indices.add(i);
    }
  }
  for (int i = 0; i < transformedData.values.first.length; i++) {
    if (!transformedData2['Valor'].contains(transformedData['Valor'][i])) {
      missingPayments['Data'].add(transformedData['Data'][i]);
      missingPayments['Valor'].add(transformedData['Valor'][i]);
      missingPayments['Fornecedor'].add(transformedData['Fornecedor'][i]);
    }
  }
  //print(missingPayments);
  //print(dateDiff);
  //print(indices);
  //print(count);
  return {
    'name': basename(file.path),
    'name2': basename(file2.path),
    'time': DateTime.now(),
    'missingPayments': missingPayments,
    'priceDiff': priceDiff,
    'dateDiff': dateDiff,
    'paymentsFound': paymentsFound,
  };
}

void transform(Sheet table, List<Data> transformedData) {
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
    var supplier = table.rows[row][10]!.value.toString().replaceAll(' ', '');

    if (supplier == '') {
      supplier = table.rows[row][7]!.value.toString();
    }

    final data = Data(date, price, supplier);
    transformedData.add(data);
  }
}

void transform2(context, Sheet table, List<Data> transformedData2) {
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
    final data = Data(date, price, supplier);
    transformedData2.add(data);
  }
}

Sheet read(File file) {
  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var table = excel.tables.values.first;

  return table;
}

class Data {
  final DateTime date;
  final double price;
  final String supplier;

  Data(this.date, this.price, this.supplier);
}
