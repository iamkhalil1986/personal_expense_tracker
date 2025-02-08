import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_dto.dart';
import 'package:personal_expense_tracker/shared/shared_utils.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final String _databaseName = "personal_expenses.db";
  final String _tblCategories = "tbl_categories";
  final String _tblExpenses = "tbl_expenses";

  static final DatabaseHelper _dbInstance = DatabaseHelper._internal();
  factory DatabaseHelper() => _dbInstance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = "$dbPath/$_databaseName";
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "Create table $_tblCategories(category_id INTEGER PRIMARY KEY AUTOINCREMENT, category_name TEXT UNIQUE)");
    await db.execute(
        "Create table $_tblExpenses(expense_id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL, expense_date TEXT, expense_description TEXT, category_id INTEGER, FOREIGN KEY(category_id) REFERENCES $_tblCategories(category_id))");

    // Prefilled some data for initial run
    await _prefillCategoriesAndExpenseRecordsInDatabase(db);
  }

  //****************** Categories Methods *****************
  Future<List<ExpenseCategoryDto>> getCategories() async {
    final db = await _dbInstance.database;
    final List<Map<String, dynamic>> dbCategories =
        await db.query(_tblCategories);
    List<ExpenseCategoryDto> products = dbCategories
        .map((product) => ExpenseCategoryDto.fromJson(product))
        .toList();
    return products;
  }

  Future<bool> addCategory(ExpenseCategoryDto category) async {
    final db = await _dbInstance.database;
    return await db.insert(_tblCategories, category.toJson(),
            conflictAlgorithm: ConflictAlgorithm.fail) ==
        1;
  }

  Future<bool> updateCategory(ExpenseCategoryDto newCategory) async {
    final db = await _dbInstance.database;
    return await db.update(_tblCategories, newCategory.toJson(),
            where: 'category_id = ?',
            whereArgs: [newCategory.categoryId],
            conflictAlgorithm: ConflictAlgorithm.fail) ==
        1;
  }
  //*********** Categories Methods Ends Here *************

  //****************** Expenses Methods *****************
  Future<List<ExpenseDto>> getAllExpenses() async {
    final db = await _dbInstance.database;
    final List<Map<String, dynamic>> dbExpenses = await db.rawQuery('''
    SELECT 
    tbl_expenses.expense_id, 
    tbl_expenses.expense_description, 
    tbl_expenses.amount, 
    tbl_expenses.expense_date, 
    tbl_categories.category_id, 
    tbl_categories.category_name
    FROM tbl_expenses
    INNER JOIN tbl_categories ON tbl_expenses.category_id = tbl_categories.category_id order by tbl_expenses.expense_date DESC
  ''');

    List<ExpenseDto> expenses = dbExpenses.map((expenseMap) {
      return ExpenseDto.fromJson(expenseMap);
    }).toList();
    return expenses;
  }

  Future<List<ExpenseDto>> getExpensesForCategory(
      ExpenseCategoryDto selectedCategory) async {
    final db = await _dbInstance.database;
    final List<Map<String, dynamic>> dbExpenses = await db.rawQuery('''
    SELECT 
    tbl_expenses.expense_id, 
    tbl_expenses.expense_description, 
    tbl_expenses.amount, 
    tbl_expenses.expense_date, 
    tbl_categories.category_id, 
    tbl_categories.category_name
    FROM tbl_expenses
    INNER JOIN tbl_categories ON tbl_expenses.category_id = tbl_categories.category_id where tbl_expenses.category_id = ${selectedCategory.categoryId} order by tbl_expenses.expense_date DESC
  ''');

    List<ExpenseDto> expenses = dbExpenses.map((expenseMap) {
      return ExpenseDto.fromJson(expenseMap);
    }).toList();
    return expenses;
  }

  Future<bool> updateExpense(ExpenseDto newExpense) async {
    final db = await _dbInstance.database;
    return await db.update(_tblExpenses, newExpense.toJson(),
            where: 'expense_id = ?',
            whereArgs: [newExpense.expenseId],
            conflictAlgorithm: ConflictAlgorithm.fail) !=
        0;
  }

  Future<bool> addExpense(ExpenseDto expense) async {
    final db = await _dbInstance.database;
    return await db.insert(_tblExpenses, expense.toJson(),
            conflictAlgorithm: ConflictAlgorithm.fail) !=
        0;
  }

  Future<bool> deleteExpense(ExpenseDto expense) async {
    final db = await _dbInstance.database;
    return await db.delete(_tblExpenses,
            where: 'expense_id = ?', whereArgs: [expense.expenseId]) !=
        0;
  }

  //************************ Prefill data for initial run ***************************/
  //This is only one time activity
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
}
