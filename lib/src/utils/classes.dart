class MyData {
  final DateTime date;
  final double price;
  final String supplier;

  MyData(this.date, this.price, this.supplier);
  // Convert a Data object to a Map
  Map<String, dynamic> toJson() => {
        '_type': 'Data', // Add a type identifier
        'date': date.toIso8601String(),
        'price': price,
        'supplier': supplier,
      };

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      DateTime.parse(json['date'] as String),
      (json['price'] as num).toDouble(),
      json['supplier'] as String,
    );
  }
}

class Result {
  final String name;
  final String name2;
  final String type;
  final DateTime time;
  final List<MyData> missingPayments;
  final List<MyData> priceDiff;
  final List<MyData> dateDiff;
  final List<MyData> paymentsFound;

  Result({
    required this.name,
    required this.name2,
    required this.type,
    required this.time,
    required this.missingPayments,
    required this.priceDiff,
    required this.dateDiff,
    required this.paymentsFound,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'name2': name2,
        'type': type,
        'time': time.toIso8601String(),
        'missingPayments': missingPayments.map((d) => d.toJson()).toList(),
        'priceDiff': priceDiff.map((d) => d.toJson()).toList(),
        'dateDiff': dateDiff.map((d) => d.toJson()).toList(),
        'paymentsFound': paymentsFound.map((d) => d.toJson()).toList(),
      };

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
      );
}
