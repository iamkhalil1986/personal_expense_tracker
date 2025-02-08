import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';

void main() {
  testExpenseDto();
}

void testExpenseDto() {
  group('ExpenseDto tests', () {
    test('ExpenseDto merge test', () {
      ExpenseDto oldObject = ExpenseDto(
          expenseId: 1,
          expenseDescription: "Test Description",
          amount: 200.00,
          expenseDate: "2024-02-07",
          categoryId: 1,
          categoryName: "Accommodation");
      ExpenseDto newObject = oldObject.merge();
      expect(oldObject == newObject, true);

      newObject = newObject.merge(amount: 300.00);
      expect(newObject.amount, 300.00);
      expect(oldObject == newObject, false);
    });

    test('ExpenseDto props test', () {
      ExpenseDto expenseDto = ExpenseDto(
          expenseId: 1,
          expenseDescription: "Test Description",
          amount: 200.00,
          expenseDate: "2024-02-07",
          categoryId: 1,
          categoryName: "Accommodation");
      expect(expenseDto.props,
          [1, 200.00, "2024-02-07", "Test Description", 1, "Accommodation"]);
    });

    test('ExpenseDto fromJson test', () {
      ExpenseDto expenseDto = ExpenseDto.fromJson({
        "expense_id": 1,
        "expense_description": "Test Description",
        "amount": 200.00,
        "expense_date": "2024-02-07",
        "category_id": 1,
        "category_name": "Accommodation"
      });
      expect(expenseDto.props,
          [1, 200.00, "2024-02-07", "Test Description", 1, "Accommodation"]);
    });

    test('ExpenseDto toJson test', () {
      ExpenseDto expenseDto = ExpenseDto(
          expenseId: 1,
          expenseDescription: "Test Description",
          amount: 200.00,
          expenseDate: "2024-02-07",
          categoryId: 1,
          categoryName: "Accommodation");

      Map jsonObject = {
        "expense_id": 1,
        "expense_description": "Test Description",
        "amount": 200.00,
        "expense_date": "2024-02-07",
        "category_id": 1
      };
      expect(expenseDto.toJson(), jsonObject);
    });
  });
}
