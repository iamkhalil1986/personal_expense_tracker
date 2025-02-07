import 'package:equatable/equatable.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';

class GroupedExpensesViewModel extends Equatable {
  final List<ExpenseDto> expenses;
  final String date;
  final double totalExpenses;

  const GroupedExpensesViewModel(
      {required this.expenses,
      required this.date,
      required this.totalExpenses});

  @override
  List<Object?> get props => [expenses, date, totalExpenses];
}
