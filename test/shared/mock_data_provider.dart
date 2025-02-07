import 'package:personal_expense_tracker/create_expense/model/view_model/create_expense_view_model.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/expenses_view_model.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/grouped_expenses_view_model.dart';

class MockDataProvider {
  static List<ExpenseCategoryDto> categories = [
    foodCategory,
    travelCategory,
    shoppingCategory,
    accommodationCategory,
    utilitiesBillsCategory
  ];

  static List<ExpenseCategoryDto> categoriesWithDefaultOption = [
    defaultCategory,
    foodCategory,
    travelCategory,
    shoppingCategory,
    accommodationCategory,
    utilitiesBillsCategory
  ];

  static const ExpenseCategoryDto defaultCategory = ExpenseCategoryDto(
      categoryId: -1,
      categoryName: PersonalExpenseStrings.defaultCategoryOption);
  static const ExpenseCategoryDto foodCategory =
      ExpenseCategoryDto(categoryId: 1, categoryName: "Food");
  static const ExpenseCategoryDto travelCategory =
      ExpenseCategoryDto(categoryId: 2, categoryName: "Travel");
  static const ExpenseCategoryDto shoppingCategory =
      ExpenseCategoryDto(categoryId: 3, categoryName: "Shopping");
  static const ExpenseCategoryDto accommodationCategory =
      ExpenseCategoryDto(categoryId: 4, categoryName: "Accommodation");
  static const ExpenseCategoryDto utilitiesBillsCategory =
      ExpenseCategoryDto(categoryId: 5, categoryName: "Utilities bills");

  static const ExpenseDto travelExpense = ExpenseDto(
      amount: 20.99,
      expenseDate: "2024-02-05",
      expenseDescription: "France Visit",
      categoryId: 2,
      categoryName: "Travel");

  static const ExpenseDto shoppingExpense = ExpenseDto(
      amount: 20.99,
      expenseDate: "2024-02-05",
      expenseDescription: "France Shopping",
      categoryId: 3,
      categoryName: "Shopping");

  static const List<ExpenseDto> expenses = [travelExpense, shoppingExpense];

  static CreateExpenseViewModel createExpenseViewModel(
      {CreateExpenseActionType createExpenseActionType =
          CreateExpenseActionType.loadScreen,
      TransactionType transactionType = TransactionType.create}) {
    return CreateExpenseViewModel(
        categories: MockDataProvider.categories,
        createExpenseActionType: createExpenseActionType,
        selectedExpense: MockDataProvider.travelExpense,
        transactionType: transactionType);
  }

  static ExpensesViewModel expensesViewModel(
      {ExpenseCategoryDto selectedCategory =
          MockDataProvider.defaultCategory}) {
    return ExpensesViewModel(
        groupedExpenses: [groupedExpensesViewModel()],
        categories: categoriesWithDefaultOption,
        selectedCategory: selectedCategory);
  }

  static ExpensesViewModel expensesViewModelWithNoData() {
    return ExpensesViewModel(
        groupedExpenses: [],
        categories: categoriesWithDefaultOption,
        selectedCategory: defaultCategory);
  }

  static GroupedExpensesViewModel groupedExpensesViewModel() {
    return GroupedExpensesViewModel(
        expenses: [travelExpense, shoppingExpense],
        totalExpenses: 41.98,
        date: "2024-02-05");
  }
}
