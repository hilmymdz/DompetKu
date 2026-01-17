class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String type; // 'expense' atau 'income'

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });

  // Konversi dari Map (Database) ke Object
  factory TransactionModel.fromMap(Map<String, dynamic> json) => TransactionModel(
        id: json['id'],
        title: json['title'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
        type: json['type'],
      );

  // Konversi dari Object ke Map (Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
    };
  }
}