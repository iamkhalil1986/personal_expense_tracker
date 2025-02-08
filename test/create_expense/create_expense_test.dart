import 'bloc/create_expense_bloc_test.dart';
import 'model/entity/create_expense_entity_test.dart';
import 'model/view_model/create_expense_view_model_test.dart';
import 'ui/create_expense_widget_test.dart';

void main() {
  createExpenseTest();
}

//Running test from this function takes less time
void createExpenseTest() {
  //Bloc test
  testCreateExpenseBloc();
  //Model test
  testCreateExpenseEntity();
  testCreateExpenseViewModel();
  //UI test
  testCreateExpenseWidget();
}
