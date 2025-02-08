import 'create_expense/create_expense_test.dart';
import 'shared/model/db_model/expense_category_dto_test.dart';
import 'shared/model/db_model/expense_dto_test.dart';
import 'view_expenses/view_expenses_test.dart';

void main() {
  createExpenseTest();
  viewExpensesTest();
  testExpenseCategoryDto();
  testExpenseDto();
}
