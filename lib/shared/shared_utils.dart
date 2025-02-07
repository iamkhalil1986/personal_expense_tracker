import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SharedUtils {
  static const dialogContainer = Key('dialogContainer');
  static const dialogPositiveButton = Key('dialogPositiveButton');
  static const dialogNegativeButton = Key('dialogNegativeButton');

  static String getYearMonthDayFormat(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  static Future<void> showDialogBox(
      {required BuildContext context,
      required Widget titleWidget,
      required Widget contentWidget,
      VoidCallback? positiveAction,
      String? positiveButtonTitle,
      VoidCallback? negativeAction,
      String? negativeButtonTitle}) async {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            key: dialogContainer,
            title: titleWidget,
            content: contentWidget,
            actions: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: ElevatedButton(
                          key: dialogPositiveButton,
                          onPressed: () {
                            // Close dialog on tap of button
                            Navigator.of(context).pop();
                            if (positiveAction != null) {
                              positiveAction();
                            }
                          },
                          child: Text(positiveButtonTitle ?? "OK")),
                    ),
                  ),
                  if (negativeButtonTitle != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: ElevatedButton(
                            key: dialogNegativeButton,
                            onPressed: () {
                              // Close dialog on tap of button
                              Navigator.of(context).pop();
                              if (negativeAction != null) {
                                negativeAction();
                              }
                            },
                            child: Text(negativeButtonTitle)),
                      ),
                    )
                ],
              ),
            ],
          );
        });
  }
}
