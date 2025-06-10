import 'package:flutter/material.dart';
import 'package:mynotes/utilites/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    optionsBuilder: () => {'cancel': false, 'logout': true},
  ).then((value) => value ?? false);
}
