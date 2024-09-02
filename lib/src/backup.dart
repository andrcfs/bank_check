import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> _getFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return "${directory.path}/data.json";
}

Future<void> saveData(List<Map<String, dynamic>> data) async {
  final filePath = await _getFilePath();
  final file = File(filePath);

  // Convert List<Map<String, dynamic>> to JSON string
  final jsonString = jsonEncode(_convertToEncodable(data));

  // Write JSON string to file
  await file.writeAsString(jsonString);
}

Future<List<Map<String, dynamic>>> loadData() async {
  try {
    final filePath = await _getFilePath();
    final file = File(filePath);

    // Check if the file exists
    if (await file.exists()) {
      // Read the file content as a JSON string
      final jsonString = await file.readAsString();

      // Convert JSON string back to List<Map<String, dynamic>>
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData
          .map((item) => Map<String, dynamic>.from(_convertFromEncodable(item)))
          .toList();
    }
  } catch (e) {
    print("Error reading file: $e");
  }

  return [];
}

// Function to convert DateTime objects to strings
dynamic _convertToEncodable(dynamic item) {
  if (item is DateTime) {
    return item.toIso8601String();
  } else if (item is Map) {
    return item.map((key, value) => MapEntry(key, _convertToEncodable(value)));
  } else if (item is List) {
    return item.map((value) => _convertToEncodable(value)).toList();
  } else {
    return item;
  }
}

// Function to convert strings back to DateTime objects
dynamic _convertFromEncodable(dynamic item) {
  if (item is String && DateTime.tryParse(item) != null) {
    return DateTime.parse(item);
  } else if (item is Map) {
    return item
        .map((key, value) => MapEntry(key, _convertFromEncodable(value)));
  } else if (item is List) {
    return item.map((value) => _convertFromEncodable(value)).toList();
  } else {
    return item;
  }
}
