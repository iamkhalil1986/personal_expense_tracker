import 'package:equatable/equatable.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/grouped_expenses_view_model.dart';

class ExpensesViewModel extends Equatable {
  final List<GroupedExpensesViewModel> groupedExpenses;
  final List<ExpenseCategoryDto> categories;
  final ExpenseCategoryDto? selectedCategory;

  const ExpensesViewModel(
      {this.groupedExpenses = const [],
      this.categories = const [],
      this.selectedCategory});

  @override
  List<Object?> get props => [groupedExpenses, categories, selectedCategory];
}
