import 'package:equatable/equatable.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';

class CreateExpenseViewModel extends Equatable {
  final List<ExpenseCategoryDto> categories;
  final CreateExpenseActionType createExpenseActionType;
  final ExpenseDto selectedExpense;
  final TransactionType transactionType;

  const CreateExpenseViewModel(
      {required this.categories,
      this.createExpenseActionType = CreateExpenseActionType.loadScreen,
      required this.selectedExpense,
      required this.transactionType});

  @override
  List<Object?> get props =>
      [categories, createExpenseActionType, selectedExpense, transactionType];
}
