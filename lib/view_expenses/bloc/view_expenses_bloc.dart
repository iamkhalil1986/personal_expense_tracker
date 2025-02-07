import 'dart:async';

import 'package:personal_expense_tracker/core/bloc_provider.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';
import 'package:personal_expense_tracker/shared/database_helper.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';
import 'package:personal_expense_tracker/view_expenses/model/entity/expenses_entity.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/expenses_view_model.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/grouped_expenses_view_model.dart';

class ViewExpensesBloc extends Bloc {
  late final DatabaseHelper _databaseHelper;

  //Entity to capture actions performed on the screen. Example to store selected category to filter expenses
  late ExpensesEntity _expensesEntity;

  final StreamController<ExpensesViewModel> expensesController =
      StreamController<ExpensesViewModel>.broadcast();

  //Injecting DatabaseHelper dependency here to be able to write tests using mock version of DatabaseHelper
  ViewExpensesBloc({DatabaseHelper? dbHelper}) {
    _databaseHelper = dbHelper ?? DatabaseHelper();
    _expensesEntity = ExpensesEntity();
  }

  Future<void> getAllExpenses() async {
    // Get all expenses records from database for viewing
    List<ExpenseDto> expenses = await _databaseHelper.getAllExpenses();
    // Get all categories for applying filter to get only expenses for the selected category
    List<ExpenseCategoryDto> categories = await _databaseHelper.getCategories();

    //Category filter field should contains all categories including the default category as "All".
    //Inserting the default category at first position
    var defaultSelectedCategory = ExpenseCategoryDto(
        categoryId: -1,
        categoryName: PersonalExpenseStrings.defaultCategoryOption);
    categories.insert(0, defaultSelectedCategory);
    _expensesEntity = _expensesEntity.merge(
        categories: categories, selectedCategory: defaultSelectedCategory);
    expensesController.add(prepareExpensesViewModel(expenses: expenses));
  }

  //Get list of expenses for the selected category filter applied
  Future<void> getExpensesForCategory(
      ExpenseCategoryDto selectedCategory) async {
    _expensesEntity = _expensesEntity.merge(selectedCategory: selectedCategory);
    List<ExpenseDto> expenses =
        await _databaseHelper.getExpensesForCategory(selectedCategory);
    expensesController.add(prepareExpensesViewModel(expenses: expenses));
  }

  Future<void> deleteExpense(ExpenseDto expense) async {
    bool result = await _databaseHelper.deleteExpense(expense);
    if (result) {
      // This check is needed to retain the selected filter applied before deletion
      if (_expensesEntity.selectedCategory?.categoryName ==
          PersonalExpenseStrings.defaultCategoryOption) {
        await getAllExpenses();
      } else {
        await getExpensesForCategory(_expensesEntity.selectedCategory!);
      }
    }
  }

  ExpensesViewModel prepareExpensesViewModel(
      {required List<ExpenseDto> expenses}) {
    return ExpensesViewModel(
        groupedExpenses: prepareGroupedExpenses(expenses: expenses),
        categories: _expensesEntity.categories,
        selectedCategory: _expensesEntity.selectedCategory);
  }

  List<GroupedExpensesViewModel> prepareGroupedExpenses(
      {required List<ExpenseDto> expenses}) {
    //Need to prepare expenses grouped by date
    Map<String, List<ExpenseDto>> groupedRecordsMap = {};
    for (var expense in expenses) {
      String dateKey = expense.expenseDate;
      // Check if the dateKey already exists, and if not, initialize it with an empty list
      if (groupedRecordsMap.containsKey(dateKey)) {
        groupedRecordsMap[dateKey]?.add(expense);
      } else {
        groupedRecordsMap[dateKey] = [expense];
      }
    }

    List<GroupedExpensesViewModel> groupedExpenses = [];
    for (String date in groupedRecordsMap.keys) {
      final expenses = groupedRecordsMap[date];
      double totalExpenses =
          expenses!.fold(0.0, (sum, record) => sum + record.amount);
      groupedExpenses.add(GroupedExpensesViewModel(
          expenses: expenses, date: date, totalExpenses: totalExpenses));
    }
    return groupedExpenses;
  }

  @override
  void dispose() {
    expensesController.close();
  }
}
