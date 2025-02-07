import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/personal_expense_keys.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';
import 'package:personal_expense_tracker/shared/extensions/extensions.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';
import 'package:personal_expense_tracker/view_expenses/model/view_model/expenses_view_model.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expense_detail_screen.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expenses_presenter_actions.dart';

class ViewExpensesScreen extends StatelessWidget {
  final ExpensesViewModel viewModel;
  final ViewExpensesPresenterActions actions;

  const ViewExpensesScreen(
      {super.key, required this.viewModel, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(PersonalExpenseStrings.expenses),
            backgroundColor: Theme.of(context).colorScheme.primary),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: SafeArea(
            child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _CategoryDropdownWidget(
                        viewModel: viewModel, actions: actions)),
                //SegmentedButton(segments: segments, selected: selected)
              ],
            ),
            Expanded(
                child: viewModel.groupedExpenses.isNotEmpty
                    ? ListView.builder(
                        itemCount: viewModel.groupedExpenses.length,
                        itemBuilder: (context, index) {
                          final expenseGroup = viewModel.groupedExpenses[index];
                          return Column(
                            children: [
                              _ExpenseSectionHeader(expenseGroup.date,
                                  expenseGroup.totalExpenses),
                              _ExpensesListWidget(
                                  expenses: expenseGroup.expenses,
                                  actions: actions)
                            ],
                          );
                        })
                    : _NoExpensesFoundWidget(actions: actions))
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => actions.onTapCreateNewExpense(context),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: const Icon(Icons.add),
        ));
  }
}

class _CategoryDropdownWidget extends StatelessWidget {
  final ExpensesViewModel viewModel;
  final ViewExpensesPresenterActions actions;

  const _CategoryDropdownWidget(
      {required this.viewModel, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        key: PersonalExpenseKeys.categoryFieldKey,
        value: viewModel.selectedCategory,
        icon: Icon(Icons.filter_list_alt),
        decoration: InputDecoration(border: OutlineInputBorder()),
        hint: Text(PersonalExpenseStrings.categoryHint),
        items: viewModel.categories.map((category) {
          return DropdownMenuItem<ExpenseCategoryDto>(
              value: category, child: Text(category.categoryName));
        }).toList(),
        onChanged: (ExpenseCategoryDto? value) {
          actions.onSelectedCategory(value!);
        },
        validator: (ExpenseCategoryDto? value) {
          if (value == null) {
            return PersonalExpenseStrings.noCategoryError;
          }
          return null;
        },
      ),
    );
  }
}

class _ExpenseSectionHeader extends StatelessWidget {
  final String dateString;
  final double totalAmount;

  const _ExpenseSectionHeader(this.dateString, this.totalAmount);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
        children: <Widget>[
          Expanded(
            key: const Key('paymentDate'),
            child: Text(
              dateString,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            key: const Key('totalAmount'),
            child: Text(
              totalAmount.parseCurrency(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}

class _ExpensesListWidget extends StatelessWidget {
  final List<ExpenseDto> expenses;
  final ViewExpensesPresenterActions actions;

  const _ExpensesListWidget({required this.expenses, required this.actions});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ListTile(
          onTap: () {
            showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).colorScheme.surface,
                builder: (BuildContext context) {
                  return ExpenseDetailScreen(
                      expense: expense, actions: actions);
                });
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          leading: Image.asset(
            PersonalExpenseStrings.categoryImagesMap[expense.categoryName]!,
            height: 48,
            width: 48,
            fit: BoxFit.fill,
          ),
          title: Text(expense.expenseDescription,
              style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(expense.categoryName,
              style: Theme.of(context).textTheme.bodySmall),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(expense.amount.parseCurrency(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}

class _NoExpensesFoundWidget extends StatelessWidget {
  final ViewExpensesPresenterActions actions;
  const _NoExpensesFoundWidget({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(PersonalExpenseStrings.noExpensesFoundMessage),
        ],
      ),
    );
  }
}
