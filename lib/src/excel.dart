import 'dart:io';

import 'package:bank_check/src/variables.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

// Define the data types to search for
List<String> columnNames = [
  'Data Vencimento',
  'Valor p/ Pagamento',
  'Fornecedor Razão Social'
];
Map<String, int> columnIndices = {};
List<int> indices = [];

Map<String, Map<String, List>> compare(context, File file, File file2) {
  isError = false;
  Map<String, List> transformedData = {
    'Data': [],
    'Valor': [],
    'Fornecedor': [],
  };
  Map<String, List> transformedData2 = {
    'Data': [],
    'Valor': [],
    'Fornecedor': []
  };
  Map<String, List> priceDiff = {
    'Data': [],
    'Valor': [],
    'Fornecedor': [],
  };
  Map<String, List> dateDiff = {
    'Data': [],
    'Valor': [],
    'Fornecedor': [],
  };
  int count = 0;
  indices = [];
  Sheet table = read(file);
  Sheet table2 = read(file2);
  transform(table, transformedData);
  transform2(context, table2, transformedData2);
  print(transformedData.values.first.length);
  print(transformedData2.values.first.length);

  for (int i = 0; i < transformedData2.values.first.length; i++) {
    final List indexes = [];
    indexes.addAll(transformedData['Valor']!
        .where((e) => e == transformedData2['Valor']![i]));
    final int index =
        transformedData['Valor']!.indexOf(transformedData2['Valor']![i]);
    final DateTime date;
    if (index < 0) {
      priceDiff['Data']!.add(transformedData2['Data']![i]);
      priceDiff['Valor']!.add(transformedData2['Valor']![i]);
      priceDiff['Fornecedor']!.add(transformedData2['Fornecedor']![i]);
      indices.add(i);
      continue;
    } else {
      date = transformedData['Data']![index];
    }

    final int days = date.difference(transformedData2['Data']![i]).inDays;

    if (days.abs() <= 2) {
      count++;
    } else if (indexes.length < 2 && days.abs() % 7 != 0) {
/*       print('indexes ${indexes.length}');
      print(days.abs());
      print(
          'valor:${transformedData2['Valor']![i]}, data:${transformedData2['Data']![i]}'); */
      dateDiff['Data']!.add(transformedData2['Data']![i]);
      dateDiff['Valor']!.add(transformedData2['Valor']![i]);
      dateDiff['Fornecedor']!.add(transformedData2['Fornecedor']![i]);
      indices.add(i);
    }
  }
  print(dateDiff);
  print(indices);
  print(count);
  return {'priceDiff': priceDiff, 'dateDiff': dateDiff};
}

void transform(Sheet table, Map<String, List> transformedData) {
  // Identify the columns that match the specified data types
  for (int row = 4; row < table.maxRows - 2; row++) {
    var date = dateFormat.parse(table.rows[row][0]!.value.toString());
    var price = double.parse(table.rows[row][8]!.value
        .toString()
        .replaceAll('.', '')
        .replaceAll(',', '.'));

    transformedData['Data']!.add(date);
    transformedData['Valor']!.add(price);
    transformedData['Fornecedor']!.add(table.rows[row][10]!.value);
  }
}

void transform2(context, Sheet table, Map<String, List> transformedData2) {
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
    DateCellValue date = table.rows[row][valuesList[0]]!.value as DateCellValue;
    transformedData2['Data']!.add(date.asDateTimeLocal());
    var price = double.parse(table.rows[row][valuesList[1]]!.value.toString());
    transformedData2['Valor']!.add(price);
    transformedData2['Fornecedor']!.add(table.rows[row][valuesList[2]]!.value);
  }
}

Sheet read(File file) {
  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var table = excel.tables.values.first;

  return table;
}
