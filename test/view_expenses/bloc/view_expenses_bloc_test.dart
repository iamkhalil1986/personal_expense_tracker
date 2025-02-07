import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/view_expenses/bloc/view_expenses_bloc.dart';

import '../../shared/mock_data_provider.dart';
import '../../shared/mock_database_helper.dart';

void main() {
  testViewExpensesBloc();
}

void testViewExpensesBloc() {
  group('ViewExpensesBloc tests', () {
    setUpAll(() {
      registerFallbackValue(MockDataProvider.shoppingCategory);
      registerFallbackValue(MockDataProvider.travelExpense);
    });

    test('test getAllExpenses', () {
      final bloc =
          ViewExpensesBloc(dbHelper: MockDatabaseHelper.withMockData());
      bloc.expensesController.stream.listen((viewModel) {
        expect(viewModel.categories.length, greaterThan(0));
        expect(viewModel.groupedExpenses.length, greaterThan(0));
        bloc.dispose();
      });
      bloc.getAllExpenses();
    });

    test('test getExpensesForCategory', () {
      final bloc =
          ViewExpensesBloc(dbHelper: MockDatabaseHelper.withMockData());
      bloc.expensesController.stream.listen((viewModel) {
        expect(viewModel.selectedCategory, MockDataProvider.shoppingCategory);
        expect(viewModel.groupedExpenses.length, greaterThan(0));
        bloc.dispose();
      });
      bloc.getExpensesForCategory(MockDataProvider.shoppingCategory);
    });

    test('test deleteExpense when default category is selected', () {
      final bloc =
          ViewExpensesBloc(dbHelper: MockDatabaseHelper.withMockData());
      int callCount = 1;
      bloc.expensesController.stream.listen((viewModel) {
        if (callCount == 1) {
          callCount++;
          expect(viewModel.selectedCategory, MockDataProvider.defaultCategory);
          bloc.deleteExpense(MockDataProvider.travelExpense);
        } else {
          expect(viewModel.selectedCategory, MockDataProvider.defaultCategory);
          expect(viewModel.groupedExpenses.length, greaterThan(0));
          bloc.dispose();
        }
      });
      bloc.getExpensesForCategory(MockDataProvider.defaultCategory);
    });

    test('test deleteExpense when custom category is selected', () {
      final bloc =
          ViewExpensesBloc(dbHelper: MockDatabaseHelper.withMockData());
      int callCount = 1;
      bloc.expensesController.stream.listen((viewModel) {
        if (callCount == 1) {
          callCount++;
          expect(viewModel.selectedCategory, MockDataProvider.travelCategory);
          bloc.deleteExpense(MockDataProvider.travelExpense);
        } else {
          expect(viewModel.selectedCategory, MockDataProvider.travelCategory);
          expect(viewModel.groupedExpenses.length, greaterThan(0));
          bloc.dispose();
        }
      });
      bloc.getExpensesForCategory(MockDataProvider.travelCategory);
    });
  });
}
