import 'dart:convert';
import 'dart:io';

import 'package:bank_check/src/utils/classes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

Future<File> selectSingleFile(context) async {
  FilePickerResult? results = await FilePicker.platform.pickFiles();

  if (results != null) {
    return File(results.files.single.path!);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nenhum arquivo selecionado'),
      ),
    );
    return File('');
  }
}

Future selectAndSaveFiles(context) async {
  FilePickerResult? results = await FilePicker.platform.pickFiles(
      allowMultiple: true, type: FileType.custom, allowedExtensions: ['xlsx']);

  if (results != null) {
    final directory = await getApplicationDocumentsDirectory();
    List<SavedFile> currentFiles = await loadFilesList();

    for (var file in results.files) {
      final newPath = '${directory.path}/${file.name}';
      final newFile = await File(file.path!).copy(newPath);

      currentFiles.add(SavedFile(name: file.name, path: newFile.path));
    }

    await saveFilesList(currentFiles);
    if (results.files.length > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${results.files.length} arquivos salvos com sucesso'),
          backgroundColor: Colors.green,
          elevation: 1,
          duration: const Duration(seconds: 5),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Arquivo salvo com sucesso'),
          backgroundColor: Colors.green,
          elevation: 1,
          duration: Duration(seconds: 5),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nenhum arquivo selecionado'),
      ),
    );
  }
}

//Saving and Loading Data//

Future<String> _getFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return "${directory.path}/data.json";
}

Future<void> saveData(List<Result> data) async {
  final filePath = await _getFilePath();
  final file = File(filePath);

  // Convert List<Result> to JSON string
  final jsonString = jsonEncode(data.map((e) => e.toJson()).toList());

  // Write JSON string to file
  await file.writeAsString(jsonString);
}

Future<List<Result>> loadData() async {
  try {
    final filePath = await _getFilePath();
    final file = File(filePath);

    // Check if the file exists
    if (await file.exists()) {
      // Read the file content as a JSON string
      final jsonString = await file.readAsString();

      // Convert JSON string back to List<Result>
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((item) => resultFromJson(item)).toList();
    }
  } catch (e) {
    print("Error reading file: $e");
  }

  return [];
}

Result resultFromJson(Map<String, dynamic> json) {
  switch (json['type'] as String) {
    case 'despesas':
      return ResultDebit.fromJson(json);
    case 'receitas':
      return ResultCredit.fromJson(json);
    default:
      throw Exception('Unknown result type: ${json['type']}');
  }
}

// Salvar a lista de arquivos em um arquivo JSON
Future<void> saveFilesList(List<SavedFile> files) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/fileslist.json';
  final file = File(path);

  List<Map<String, dynamic>> jsonList =
      files.map((file) => file.toJson()).toList();
  await file.writeAsString(jsonEncode(jsonList));
}

// Carregar a lista de arquivos do arquivo JSON
Future<List<SavedFile>> loadFilesList() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/fileslist.json';
  final file = File(path);

  if (await file.exists()) {
    String contents = await file.readAsString();
    List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((json) => SavedFile.fromJson(json)).toList();
  } else {
    return [];
  }
}
