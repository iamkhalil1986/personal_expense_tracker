import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/bloc_provider.dart';
import 'package:personal_expense_tracker/core/loading_screen.dart';
import 'package:personal_expense_tracker/create_expense/ui/create_expense_widget.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';
import 'package:personal_expense_tracker/shared/shared_utils.dart';
import 'package:personal_expense_tracker/view_expenses/bloc/view_expenses_bloc.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/expenses_view_model.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expenses_presenter_actions.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expenses_screen.dart';

class ViewExpensesPresenter extends StatefulWidget {
  const ViewExpensesPresenter({super.key});

  @override
  State<StatefulWidget> createState() => _ViewExpensesPresenterState();
}

class _ViewExpensesPresenterState extends State<ViewExpensesPresenter> {
  late final ViewExpensesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ViewExpensesBloc>(context);
    _bloc.getAllExpenses();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ExpensesViewModel>(
        stream: _bloc.expensesController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else {
            return ViewExpensesScreen(
                actions: _PresenterActions(bloc: _bloc),
                viewModel: snapshot.data as ExpensesViewModel);
          }
        });
  }
}

class _PresenterActions extends ViewExpensesPresenterActions {
  final ViewExpensesBloc bloc;
  _PresenterActions({required this.bloc});

  @override
  void onTapCreateNewExpense(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateExpenseWidget.add()));
  }

  @override
  void onTapEditExpense(BuildContext context, ExpenseDto expense) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateExpenseWidget.edit(
                  selectedExpense: expense,
                )));
  }

  @override
  void onSelectedCategory(ExpenseCategoryDto selectedCategory) {
    if (selectedCategory.categoryName ==
        PersonalExpenseStrings.defaultCategoryOption) {
      bloc.getAllExpenses();
    } else {
      bloc.getExpensesForCategory(selectedCategory);
    }
  }

  @override
  void onTapDeleteExpense(BuildContext context, ExpenseDto expense) {
    SharedUtils.showDialogBox(
        context: context,
        titleWidget:
            Text(PersonalExpenseStrings.warning, textAlign: TextAlign.center),
        contentWidget: Text(PersonalExpenseStrings.deleteConfirmationMessage,
            textAlign: TextAlign.center),
        positiveButtonTitle: PersonalExpenseStrings.yes,
        positiveAction: () {
          bloc.deleteExpense(expense);
        },
        negativeButtonTitle: PersonalExpenseStrings.no);
  }
}
