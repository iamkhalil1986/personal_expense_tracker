import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/create_expense/bloc/create_expense_bloc.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';

import '../../shared/mock_data_provider.dart';
import '../../shared/mock_database_helper.dart';

void main() {
  testCreateExpenseBloc();
}

void testCreateExpenseBloc() {
  group('CreateExpenseBloc tests', () {
    setUpAll(() {
      registerFallbackValue(MockDataProvider.travelExpense);
      registerFallbackValue(MockDataProvider.shoppingCategory);
    });

    test('test loadCreateExpense', () {
      final bloc =
          CreateExpenseBloc(dbHelper: MockDatabaseHelper.withMockData());
      bloc.createExpenseController.stream.listen((viewModel) {
        expect(viewModel.categories.length, greaterThan(0));
        bloc.dispose();
      });
      bloc.loadCreateExpense();
    });

    test('test updateExpenseCategory', () {
      final bloc =
          CreateExpenseBloc(dbHelper: MockDatabaseHelper.withMockData());
      bloc.createExpenseController.stream.listen((viewModel) {
        expect(viewModel.selectedExpense.categoryName, "Shopping");
        bloc.dispose();
      });
      bloc.updateExpenseCategory(MockDataProvider.shoppingCategory);
    });

    test('test createNewExpense with success', () {
      final bloc = CreateExpenseBloc(
          dbHelper: MockDatabaseHelper.withMockData(response: true));
      bloc.createExpenseController.stream.listen((viewModel) {
        expect(
            viewModel.createExpenseActionType, CreateExpenseActionType.created);
        bloc.dispose();
      });
      bloc.createNewExpense(
          amount: 20.0,
          expenseDate: "2024-02-05",
          expenseDescription: "Paris vacation");
    });

    test('test createNewExpense with error', () {
      final bloc = CreateExpenseBloc(
          dbHelper: MockDatabaseHelper.withMockData(response: false));
      bloc.createExpenseController.stream.listen((viewModel) {
        expect(
            viewModel.createExpenseActionType, CreateExpenseActionType.error);
        bloc.dispose();
      });
      bloc.createNewExpense(
          amount: 20.0,
          expenseDate: "2024-02-05",
          expenseDescription: "Paris vacation");
    });

    test('test updateExpense with success', () {
      final bloc = CreateExpenseBloc(
          dbHelper: MockDatabaseHelper.withMockData(response: true));
      bloc.createExpenseController.stream.listen((viewModel) {
        expect(
            viewModel.createExpenseActionType, CreateExpenseActionType.created);
        bloc.dispose();
      });
      bloc.updateExpenseDetails(MockDataProvider.travelExpense);
      bloc.updateExpense(
          amount: 20.0,
          expenseDate: "2024-02-05",
          expenseDescription: "Paris vacation");
    });

    test('test updateExpense with error', () {
      final bloc = CreateExpenseBloc(
          dbHelper: MockDatabaseHelper.withMockData(response: false));
      bloc.createExpenseController.stream.listen((viewModel) {
        expect(
            viewModel.createExpenseActionType, CreateExpenseActionType.error);
        bloc.dispose();
      });
      bloc.updateExpenseDetails(MockDataProvider.travelExpense);
      bloc.updateExpense(
          amount: 20.0,
          expenseDate: "2024-02-05",
          expenseDescription: "Paris vacation");
    });
  });
}
