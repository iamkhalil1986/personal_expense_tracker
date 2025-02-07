import 'bloc/view_expenses_bloc_test.dart';
import 'model/entity/expenses_entity_test.dart';
import 'model/view_model/expenses_view_model_test.dart';
import 'model/view_model/grouped_expenses_view_model_test.dart';
import 'ui/view_expenses_widget_test.dart';

//Running test from this function takes less time
void main() {
  //Bloc test
  testViewExpensesBloc();
  //Model test
  testExpensesEntity();
  testGroupedExpensesViewModel();
  testExpensesViewModel();
  //UI test
  testViewExpensesWidget();
}
