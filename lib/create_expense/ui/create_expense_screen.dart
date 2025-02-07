import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expense_tracker/create_expense/model/view_model/create_expense_view_model.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';
import 'package:personal_expense_tracker/shared/extensions/currency_extension.dart';
import 'package:personal_expense_tracker/shared/shared_utils.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/create_expense/ui/create_expense_presenter_actions.dart';
import 'package:personal_expense_tracker/personal_expense_keys.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';

class CreateExpenseScreen extends StatelessWidget {
  final CreateExpenseViewModel viewModel;
  final CreateExpensePresenterActions actions;

  final GlobalKey<FormState> formKey;
  final TextEditingController descriptionFieldController;
  final TextEditingController amountFieldController;
  final TextEditingController dateFieldController;

  const CreateExpenseScreen(
      {super.key,
      required this.viewModel,
      required this.actions,
      required this.formKey,
      required this.descriptionFieldController,
      required this.amountFieldController,
      required this.dateFieldController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(viewModel.transactionType == TransactionType.create
              ? PersonalExpenseStrings.createNewExpense
              : PersonalExpenseStrings.updateExpense),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      elevation: 20,
                      color: Theme.of(context).colorScheme.onSecondary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _DescriptionTextFieldWidget(
                                    descriptionFieldController:
                                        descriptionFieldController),
                                SizedBox(height: 24),
                                _AmountTextFieldWidget(
                                    amountFieldController:
                                        amountFieldController),
                                SizedBox(height: 24),
                                _CategoryDropdownWidget(
                                    viewModel: viewModel, actions: actions),
                                SizedBox(height: 24),
                                _DatePickerFieldWidget(
                                    dateFieldController: dateFieldController),
                                SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          key: PersonalExpenseKeys
                                              .submitButtonKey,
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            if (formKey.currentState!
                                                .validate()) {
                                              actions.onTapSubmit(
                                                  context: context,
                                                  amount: double.tryParse(
                                                          amountFieldController
                                                              .text) ??
                                                      0.0,
                                                  expenseDescription:
                                                      descriptionFieldController
                                                          .text,
                                                  expenseDate:
                                                      dateFieldController.text,
                                                  updateExpense: viewModel
                                                          .transactionType ==
                                                      TransactionType.edit);
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                              foregroundColor:
                                                  WidgetStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary)),
                                          child: Text(
                                              PersonalExpenseStrings.submit,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary))),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ))),
            ],
          ),
        )));
  }
}

// Make use of smaller widgets with const constructor to avoid rebuilding unnecessarily
class _DescriptionTextFieldWidget extends StatelessWidget {
  final TextEditingController descriptionFieldController;
  const _DescriptionTextFieldWidget({required this.descriptionFieldController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(PersonalExpenseStrings.description,
            style: Theme.of(context).textTheme.labelLarge),
        TextFormField(
          key: PersonalExpenseKeys.descriptionFieldKey,
          keyboardType: TextInputType.text,
          controller: descriptionFieldController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: PersonalExpenseStrings.descriptionHint,
              hintStyle: Theme.of(context).textTheme.bodyMedium),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return PersonalExpenseStrings.noDescriptionError;
            } else if (value.length < 4 || value.length > 30) {
              return PersonalExpenseStrings.invalidDescriptionError;
            }
            return null;
          },
        )
      ],
    );
  }
}

class _AmountTextFieldWidget extends StatelessWidget {
  final TextEditingController amountFieldController;
  const _AmountTextFieldWidget({required this.amountFieldController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(PersonalExpenseStrings.amount,
            style: Theme.of(context).textTheme.labelLarge),
        TextFormField(
          key: PersonalExpenseKeys.amountFieldKey,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: amountFieldController,
          style: Theme.of(context).textTheme.bodyLarge,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: PersonalExpenseStrings.amountHint,
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            prefixText: getCurrencySymbol(),
          ),
          validator: (value) {
            double amount = double.tryParse(value ?? "0.0") ?? 0.00;
            if (value == null || value.isEmpty) {
              return PersonalExpenseStrings.noAmountError;
            } else if (amount <= 0.00) {
              return PersonalExpenseStrings.invalidAmountError;
            }
            return null;
          },
        )
      ],
    );
  }
}

class _CategoryDropdownWidget extends StatelessWidget {
  final CreateExpenseViewModel viewModel;
  final CreateExpensePresenterActions actions;

  const _CategoryDropdownWidget(
      {required this.viewModel, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(PersonalExpenseStrings.category,
            style: Theme.of(context).textTheme.labelLarge),
        DropdownButtonFormField(
          key: PersonalExpenseKeys.categoryFieldKey,
          value: viewModel.selectedExpense.categoryName.isNotEmpty
              ? ExpenseCategoryDto(
                  categoryId: viewModel.selectedExpense.categoryId,
                  categoryName: viewModel.selectedExpense.categoryName)
              : null,
          decoration: InputDecoration(border: OutlineInputBorder()),
          hint: Text(PersonalExpenseStrings.categoryHint,
              style: Theme.of(context).textTheme.bodyMedium),
          items: viewModel.categories.map((category) {
            return DropdownMenuItem<ExpenseCategoryDto>(
                value: category,
                child: Text(category.categoryName,
                    style: Theme.of(context).textTheme.bodyLarge));
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
      ],
    );
  }
}

class _DatePickerFieldWidget extends StatelessWidget {
  final TextEditingController dateFieldController;
  const _DatePickerFieldWidget({required this.dateFieldController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(PersonalExpenseStrings.date,
            style: Theme.of(context).textTheme.labelLarge),
        TextFormField(
          readOnly: true,
          key: PersonalExpenseKeys.dateFieldKey,
          controller: dateFieldController,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: PersonalExpenseStrings.dateHint,
              hintStyle: Theme.of(context).textTheme.bodyMedium),
          onTap: () async {
            await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2024),
              lastDate: DateTime.now(),
            ).then((date) {
              if (date != null) {
                dateFieldController.text =
                    SharedUtils.getYearMonthDayFormat(date);
              }
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return PersonalExpenseStrings.noDateError;
            }
            return null;
          },
        ),
      ],
    );
  }
}
