import 'dart:async';

import 'package:personal_expense_tracker/create_expense/bloc/create_expense_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/create_expense/model/view_model/create_expense_view_model.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';

import '../../shared/mock_data_provider.dart';

class MockCreateExpensesBloc extends Mock implements CreateExpenseBloc {
  @override
  final StreamController<CreateExpenseViewModel> createExpenseController =
      StreamController<CreateExpenseViewModel>.broadcast();

  MockCreateExpensesBloc();
  factory MockCreateExpensesBloc.success(
      {TransactionType transactionType = TransactionType.create}) {
    final bloc = MockCreateExpensesBloc();
    when(() => bloc.loadCreateExpense()).thenAnswer((_) async {
      Future.delayed(Duration(milliseconds: 300), () {
        bloc.createExpenseController.add(
            MockDataProvider.createExpenseViewModel(
                createExpenseActionType: CreateExpenseActionType.loadScreen,
                transactionType: transactionType));
      });
      return Future.value();
    });

    when(() => bloc.updateExpenseCategory(any())).thenAnswer((_) {
      bloc.createExpenseController.add(MockDataProvider.createExpenseViewModel(
          createExpenseActionType: CreateExpenseActionType.loadScreen,
          transactionType: transactionType));
    });

    when(() => bloc.createNewExpense(
        amount: any(named: "amount"),
        expenseDescription: any(named: "expenseDescription"),
        expenseDate: any(named: "expenseDate"))).thenAnswer((_) {
      bloc.createExpenseController.add(MockDataProvider.createExpenseViewModel(
          createExpenseActionType: CreateExpenseActionType.created,
          transactionType: transactionType));
      return Future.value();
    });

    when(() => bloc.updateExpense(
        amount: any(named: "amount"),
        expenseDescription: any(named: "expenseDescription"),
        expenseDate: any(named: "expenseDate"))).thenAnswer((_) {
      bloc.createExpenseController.add(MockDataProvider.createExpenseViewModel(
          createExpenseActionType: CreateExpenseActionType.created,
          transactionType: transactionType));
      return Future.value();
    });
    return bloc;
  }

  factory MockCreateExpensesBloc.error(
      {TransactionType transactionType = TransactionType.create}) {
    final bloc = MockCreateExpensesBloc();
    when(() => bloc.loadCreateExpense()).thenAnswer((_) async {
      Future.delayed(Duration(milliseconds: 300), () {
        bloc.createExpenseController.add(
            MockDataProvider.createExpenseViewModel(
                createExpenseActionType: CreateExpenseActionType.loadScreen,
                transactionType: transactionType));
      });
      return Future.value();
    });

    when(() => bloc.updateExpenseCategory(any())).thenAnswer((_) {
      bloc.createExpenseController.add(MockDataProvider.createExpenseViewModel(
          createExpenseActionType: CreateExpenseActionType.loadScreen,
          transactionType: transactionType));
    });

    when(() => bloc.createNewExpense(
        amount: any(named: "amount"),
        expenseDescription: any(named: "expenseDescription"),
        expenseDate: any(named: "expenseDate"))).thenAnswer((_) {
      bloc.createExpenseController.add(MockDataProvider.createExpenseViewModel(
          createExpenseActionType: CreateExpenseActionType.error,
          transactionType: transactionType));
      return Future.value();
    });

    when(() => bloc.updateExpense(
        amount: any(named: "amount"),
        expenseDescription: any(named: "expenseDescription"),
        expenseDate: any(named: "expenseDate"))).thenAnswer((_) {
      bloc.createExpenseController.add(MockDataProvider.createExpenseViewModel(
          createExpenseActionType: CreateExpenseActionType.error,
          transactionType: transactionType));
      return Future.value();
    });
    return bloc;
  }
}
