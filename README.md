# Personal Expense Tracker

An open source project to track and manage daily expenses. Follow are the features:

1. View expenses grouped by date.
2. Filter expenses based on expense category type (e.g., Food, Travel, Shopping).
3. Create new expense record.
4. Edit existing expense record.
5. Delete existing record.

Inorder to run the application you first have to get all dependencies by using 
```
flutter pub get
```

For initial run we have prefilled some expense categories and expenses records in database. Feel free to remove this piece of code from lib/shared/database_helper.dart.
```
Future<void> _prefillCategoriesAndExpenseRecordsInDatabase(
      Database db) async {
    // Prefill some categories for initial run
    const List<String> prefilledCategories = [
      "Accommodation",
      "Food",
      "Shopping",
      "Travel",
      "Utilities bills"
    ];
    for (String categoryName in prefilledCategories) {
      var categoryObject =
          ExpenseCategoryDto(categoryId: 0, categoryName: categoryName);
      await db.insert(_tblCategories, categoryObject.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    List<ExpenseDto> prefilledExpenses = [
      ExpenseDto(
          amount: 1200.00,
          expenseDate: SharedUtils.getYearMonthDayFormat(DateTime.now()),
          expenseDescription: "Monthly House rent",
          categoryId: 1,
          categoryName: "Accommodation"),
      ExpenseDto(
          amount: 24.99,
          expenseDate: SharedUtils.getYearMonthDayFormat(
              DateTime.now().add(Duration(days: -10))),
          expenseDescription: "Hotel room rent",
          categoryId: 1,
          categoryName: "Accommodation"),
      ExpenseDto(
          amount: 1000.00,
          expenseDate: SharedUtils.getYearMonthDayFormat(DateTime.now()),
          expenseDescription: "Monthly Groceries",
          categoryId: 2,
          categoryName: "Food"),
      ExpenseDto(
          amount: 20.99,
          expenseDate: SharedUtils.getYearMonthDayFormat(
              DateTime.now().add(Duration(days: -10))),
          expenseDescription: "Lunch in Berlin",
          categoryId: 2,
          categoryName: "Food")
    ];

    for (ExpenseDto expense in prefilledExpenses) {
      await db.insert(_tblExpenses, expense.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
```

# Application Architecture
This app make use of simple BLOC pattern to implement all business logics inside BLOC for state management. Below is feature structure with all components used and their responsibilities.
```
    /feature-name (View Expenses)
        /ui
            - view_expenses_widget.dart
            - view_expenses_presenter.dart
            - view_expenses_presenter_actions.dart
            - view_expenses_screen.dart
        /model
            /db_model
                - expenses_dto.dart
            /entity
                - expenses_entity.dart
            /view_model
                - expenses_view_model
        /bloc
            - view_expenses_bloc.dart            
```

### BLOC
BLOC stands for business logic component. As name suggest it performs all business logic operations init on the data retrieved from external repository or database. It process the data from external dependencies, prepare  and send ViewModel to Presenter using StreamControllers. 

### Feature Widget :
This is widget which initiates loading of screen and wrapping presenter with BlocProvider which will provide BLOC access to all its child widgets.

### Presenter :
Request data from BLOC and receive data in the form of ViewModel using Stream. It also responsible for handling error/success response from BLOC.

### Presenter Actions:
This component will intercept all actions user is performing on the screen and pass it to BLOC if needed.

### Screen:
Responsibility of screen is just to design UI based on ViewModel Data. Screen should not contain any business logic and no state variables are defined.

### DbModel:
Class objects which are retrieved from database.

### Entity:
Entity is a class which holds data related to actions performed by user on screen. For example category selected by user to apply filter. we need this information for both getting data from database and preparing ViewModel. This will also represent current state of the screen.

### ViewModel:
ViewModel contains the only required information needed to be displayed on the screen excluding all the other data comes from external Repository or Database.
Example: expense-list, category-list, current-category-filter, is-expense-record-deleted-successfully.


## Dependencies
We have used the following dependencies (Production dependencies)
1. equatable : Very useful plugin, wherever object comparison is needed.
2. provider : A wrapper around InheritedWidget to make them easier to use and more reusable. Used it for implementing a basic BLOC design pattern.
3. sqflite : A plugin which provides interface to access SQLite database and perform CRUD operations on database.
4. intl : Used it for finding device locale for formatting currency.

```
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  equatable: ^2.0.7
  provider: ^6.1.2
  sqflite: ^2.4.1
  intl: ^0.20.1
```

There are few dev dependencies are also used for implementing Unit tests, Widget tests and Integration tests.
```
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mocktail: ^1.0.4
```

## Commands for running application and execute unit/widget/integration tests
Once dependencies are fetched using "flutter pub get", run below command to run application.
```
flutter run 
```

We have prepared a test suite for running all test cases together from a single file ./test/personal_expense_tracker_test.dart and can run below command to run tests. This approach is very helpfull and faster to run all test together instead of running for entire /test folder. 
```
flutter test ./test/personal_expense_tracker_test.dart 
```

Inorder to run integration test, run below command
```
flutter test integration_test/personal_expense_tracker_test.dart
```