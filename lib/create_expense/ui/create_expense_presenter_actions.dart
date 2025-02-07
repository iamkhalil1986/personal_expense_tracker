import 'package:flutter/cupertino.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';

abstract class CreateExpensePresenterActions {
  void onTapSubmit(
      {required BuildContext context,
      required double amount,
      required String expenseDescription,
      required String expenseDate,
      required bool updateExpense});
  void onSelectedCategory(ExpenseCategoryDto selectedCategory);
}
