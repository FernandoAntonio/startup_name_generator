import 'package:another_flushbar/flushbar.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Flushbar showDeletedSnackbar(BuildContext context) {
  return Flushbar(
    message: "All Saved Suggestions Deleted.",
    icon: Icon(
      Icons.remove_circle,
      size: 25.0,
      color: Colors.red,
    ),
    duration: Duration(seconds: 2),
    leftBarIndicatorColor: Colors.red,
    backgroundColor: Colors.grey[900]!,
  )..show(context);
}

Flushbar showDismissedSnackbar(BuildContext context, WordPair wordPair) {
  return Flushbar(
    title: "Name Dismissed",
    message: "\"${wordPair.asPascalCase}\"",
    icon: Icon(
      Icons.remove_circle,
      size: 25.0,
      color: Colors.red,
    ),
    duration: Duration(seconds: 2),
    leftBarIndicatorColor: Colors.red,
    backgroundColor: Colors.grey[900]!,
  )..show(context);
}
