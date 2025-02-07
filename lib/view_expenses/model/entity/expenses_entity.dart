import 'package:equatable/equatable.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';

class ExpensesEntity extends Equatable {
  // Selected category to filter expenses
  final ExpenseCategoryDto? selectedCategory;
  //Once fetched from database, all categories usage will be done with this.
  //As list of categories will not be changing frequently
  final List<ExpenseCategoryDto> categories;

  const ExpensesEntity({this.selectedCategory, this.categories = const []});

  ExpensesEntity merge(
      {ExpenseCategoryDto? selectedCategory,
      List<ExpenseCategoryDto>? categories}) {
    return ExpensesEntity(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [selectedCategory, categories];
}
