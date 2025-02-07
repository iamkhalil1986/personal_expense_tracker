import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/core/bloc_provider.dart';
import 'package:personal_expense_tracker/create_expense/bloc/create_expense_bloc.dart';
import 'package:personal_expense_tracker/create_expense/ui/create_expense_widget.dart';
import 'package:personal_expense_tracker/personal_expense_keys.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';
import 'package:personal_expense_tracker/view_expenses/bloc/view_expenses_bloc.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expenses_widget.dart';

import '../../create_expense/bloc/mock_create_expense_bloc.dart';
import '../../shared/mock_data_provider.dart';
import '../bloc/mock_view_expenses_bloc.dart';

void main() {
  testViewExpensesWidget();
}

void testViewExpensesWidget() {
  group('ViewExpensesWidget tests', () {
    setUpAll(() {
      registerFallbackValue(MockDataProvider.shoppingCategory);
      registerFallbackValue(MockDataProvider.shoppingExpense);
    });

    testWidgets('Test list of expenses with no data', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider<ViewExpensesBloc>(
              create: (_) => MockViewExpensesBloc.withNoExpenses(),
              child: ViewExpensesWidget())));
      await tester.pumpAndSettle();
      //find No expense records are available message on screen.
      expect(find.text(PersonalExpenseStrings.noExpensesFoundMessage),
          findsOneWidget);
    });

    testWidgets('Test list of expenses and category filter', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider<ViewExpensesBloc>(
              create: (_) => MockViewExpensesBloc.withExpenses(),
              child: ViewExpensesWidget())));
      await tester.pumpAndSettle();

      Finder categoryField = find.byKey(PersonalExpenseKeys.categoryFieldKey);
      Finder listItems = find.byType(ListTile);
      expect(listItems, findsWidgets);
      expect(categoryField, findsOneWidget);

      //Tap on dropdown field to selected category
      await tester.tap(categoryField);
      await tester.pump();
      //Select category option
      await tester.tap(find.text("Shopping").last);
      await tester.pump();
      //Find records with Shopping category text
      expect(find.text("Shopping"), findsWidgets);
    });

    testWidgets('Test delete expense flow', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider<ViewExpensesBloc>(
              create: (_) => MockViewExpensesBloc.withExpenses(),
              child: ViewExpensesWidget())));
      await tester.pumpAndSettle();

      Finder listItems = find.byType(ListTile);
      expect(listItems, findsWidgets);

      //Tap on first expense record to view details
      await tester.tap(listItems.first);
      await tester.pumpAndSettle();

      Finder deleteButton = find.text(PersonalExpenseStrings.delete);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      //Delete confirmation is displayed for taking user consent to delete
      expect(find.text(PersonalExpenseStrings.warning), findsOneWidget);
      expect(find.text(PersonalExpenseStrings.deleteConfirmationMessage),
          findsOneWidget);

      Finder yesButton = find.text(PersonalExpenseStrings.yes);
      expect(yesButton, findsOneWidget);

      await tester.tap(yesButton);
      await tester.pumpAndSettle();
      //Dialog will be closed on opting to delete expense
      expect(find.text(PersonalExpenseStrings.deleteConfirmationMessage),
          findsNothing);
    });

    testWidgets('Test edit expense flow', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider<CreateExpenseBloc>(
        create: (_) => MockCreateExpensesBloc.success(),
        child: BlocProvider<ViewExpensesBloc>(
            create: (_) => MockViewExpensesBloc.withExpenses(),
            child: Navigator(onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                  builder: (context) => const ViewExpensesWidget());
            })),
      )));
      await tester.pumpAndSettle();

      Finder listItems = find.byType(ListTile);
      expect(listItems, findsWidgets);

      //Tap on first expense record to view details
      await tester.tap(listItems.first);
      await tester.pumpAndSettle();

      Finder editButton = find.text(PersonalExpenseStrings.edit);
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();
      //It should take user to CreateExpenseWidget for editing
      expect(find.byType(CreateExpenseWidget), findsOneWidget);
    });
  });
}
