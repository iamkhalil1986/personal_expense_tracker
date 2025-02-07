import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/shared/database_helper.dart';

import 'mock_data_provider.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  MockDatabaseHelper();
  factory MockDatabaseHelper.withMockData({bool response = true}) {
    final dbHelper = MockDatabaseHelper();
    when(() => dbHelper.getCategories())
        .thenAnswer((_) => Future.value(MockDataProvider.categories));
    when(() => dbHelper.addExpense(any()))
        .thenAnswer((_) => Future.value(response));
    when(() => dbHelper.updateExpense(any()))
        .thenAnswer((_) => Future.value(response));
    when(() => dbHelper.getAllExpenses())
        .thenAnswer((_) => Future.value(MockDataProvider.expenses));
    when(() => dbHelper.getExpensesForCategory(any()))
        .thenAnswer((_) => Future.value(MockDataProvider.expenses));
    when(() => dbHelper.deleteExpense(any()))
        .thenAnswer((_) => Future.value(true));
    return dbHelper;
  }
}
