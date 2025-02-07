import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/expenses_view_model.dart';

import '../../../shared/mock_data_provider.dart';

void main() {
  testExpensesViewModel();
}

void testExpensesViewModel() {
  group('ExpensesViewModel tests', () {
    test('ExpensesViewModel props test', () {
      ExpensesViewModel viewModel = ExpensesViewModel(
          groupedExpenses: [],
          categories: [],
          selectedCategory: MockDataProvider.shoppingCategory);
      expect(viewModel.props, [[], [], MockDataProvider.shoppingCategory]);
    });
  });
}
