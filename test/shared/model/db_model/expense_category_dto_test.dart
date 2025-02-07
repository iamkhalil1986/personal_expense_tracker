import 'package:equatable/equatable.dart';

class ExpenseCategoryDto extends Equatable {
  final int categoryId;
  final String categoryName;

  const ExpenseCategoryDto(
      {required this.categoryId, required this.categoryName});

  factory ExpenseCategoryDto.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryDto(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
    };
  }

  @override
  List<Object?> get props => [categoryId, categoryName];
}
