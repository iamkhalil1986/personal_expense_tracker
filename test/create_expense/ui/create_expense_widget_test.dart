import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/core/bloc_provider.dart';
import 'package:personal_expense_tracker/create_expense/bloc/create_expense_bloc.dart';
import 'package:personal_expense_tracker/create_expense/ui/create_expense_widget.dart';
import 'package:personal_expense_tracker/personal_expense_keys.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';

import '../../shared/mock_data_provider.dart';
import '../bloc/mock_create_expense_bloc.dart';

void main() {
  testCreateExpenseWidget();
}

void testCreateExpenseWidget() {
  group('CreateExpenseWidget tests', () {
    setUpAll(() {
      registerFallbackValue(MockDataProvider.travelCategory);
    });

    testWidgets('Test expense creation flow with success', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider<CreateExpenseBloc>(
              create: (_) => MockCreateExpensesBloc.success(
                  transactionType: TransactionType.create),
              child: CreateExpenseWidget.add())));
      await tester.pumpAndSettle();
      Finder descriptionField =
          find.byKey(PersonalExpenseKeys.descriptionFieldKey);
      Finder amountField = find.byKey(PersonalExpenseKeys.amountFieldKey);
      Finder categoryField = find.byKey(PersonalExpenseKeys.categoryFieldKey);
      Finder dateField = find.byKey(PersonalExpenseKeys.dateFieldKey);
      Finder submitButton = find.byKey(PersonalExpenseKeys.submitButtonKey);
      expect(descriptionField, findsOneWidget);
      expect(amountField, findsOneWidget);
      expect(categoryField, findsOneWidget);
      expect(dateField, findsOneWidget);
      expect(submitButton, findsOneWidget);

      //Enter text in description field
      await tester.enterText(descriptionField, "Paris Vacation");
      await tester.pump();

      //Enter amount
      await tester.enterText(amountField, "20.00");
      await tester.pump();

      //Tap on dropdown field to selected category
      await tester.tap(categoryField);
      await tester.pump();
      //Select category option
      await tester.tap(find.text("Travel").last);
      await tester.pump();

      //Tap on date picker field
      await tester.tap(dateField);
      await tester.pump();
      //Tap on OK button to select the date
      await tester.tap(find.text("OK"));
      await tester.pump();

      //Tap on submit button to create a expense record
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      //Success dialog is displayed
      expect(find.text(PersonalExpenseStrings.success), findsOneWidget);
      expect(find.text(PersonalExpenseStrings.expenseSavedMessage),
          findsOneWidget);
    });

    testWidgets('Test expense creation flow with error', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider<CreateExpenseBloc>(
              create: (_) => MockCreateExpensesBloc.error(
                  transactionType: TransactionType.create),
              child: CreateExpenseWidget.add())));
      await tester.pumpAndSettle();
      Finder descriptionField =
          find.byKey(PersonalExpenseKeys.descriptionFieldKey);
      Finder amountField = find.byKey(PersonalExpenseKeys.amountFieldKey);
      Finder categoryField = find.byKey(PersonalExpenseKeys.categoryFieldKey);
      Finder dateField = find.byKey(PersonalExpenseKeys.dateFieldKey);
      Finder submitButton = find.byKey(PersonalExpenseKeys.submitButtonKey);
      expect(descriptionField, findsOneWidget);
      expect(amountField, findsOneWidget);
      expect(categoryField, findsOneWidget);
      expect(dateField, findsOneWidget);
      expect(submitButton, findsOneWidget);

      //Enter text in description field
      await tester.enterText(descriptionField, "Paris Vacation");
      await tester.pump();

      //Enter amount
      await tester.enterText(amountField, "20.00");
      await tester.pump();

      //Tap on dropdown field to selected category
      await tester.tap(categoryField);
      await tester.pump();
      //Select category option
      await tester.tap(find.text("Travel").last);
      await tester.pump();

      //Tap on date picker field
      await tester.tap(dateField);
      await tester.pump();
      //Tap on OK button to select the date
      await tester.tap(find.text("OK"));
      await tester.pump();

      //Tap on submit button to create a expense record
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      //Error dialog is displayed
      expect(find.text(PersonalExpenseStrings.error), findsOneWidget);
      expect(find.text(PersonalExpenseStrings.expenseErrorMessage),
          findsOneWidget);
    });

    testWidgets('Test expense edit flow with success', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<CreateExpenseBloc>(
            create: (_) => MockCreateExpensesBloc.success(
                transactionType: TransactionType.edit),
            child: CreateExpenseWidget.edit(
                selectedExpense: MockDataProvider.travelExpense)),
      ));
      await tester.pumpAndSettle();
      Finder submitButton = find.byKey(PersonalExpenseKeys.submitButtonKey);
      Finder amountField = find.byKey(PersonalExpenseKeys.amountFieldKey);
      expect(amountField, findsOneWidget);
      expect(submitButton, findsOneWidget);

      //Update amount value
      await tester.enterText(amountField, "40.00");
      await tester.pump();

      //Tap on submit button to update expense record
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      //Success dialog is displayed
      expect(find.text(PersonalExpenseStrings.success), findsOneWidget);
      expect(find.text(PersonalExpenseStrings.expenseSavedMessage),
          findsOneWidget);
    });

    testWidgets('Test expense edit flow with error', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<CreateExpenseBloc>(
          create: (_) => MockCreateExpensesBloc.error(
              transactionType: TransactionType.edit),
          child: CreateExpenseWidget.edit(
              selectedExpense: MockDataProvider.travelExpense),
        ),
      ));
      await tester.pumpAndSettle();
      Finder submitButton = find.byKey(PersonalExpenseKeys.submitButtonKey);
      Finder amountField = find.byKey(PersonalExpenseKeys.amountFieldKey);
      expect(amountField, findsOneWidget);
      expect(submitButton, findsOneWidget);

      //Update amount value
      await tester.enterText(amountField, "40.00");
      await tester.pump();

      //Tap on submit button to update expense record
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      //Error dialog is displayed
      expect(find.text(PersonalExpenseStrings.error), findsOneWidget);
      expect(find.text(PersonalExpenseStrings.expenseErrorMessage),
          findsOneWidget);
    });
  });
}
