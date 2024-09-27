import 'dart:convert';
import 'dart:io';

import 'package:bank_check/src/utils/classes.dart';
import 'package:path_provider/path_provider.dart';

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
