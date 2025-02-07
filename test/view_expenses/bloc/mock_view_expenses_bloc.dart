import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/view_expenses/bloc/view_expenses_bloc.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/expenses_view_model.dart';

import '../../shared/mock_data_provider.dart';

class MockViewExpensesBloc extends Mock implements ViewExpensesBloc {
  @override
  final StreamController<ExpensesViewModel> expensesController =
      StreamController<ExpensesViewModel>.broadcast();

  MockViewExpensesBloc();

  factory MockViewExpensesBloc.withNoExpenses() {
    final bloc = MockViewExpensesBloc();
    when(() => bloc.getAllExpenses()).thenAnswer((_) async {
      Future.delayed(Duration(milliseconds: 300), () {
        bloc.expensesController
            .add(MockDataProvider.expensesViewModelWithNoData());
      });
      return Future.value();
    });
    return bloc;
  }

  factory MockViewExpensesBloc.withExpenses() {
    final bloc = MockViewExpensesBloc();
    when(() => bloc.getAllExpenses()).thenAnswer((_) async {
      Future.delayed(Duration(milliseconds: 300), () {
        bloc.expensesController.add(MockDataProvider.expensesViewModel());
      });
      return Future.value();
    });

    when(() => bloc.getExpensesForCategory(any())).thenAnswer((_) {
      bloc.expensesController.add(MockDataProvider.expensesViewModel(
          selectedCategory: MockDataProvider.shoppingCategory));
      return Future.value();
    });

    when(() => bloc.deleteExpense(any())).thenAnswer((_) async {
      Future.delayed(Duration(milliseconds: 300), () {
        bloc.expensesController.add(MockDataProvider.expensesViewModel());
      });
      return Future.value();
    });
    return bloc;
  }
}
