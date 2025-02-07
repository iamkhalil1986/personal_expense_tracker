import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/bloc_provider.dart';
import 'package:personal_expense_tracker/view_expenses/bloc/view_expenses_bloc.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expenses_presenter.dart';

class ViewExpensesWidget extends StatelessWidget {
  const ViewExpensesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewExpensesBloc>(
      create: (_) => ViewExpensesBloc(),
      child: ViewExpensesPresenter(),
    );
  }
}
