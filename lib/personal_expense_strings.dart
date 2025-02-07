class PersonalExpenseStrings {
  static const expenses = "Expenses";

  static const accommodationCategory = "Accommodation";
  static const foodCategory = "Food";
  static const shoppingCategory = "Shopping";
  static const travelCategory = "Travel";
  static const utilitiesCategory = "Utilities bills";

  static const categoryImagesMap = {
    PersonalExpenseStrings.accommodationCategory:
        "assets/images/accommodation.png",
    PersonalExpenseStrings.foodCategory: "assets/images/food.png",
    PersonalExpenseStrings.shoppingCategory: "assets/images/shopping.png",
    PersonalExpenseStrings.travelCategory: "assets/images/travel.png",
    PersonalExpenseStrings.utilitiesCategory: "assets/images/utilities.png"
  };

  static const updateExpense = "Update Expense";
  static const createNewExpense = "Create New Expense";
  static const description = "Description:";
  static const descriptionHint = "Enter description";
  static const noDescriptionError = "Enter a valid description";
  static const invalidDescriptionError =
      "Enter a valid description between 4 to 30 characters";

  static const amount = "Amount:";
  static const amountHint = "Enter amount";
  static const noAmountError = "Enter a valid amount";
  static const invalidAmountError = "Amount value should be greater than 0.00";

  static const category = "Category:";
  static const categoryHint = "Select category";
  static const noCategoryError = "Select a valid category";

  static const date = "Date:";
  static const dateHint = "Select date";
  static const noDateError = "Select a valid date";

  static const submit = "Submit";
  static const success = "Success!";
  static const error = "Error!";
  static const expenseErrorMessage =
      "Unable to save expense details. Please check all the information provided.";
  static const expenseSavedMessage = "Expense details saved successfully.";
  static const ok = "OK";

  static const delete = "Delete";
  static const edit = "Edit";
  static const expenseDeletedMessage =
      "Expense record has been deleted successfully.";
  static const defaultCategoryOption = "All";
  static const warning = "Warning!";
  static const deleteConfirmationMessage =
      "Do you want to delete this expense details?";
  static const yes = "YES";
  static const no = "NO";

  static const somethingWentWrong = 'Something Went Wrong';
  static const technicalDifficulties =
      'We\'re experiencing some technical difficulties and cannot process your '
      'request at this time. Please try again later.';
  static const noExpensesFoundMessage = "No expense records are available.";

  static const descriptionLabel = "Description";
  static const amountLabel = "Amount";
  static const dateLabel = "Date";
}
