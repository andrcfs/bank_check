import 'dart:io';

import 'package:bank_check/src/variables.dart';
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

Map<String, dynamic> compare(context, File file, File file2) {
  isError = false;
  Map<String, List> transformedData = {
    'Data': [],
    'Fornecedor': [],
    'Valor': [],
  };
  Map<String, List> transformedData2 = {
    'Data': [],
    'Fornecedor': [],
    'Valor': [],
  };
  Map<String, List> priceDiff = {
    'Data': [],
    'Fornecedor': [],
    'Valor': [],
  };
  Map<String, List> dateDiff = {
    'Data': [],
    'Fornecedor': [],
    'Valor': [],
  };
  Map<String, List> missingPayments = {
    'Data': [],
    'Fornecedor': [],
    'Valor': [],
  };
  Map<String, List> paymentsFound = {
    'Data': [],
    'Fornecedor': [],
    'Valor': [],
  };
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
      paymentsFound['Data']!.add(transformedData2['Data']![i]);
      paymentsFound['Valor']!.add(transformedData2['Valor']![i]);
      paymentsFound['Fornecedor']!.add(transformedData2['Fornecedor']![i]);
      continue;
    } else if (indexes.length < 2 && days.abs() % 7 != 0) {
      dateDiff['Data']!.add(transformedData2['Data']![i]);
      dateDiff['Valor']!.add(transformedData2['Valor']![i]);
      dateDiff['Fornecedor']!.add(transformedData2['Fornecedor']![i]);
      indices.add(i);
    }
  }
  for (int i = 0; i < transformedData.values.first.length; i++) {
    if (!transformedData2['Valor']!.contains(transformedData['Valor']![i])) {
      missingPayments['Data']!.add(transformedData['Data']![i]);
      missingPayments['Valor']!.add(transformedData['Valor']![i]);
      missingPayments['Fornecedor']!.add(transformedData['Fornecedor']![i]);
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

void transform(Sheet table, Map<String, List> transformedData) {
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
    final supplier = table.rows[row][10]!.value.toString().replaceAll(' ', '');

    if (supplier == '') {
      transformedData['Fornecedor']!.add(table.rows[row][7]!.value.toString());
    } else {
      transformedData['Fornecedor']!.add(supplier);
    }
    transformedData['Data']!.add(date);
    transformedData['Valor']!.add(price);
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
    var date = DateTime.parse(table.rows[row][valuesList[0]]!.value.toString());
    transformedData2['Data']!.add(date);
    var price = double.parse(table.rows[row][valuesList[1]]!.value.toString());
    transformedData2['Valor']!.add(price);
    final supplier =
        table.rows[row][valuesList[3]]!.value.toString().replaceAll(' ', '');
    if (supplier == '' && valuesList.length > 3) {
      transformedData2['Fornecedor']!
          .add(table.rows[row][valuesList[2]]!.value.toString());
    } else {
      transformedData2['Fornecedor']!
          .add(table.rows[row][valuesList[3]]!.value.toString());
    }
  }
}

Sheet read(File file) {
  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var table = excel.tables.values.first;

  return table;
}
