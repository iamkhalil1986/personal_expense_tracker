import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:personal_expense_tracker/core/bloc_provider.dart';
import 'package:personal_expense_tracker/core/loading_screen.dart';
import 'package:personal_expense_tracker/create_expense/bloc/create_expense_bloc.dart';
import 'package:personal_expense_tracker/create_expense/model/view_model/create_expense_view_model.dart';
import 'package:personal_expense_tracker/personal_expense_strings.dart';
import 'package:personal_expense_tracker/personal_expenses_enums.dart';
import 'package:personal_expense_tracker/shared/model/db_model/expense_category_dto.dart';
import 'package:personal_expense_tracker/create_expense/ui/create_expense_presenter_actions.dart';
import 'package:personal_expense_tracker/create_expense/ui/create_expense_screen.dart';
import 'package:personal_expense_tracker/shared/shared_utils.dart';
import 'package:personal_expense_tracker/view_expenses/ui/view_expenses_widget.dart';

class CreateExpensePresenter extends StatefulWidget {
  const CreateExpensePresenter({super.key});

  @override
  State<StatefulWidget> createState() => _CreateExpensePresenterState();
}

class _CreateExpensePresenterState extends State<CreateExpensePresenter> {
  late final CreateExpenseBloc _bloc;

  //Creating controllers and key here to avoid issues when on CreateExpenseScreen rebuilds
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionFieldController =
      TextEditingController();
  final TextEditingController amountFieldController = TextEditingController();
  final TextEditingController dateFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<CreateExpenseBloc>(context);
    _bloc.loadCreateExpense();
  }

  @override
  void dispose() {
    super.dispose();
    descriptionFieldController.dispose();
    amountFieldController.dispose();
    dateFieldController.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CreateExpenseViewModel>(
        stream: _bloc.createExpenseController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else {
            final viewModel = snapshot.data as CreateExpenseViewModel;
            _handleResponse(context, viewModel);
            return CreateExpenseScreen(
                actions: _PresenterActions(bloc: _bloc),
                viewModel: viewModel,
                formKey: _formKey,
                descriptionFieldController: descriptionFieldController,
                amountFieldController: amountFieldController,
                dateFieldController: dateFieldController);
          }
        });
  }

  void _prefillDataForInEditMode(CreateExpenseViewModel viewModel) {
    // In edit mode we need to prefill the details in TextFields only for first time
    if (viewModel.transactionType == TransactionType.edit &&
        descriptionFieldController.text.isEmpty &&
        amountFieldController.text.isEmpty &&
        dateFieldController.text.isEmpty) {
      descriptionFieldController.text =
          viewModel.selectedExpense.expenseDescription;
      amountFieldController.text = viewModel.selectedExpense.amount.toString();
      dateFieldController.text = viewModel.selectedExpense.expenseDate;
    }
  }

  void _handleResponse(BuildContext context, CreateExpenseViewModel viewModel) {
    _prefillDataForInEditMode(viewModel);
    if (viewModel.createExpenseActionType == CreateExpenseActionType.created) {
      _showSuccessDialog(context);
    } else if (viewModel.createExpenseActionType ==
        CreateExpenseActionType.error) {
      _showErrorDialog(context);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      SharedUtils.showDialogBox(
          context: context,
          titleWidget:
              Text(PersonalExpenseStrings.success, textAlign: TextAlign.center),
          contentWidget: Text(PersonalExpenseStrings.expenseSavedMessage,
              textAlign: TextAlign.center),
          positiveButtonTitle: PersonalExpenseStrings.ok,
          positiveAction: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return ViewExpensesWidget();
                    },
                    maintainState: false),
                (Route<dynamic> route) => false);
          });
    });
  }

  void _showErrorDialog(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      SharedUtils.showDialogBox(
          context: context,
          titleWidget:
              Text(PersonalExpenseStrings.error, textAlign: TextAlign.center),
          contentWidget: Text(PersonalExpenseStrings.expenseErrorMessage,
              textAlign: TextAlign.center),
          positiveButtonTitle: PersonalExpenseStrings.ok);
    });
  }
}

class _PresenterActions extends CreateExpensePresenterActions {
  CreateExpenseBloc bloc;

  _PresenterActions({required this.bloc});

  @override
  void onTapSubmit(
      {required BuildContext context,
      required double amount,
      required String expenseDescription,
      required String expenseDate,
      required bool updateExpense}) {
    if (updateExpense) {
      bloc.updateExpense(
          amount: amount,
          expenseDescription: expenseDescription,
          expenseDate: expenseDate);
    } else {
      bloc.createNewExpense(
          amount: amount,
          expenseDescription: expenseDescription,
          expenseDate: expenseDate);
    }
  }

  @override
  void onSelectedCategory(ExpenseCategoryDto selectedCategory) {
    bloc.updateExpenseCategory(selectedCategory);
  }
}
