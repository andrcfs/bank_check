class MyData {
  final DateTime date;
  final double price;
  final String supplier;
  final String? supplierType;

  MyData(this.date, this.price, this.supplier, [this.supplierType]);
  // Convert a Data object to a Map
  Map<String, dynamic> toJson() => {
        '_type': 'Data', // Add a type identifier
        'date': date.toIso8601String(),
        'price': price,
        'supplier': supplier,
        'supplierType': supplierType,
      };

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      DateTime.parse(json['date'] as String),
      (json['price'] as num).toDouble(),
      json['supplier'] as String,
      json['supplierType'] as String?,
    );
  }
  @override
  String toString() {
    return 'date: $date, price: $price, supplier: $supplier, supplierType: $supplierType';
  }
}

class DebitColumns {
  final List<String> dateNames;
  final List<String> priceNames;
  final List<String> supplierNames;

  DebitColumns({
    required this.dateNames,
    required this.priceNames,
    required this.supplierNames,
  });
  List<int> dateIndexes = [];
  List<int> priceIndexes = [];
  List<int> supplierIndexes = [];

  bool get indexesFound {
    return dateIndexes.isEmpty
        ? false
        : priceIndexes.isEmpty
            ? false
            : supplierIndexes.isEmpty
                ? false
                : true;
  }

  String get columnIndexes {
    return 'dateIndexes: $dateIndexes\npriceIndexes: $priceIndexes\nsupplierIndexes: $supplierIndexes';
  }
}

abstract class Result {
  final String name;
  final String name2;
  final String type;
  final DateTime time;

  Result({
    required this.name,
    required this.name2,
    required this.type,
    required this.time,
  });

  Map<String, dynamic> toJson();
}

class ResultDebit extends Result {
  final List<MyData> missingPayments;
  final List<MyData> priceDiff;
  final List<MyData> dateDiff;
  final List<MyData> paymentsFound;
  final List<MyData> duplicates;
  final List<MyData> supplierDiff;

  ResultDebit({
    required super.name,
    required super.name2,
    required super.type,
    required super.time,
    required this.missingPayments,
    required this.priceDiff,
    required this.dateDiff,
    required this.paymentsFound,
    required this.duplicates,
    required this.supplierDiff,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'name2': name2,
        'type': type,
        'time': time.toIso8601String(),
        'missingPayments': missingPayments.map((d) => d.toJson()).toList(),
        'priceDiff': priceDiff.map((d) => d.toJson()).toList(),
        'dateDiff': dateDiff.map((d) => d.toJson()).toList(),
        'paymentsFound': paymentsFound.map((d) => d.toJson()).toList(),
        'duplicates': duplicates.map((d) => d.toJson()).toList(),
        'supplierDiff': supplierDiff.map((d) => d.toJson()).toList(),
      };

  factory ResultDebit.fromJson(Map<String, dynamic> json) => ResultDebit(
        name: json['name'] as String,
        name2: json['name2'] as String,
        type: json['type'] as String,
        time: DateTime.parse(json['time'] as String),
        missingPayments: (json['missingPayments'] as List<dynamic>)
            .map((e) => MyData.fromJson(e as Map<String, dynamic>))
            .toList(),
        priceDiff: (json['priceDiff'] as List<dynamic>)
            .map((e) => MyData.fromJson(e as Map<String, dynamic>))
            .toList(),
        dateDiff: (json['dateDiff'] as List<dynamic>)
            .map((e) => MyData.fromJson(e as Map<String, dynamic>))
            .toList(),
        paymentsFound: (json['paymentsFound'] as List<dynamic>)
            .map((e) => MyData.fromJson(e as Map<String, dynamic>))
            .toList(),
        duplicates: json['duplicates'] != null
            ? (json['duplicates'] as List<dynamic>)
                .map((e) => MyData.fromJson(e as Map<String, dynamic>))
                .toList()
            : <MyData>[],
        supplierDiff: json['supplierDiff'] != null
            ? (json['supplierDiff'] as List<dynamic>)
                .map((e) => MyData.fromJson(e as Map<String, dynamic>))
                .toList()
            : <MyData>[],
      );
}

class ResultCredit extends Result {
  final Map<String, double> bankPriceSums;
  final Map<String, double> systemPriceSums;
  final List<MyData> bankDataList;
  final List<MyData> systemDataList;

  ResultCredit({
    required super.name,
    required super.name2,
    required super.type,
    required super.time,
    required this.bankPriceSums,
    required this.systemPriceSums,
    required this.bankDataList,
    required this.systemDataList,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'name2': name2,
        'type': type,
        'time': time.toIso8601String(),
        'bankPriceSums': bankPriceSums,
        'systemPriceSums': systemPriceSums,
        'bankDataList': bankDataList.map((d) => d.toJson()).toList(),
        'systemDataList': systemDataList.map((d) => d.toJson()).toList(),
      };

  factory ResultCredit.fromJson(Map<String, dynamic> json) => ResultCredit(
        name: json['name'] as String,
        name2: json['name2'] as String,
        type: json['type'] as String,
        time: DateTime.parse(json['time'] as String),
        bankPriceSums: Map<String, double>.from(json['bankPriceSums'] as Map),
        systemPriceSums:
            Map<String, double>.from(json['systemPriceSums'] as Map),
        bankDataList: (json['bankDataList'] as List<dynamic>)
            .map((e) => MyData.fromJson(e as Map<String, dynamic>))
            .toList(),
        systemDataList: (json['systemDataList'] as List<dynamic>)
            .map((e) => MyData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
