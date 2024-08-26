import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat('dd/MM/yyyy');
DateFormat dateFormat2 = DateFormat('M/d/y');
bool isError = false;

Map<String, List> duplicates = {
  'Data': [],
  'Valor': [],
  'Fornecedor': [],
};
