import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/view_expenses/model/entity/expenses_entity.dart';

import '../../../shared/mock_data_provider.dart';

void main() {
  testExpensesEntity();
}

void testExpensesEntity() {
  group('ExpensesEntity tests', () {
    test('ExpensesEntity merge test', () {
      ExpensesEntity oldEntity = ExpensesEntity(
          selectedCategory: MockDataProvider.travelCategory,
          categories: MockDataProvider.categories);
      ExpensesEntity newEntity = oldEntity.merge();
      expect(newEntity.selectedCategory, MockDataProvider.travelCategory);
      expect(oldEntity == newEntity, true);

      newEntity =
          newEntity.merge(selectedCategory: MockDataProvider.shoppingCategory);
      expect(newEntity.selectedCategory, MockDataProvider.shoppingCategory);
      expect(oldEntity == newEntity, false);
    });

    test('ExpensesEntity props test', () {
      ExpensesEntity entity = ExpensesEntity(
          selectedCategory: MockDataProvider.travelCategory, categories: []);
      expect(entity.props, [MockDataProvider.travelCategory, []]);
    });
  });
}
