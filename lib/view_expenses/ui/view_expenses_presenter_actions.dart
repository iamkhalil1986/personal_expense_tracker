import 'package:flutter/cupertino.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';

abstract class ViewExpensesPresenterActions {
  void onTapEditExpense(BuildContext context, ExpenseDto expense);
  void onTapCreateNewExpense(BuildContext context);
  void onSelectedCategory(ExpenseCategoryDto selectedCategory);
  void onTapDeleteExpense(BuildContext context, ExpenseDto expense);
}
