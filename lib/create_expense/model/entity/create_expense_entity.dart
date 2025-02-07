import 'package:equatable/equatable.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';

class CreateExpenseEntity extends Equatable {
  final ExpenseDto selectedExpense;
  final List<ExpenseCategoryDto> categories;
  final TransactionType transactionType;

  const CreateExpenseEntity(
      {required this.selectedExpense,
      this.categories = const [],
      required this.transactionType});

  CreateExpenseEntity merge(
      {ExpenseDto? selectedExpense,
      List<ExpenseCategoryDto>? categories,
      TransactionType? transactionType}) {
    return CreateExpenseEntity(
        selectedExpense: selectedExpense ?? this.selectedExpense,
        categories: categories ?? this.categories,
        transactionType: transactionType ?? this.transactionType);
  }

  @override
  List<Object?> get props => [selectedExpense, categories, transactionType];
}
