import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/create_expense/model/view_model/create_expense_view_model.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';

void main() {
  testCreateExpenseViewModel();
}

void testCreateExpenseViewModel() {
  group('CreateExpenseViewModel tests', () {
    test('CreateExpenseViewModel props test', () {
      CreateExpenseViewModel viewModel = CreateExpenseViewModel(
          selectedExpense: ExpenseDto.defaults(),
          transactionType: TransactionType.create,
          createExpenseActionType: CreateExpenseActionType.loadScreen,
          categories: []);
      expect(viewModel.props, [
        [],
        CreateExpenseActionType.loadScreen,
        ExpenseDto.defaults(),
        TransactionType.create
      ]);
    });
  });
}
