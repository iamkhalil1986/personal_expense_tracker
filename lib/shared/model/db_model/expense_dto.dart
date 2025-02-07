import 'package:equatable/equatable.dart';

class ExpenseDto extends Equatable {
  final int? expenseId;
  final double amount;
  final String expenseDate;
  final String expenseDescription;
  final int categoryId;
  final String categoryName;

  const ExpenseDto({
    this.expenseId,
    required this.amount,
    required this.expenseDate,
    required this.expenseDescription,
    required this.categoryId,
    required this.categoryName,
  });

  factory ExpenseDto.defaults() {
    return const ExpenseDto(
      expenseId: 0,
      amount: 0.0,
      expenseDate: '',
      expenseDescription: '',
      categoryId: 0,
      categoryName: '',
    );
  }

  factory ExpenseDto.fromJson(Map<String, dynamic> json) {
    return ExpenseDto(
      expenseId: json['expense_id'],
      amount: json['amount'] ?? 0.0,
      expenseDate: json['expense_date'],
      expenseDescription: json['expense_description'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expense_id': expenseId,
      'amount': amount,
      'expense_date': expenseDate,
      'expense_description': expenseDescription,
      'category_id': categoryId
    };
  }

  ExpenseDto merge(
      {int? expenseId,
      double? amount,
      String? expenseDate,
      String? expenseDescription,
      int? categoryId,
      String? categoryName}) {
    return ExpenseDto(
      expenseId: expenseId ?? this.expenseId,
      amount: amount ?? this.amount,
      expenseDate: expenseDate ?? this.expenseDate,
      expenseDescription: expenseDescription ?? this.expenseDescription,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  @override
  List<Object?> get props => [
        expenseId,
        amount,
        expenseDate,
        expenseDescription,
        categoryId,
        categoryName
      ];
}
