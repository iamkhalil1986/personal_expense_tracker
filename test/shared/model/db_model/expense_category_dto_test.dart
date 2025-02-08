import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';

void main() {
  testExpenseCategoryDto();
}

void testExpenseCategoryDto() {
  group('ExpenseCategoryDto tests', () {
    test('ExpenseCategoryDto props test', () {
      ExpenseCategoryDto expenseCategoryDto =
          ExpenseCategoryDto(categoryId: 1, categoryName: "Accommodation");
      expect(expenseCategoryDto.props, [1, "Accommodation"]);
    });

    test('ExpenseCategoryDto fromJson test', () {
      ExpenseCategoryDto expenseCategoryDto = ExpenseCategoryDto.fromJson(
          {"category_id": 1, "category_name": "Accommodation"});
      expect(expenseCategoryDto.props, [1, "Accommodation"]);
    });
  });
}
