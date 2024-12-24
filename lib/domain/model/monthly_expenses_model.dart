// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MonthlyExpenses {
  final String id;
  final String title;
  final double amount;
  final int dueDate;

  MonthlyExpenses({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
  });

  MonthlyExpenses copyWith({
    String? id,
    String? title,
    double? amount,
    int? dueDate,
  }) {
    return MonthlyExpenses(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'dueDate': dueDate,
    };
  }

  factory MonthlyExpenses.fromMap(Map<String, dynamic> map) {
    return MonthlyExpenses(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: map['amount'] as double,
      dueDate: map['dueDate'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthlyExpenses.fromJson(String source) =>
      MonthlyExpenses.fromMap(json.decode(source) as Map<String, dynamic>);

  

  @override
  String toString() {
    return 'MonthlyExpenses(id: $id, title: $title, amount: $amount, dueDate: $dueDate)';
  }
}
