import 'dart:async';

import 'package:personal_expense_tracker/core/bloc_provider.dart';
import 'package:personal_expense_tracker/create_expense/model/view_model/create_expense_view_model.dart';
import 'package:personal_expense_tracker/shared/database_helper.dart';
import 'package:personal_expense_tracker/create_expense/model/entity/create_expense_entity.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';

class CreateExpenseBloc extends Bloc {
  late final DatabaseHelper _databaseHelper;

  //Entity to capture data provided by user interactions
  late CreateExpenseEntity _createExpenseEntity;

  final StreamController<CreateExpenseViewModel> createExpenseController =
      StreamController<CreateExpenseViewModel>.broadcast();

  CreateExpenseBloc(
      {DatabaseHelper? dbHelper,
      ExpenseDto? selectedExpense,
      TransactionType transactionType = TransactionType.create}) {
    _databaseHelper = dbHelper ?? DatabaseHelper();
    _createExpenseEntity = CreateExpenseEntity(
        selectedExpense: selectedExpense ?? ExpenseDto.defaults(),
        transactionType: transactionType);
  }

  Future<void> loadCreateExpense() async {
    List<ExpenseCategoryDto> categories = await _databaseHelper.getCategories();
    _createExpenseEntity = _createExpenseEntity.merge(categories: categories);
    createExpenseController.add(prepareCreateExpenseViewModel());
  }

  void updateExpenseDetails(ExpenseDto selectedExpense) {
    _createExpenseEntity =
        _createExpenseEntity.merge(selectedExpense: selectedExpense);
  }

  void updateExpenseCategory(ExpenseCategoryDto selectedCategory) {
    _createExpenseEntity = _createExpenseEntity.merge(
        selectedExpense: _createExpenseEntity.selectedExpense.merge(
            categoryId: selectedCategory.categoryId,
            categoryName: selectedCategory.categoryName));
    createExpenseController.add(prepareCreateExpenseViewModel());
  }

  CreateExpenseViewModel prepareCreateExpenseViewModel(
      {CreateExpenseActionType createExpenseActionType =
          CreateExpenseActionType.loadScreen}) {
    return CreateExpenseViewModel(
        categories: _createExpenseEntity.categories,
        selectedExpense: _createExpenseEntity.selectedExpense,
        transactionType: _createExpenseEntity.transactionType,
        createExpenseActionType: createExpenseActionType);
  }

  Future<void> createNewExpense(
      {required double amount,
      required String expenseDescription,
      required String expenseDate}) async {
    bool result = await _databaseHelper.addExpense(ExpenseDto(
      amount: amount,
      expenseDescription: expenseDescription,
      expenseDate: expenseDate,
      categoryId: _createExpenseEntity.selectedExpense.categoryId,
      categoryName: _createExpenseEntity.selectedExpense.categoryName,
    ));
    createExpenseController.add(prepareCreateExpenseViewModel(
        createExpenseActionType: result
            ? CreateExpenseActionType.created
            : CreateExpenseActionType.error));
  }

  Future<void> updateExpense(
      {required double amount,
      required String expenseDescription,
      required String expenseDate}) async {
    _createExpenseEntity = _createExpenseEntity.merge(
        selectedExpense: _createExpenseEntity.selectedExpense.merge(
            amount: amount,
            expenseDescription: expenseDescription,
            expenseDate: expenseDate));
    bool result = await _databaseHelper.updateExpense(ExpenseDto(
      expenseId: _createExpenseEntity.selectedExpense.expenseId,
      amount: amount,
      expenseDescription: expenseDescription,
      expenseDate: expenseDate,
      categoryId: _createExpenseEntity.selectedExpense.categoryId,
      categoryName: _createExpenseEntity.selectedExpense.categoryName,
    ));
    createExpenseController.add(prepareCreateExpenseViewModel(
        createExpenseActionType: result
            ? CreateExpenseActionType.created
            : CreateExpenseActionType.error));
  }

  @override
  void dispose() {
    createExpenseController.close();
  }
}
