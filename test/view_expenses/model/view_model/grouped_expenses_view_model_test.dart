import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/grouped_expenses_view_model.dart';

void main() {
  testGroupedExpensesViewModel();
}

void testGroupedExpensesViewModel() {
  group('GroupedExpensesViewModel tests', () {
    test('GroupedExpensesViewModel props test', () {
      GroupedExpensesViewModel viewModel = GroupedExpensesViewModel(
          totalExpenses: 22.06, date: "2025-02-07", expenses: []);
      expect(viewModel.props, [[], "2025-02-07", 22.06]);
    });
  });
}
