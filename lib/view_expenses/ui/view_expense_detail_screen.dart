import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';
import 'package:personal_expense_tracker/shared/extensions/extensions.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expenses_presenter_actions.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final ExpenseDto expense;
  final ViewExpensesPresenterActions actions;

  const ExpenseDetailScreen(
      {super.key, required this.expense, required this.actions});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Image.asset(
                    PersonalExpenseStrings
                        .categoryImagesMap[expense.categoryName]!,
                    height: 40,
                    width: 40,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          _ExpenseDetailItemWidget(
              label: PersonalExpenseStrings.descriptionLabel,
              value: expense.expenseDescription),
          _ExpenseDetailItemWidget(
              label: PersonalExpenseStrings.amount,
              value: expense.amount.parseCurrency()),
          _ExpenseDetailItemWidget(
              label: PersonalExpenseStrings.date, value: expense.expenseDate),
          _ButtonsWidget(expense: expense, actions: actions),
        ],
      ),
    );
  }
}

class _ExpenseDetailItemWidget extends StatelessWidget {
  final String label;
  final String value;
  const _ExpenseDetailItemWidget({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
          Divider()
        ],
      ),
    );
  }
}

class _ButtonsWidget extends StatelessWidget {
  final ExpenseDto expense;
  final ViewExpensesPresenterActions actions;
  const _ButtonsWidget({required this.expense, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        ElevatedButton.icon(
            onPressed: () {
              //Dismiss bottom sheet
              Navigator.of(context).pop();
              actions.onTapDeleteExpense(context, expense);
            },
            icon: Icon(Icons.delete_outline,
                color: Theme.of(context).colorScheme.onSecondary),
            iconAlignment: IconAlignment.start,
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.error),
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onSecondary)),
            label: Text(PersonalExpenseStrings.delete)),
        Spacer(),
        ElevatedButton.icon(
            onPressed: () {
              //Dismiss bottom sheet
              Navigator.of(context).pop();
              actions.onTapEditExpense(context, expense);
            },
            icon: Icon(Icons.edit_outlined,
                color: Theme.of(context).colorScheme.onSecondary),
            iconAlignment: IconAlignment.start,
            label: Text(PersonalExpenseStrings.edit),
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onSecondary))),
      ]),
    );
  }
}
