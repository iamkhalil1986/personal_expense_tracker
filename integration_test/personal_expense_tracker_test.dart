import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:personal_expense_tracker/create_expense/ui/create_expense_widget.dart';
import 'package:personal_expense_tracker/main.dart' as app;
import 'package:personal_expense_tracker/personal_expense_keys.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expenses_widget.dart'; // Import your main.dart file

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test end to end flow', (WidgetTester tester) async {
    //Launch the app
    app.main();
    // Wait for the app to settle
    await tester.pumpAndSettle();

    //Test create expense flow
    await _testCreateExpenseFlow(tester);

    //Test edit expense flow
    await _testEditExpenseFlow(tester);

    //Test delete expense flow
    await _testDeleteExpenseFlow(tester);
  });
}

Future<void> _testCreateExpenseFlow(WidgetTester tester) async {
  // Tap the add expense button
  await tester.tap(find.byType(FloatingActionButton));

  // Wait for the UI to update
  await tester.pumpAndSettle();

  Finder descriptionField = find.byKey(PersonalExpenseKeys.descriptionFieldKey);
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
  await tester.enterText(descriptionField, "Germany Vacation");
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));

  //Enter amount
  await tester.enterText(amountField, "1200.00");
  await tester.pump();
  await Future.delayed(Duration(seconds: 1));

  //Tap on dropdown field to selected category
  await tester.tap(categoryField);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));
  //Select category option
  await tester.tap(find.text("Travel").last);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));

  //Tap on date picker field
  await tester.tap(dateField);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));
  //Tap on OK button to select the date
  await tester.tap(find.text("OK"));
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));

  //Tap on submit button to create a expense record
  await tester.tap(submitButton);
  await tester.pumpAndSettle();

  //Success dialog is displayed
  expect(find.text(PersonalExpenseStrings.success), findsOneWidget);
  expect(find.text(PersonalExpenseStrings.expenseSavedMessage), findsOneWidget);
  await Future.delayed(Duration(seconds: 2));

  Finder yesButton = find.text(PersonalExpenseStrings.ok);
  expect(yesButton, findsOneWidget);

  await tester.tap(yesButton);
  await tester.pumpAndSettle();
  expect(find.byType(ViewExpensesWidget), findsOneWidget);
  await Future.delayed(Duration(seconds: 3));
}

Future<void> _testEditExpenseFlow(WidgetTester tester) async {
  // Tap on "Germany Vacation" expense record to update
  await tester.tap(find.text("Germany Vacation"));
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));

  // Tap on edit button to update expense "Germany Vacation" to "France Vacation"
  //and amount from 1200.00 to 1000.00
  Finder editButton = find.text(PersonalExpenseStrings.edit);
  expect(editButton, findsOneWidget);
  await tester.tap(editButton);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 2));
  //It should take user to CreateExpenseWidget for editing
  expect(find.byType(CreateExpenseWidget), findsOneWidget);

  Finder descriptionField = find.byKey(PersonalExpenseKeys.descriptionFieldKey);
  Finder amountField = find.byKey(PersonalExpenseKeys.amountFieldKey);
  Finder categoryField = find.byKey(PersonalExpenseKeys.categoryFieldKey);
  Finder dateField = find.byKey(PersonalExpenseKeys.dateFieldKey);
  Finder submitButton = find.byKey(PersonalExpenseKeys.submitButtonKey);
  expect(descriptionField, findsOneWidget);
  expect(amountField, findsOneWidget);
  expect(categoryField, findsOneWidget);
  expect(dateField, findsOneWidget);
  expect(submitButton, findsOneWidget);

  //Update description
  await tester.enterText(descriptionField, "France Vacation");
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));

  //Update amount
  await tester.enterText(amountField, "1000.00");
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));

  //Tap on submit button to create a expense record
  await tester.tap(submitButton);
  await tester.pumpAndSettle();

  //Success dialog is displayed
  expect(find.text(PersonalExpenseStrings.success), findsOneWidget);
  expect(find.text(PersonalExpenseStrings.expenseSavedMessage), findsOneWidget);
  await Future.delayed(Duration(seconds: 2));

  Finder okButton = find.text(PersonalExpenseStrings.ok);
  expect(okButton, findsOneWidget);

  await tester.tap(okButton);
  await tester.pumpAndSettle();
  expect(find.byType(ViewExpensesWidget), findsOneWidget);
  await Future.delayed(Duration(seconds: 3));
}

Future<void> _testDeleteExpenseFlow(WidgetTester tester) async {
  // Tap on "Germany Vacation" expense record to update
  await tester.tap(find.text("France Vacation"));
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));

  // Tap on delete button to delete "France Vacation" record
  Finder deleteButton = find.text(PersonalExpenseStrings.delete);
  expect(deleteButton, findsOneWidget);
  await tester.tap(deleteButton);
  await tester.pumpAndSettle();

  //Delete confirmation is displayed for taking user consent to delete
  expect(find.text(PersonalExpenseStrings.warning), findsOneWidget);
  expect(find.text(PersonalExpenseStrings.deleteConfirmationMessage),
      findsOneWidget);
  await Future.delayed(Duration(seconds: 2));

  Finder noButton = find.text(PersonalExpenseStrings.no);
  expect(noButton, findsOneWidget);
  await tester.tap(noButton);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));
  //Dialog will be closed on opting No option and user will remain on same screen
  expect(find.text(PersonalExpenseStrings.deleteConfirmationMessage),
      findsNothing);

  // Tap on "Germany Vacation" expense record to update
  await tester.tap(find.text("France Vacation"));
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));

  // Tap on delete button to delete "France Vacation" record
  expect(deleteButton, findsOneWidget);
  await tester.tap(deleteButton);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 2));

  //Delete confirmation is displayed for taking user consent to delete
  expect(find.text(PersonalExpenseStrings.warning), findsOneWidget);
  expect(find.text(PersonalExpenseStrings.deleteConfirmationMessage),
      findsOneWidget);

  Finder yesButton = find.text(PersonalExpenseStrings.yes);
  expect(yesButton, findsOneWidget);

  await tester.tap(yesButton);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));
  //Dialog will be closed on opting to delete expense
  expect(find.text(PersonalExpenseStrings.deleteConfirmationMessage),
      findsNothing);
  await Future.delayed(Duration(seconds: 3));
}
