import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/create_expense/model/entity/create_expense_entity.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';

void main() {
  testCreateExpenseEntity();
}

void testCreateExpenseEntity() {
  group('CreateExpenseEntity tests', () {
    test('CreateExpenseEntity merge test', () {
      CreateExpenseEntity oldEntity = CreateExpenseEntity(
          selectedExpense: ExpenseDto.defaults(),
          transactionType: TransactionType.edit,
          categories: []);
      CreateExpenseEntity newEntity = oldEntity.merge();
      expect(newEntity.transactionType, TransactionType.edit);
      expect(oldEntity == newEntity, true);

      newEntity = newEntity.merge(transactionType: TransactionType.create);
      expect(newEntity.transactionType, TransactionType.create);
      expect(oldEntity == newEntity, false);
    });

    test('CreateExpenseEntity props test', () {
      CreateExpenseEntity entity = CreateExpenseEntity(
          selectedExpense: ExpenseDto.defaults(),
          transactionType: TransactionType.edit,
          categories: []);
      expect(entity.props, [ExpenseDto.defaults(), [], TransactionType.edit]);
    });
  });
}
