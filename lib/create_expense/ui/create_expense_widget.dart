import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/bloc_provider.dart';
import 'package:personal_expense_tracker/create_expense/bloc/create_expense_bloc.dart';
import 'package:personal_expense_tracker/create_expense/ui/create_expense_presenter.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';

class CreateExpenseWidget extends StatelessWidget {
  final ExpenseDto? selectedExpense;
  final TransactionType transactionType;

  const CreateExpenseWidget.add({super.key})
      : selectedExpense = null,
        transactionType = TransactionType.create;

  const CreateExpenseWidget.edit({super.key, required this.selectedExpense})
      : transactionType = TransactionType.edit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateExpenseBloc>(
      create: (_) => CreateExpenseBloc(
          selectedExpense: selectedExpense, transactionType: transactionType),
      child: CreateExpensePresenter(),
    );
  }
}
