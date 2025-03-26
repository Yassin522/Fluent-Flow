import 'package:flutter/material.dart';
import 'package:fluent_flow/core/const/styles.dart';

void showToast(String message, BuildContext context, bool enableActions) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.black87.withOpacity(0.8),
    content: Text(
      message,
      style: TextStyle(
        fontStyle: FontStyle.normal,
        color: fluentWhite
      ),
    ),
    duration: enableActions ? const Duration(seconds: 6) : const Duration(seconds: 4),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
    action: enableActions? SnackBarAction(
      label: 'hide',
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }) : null,
  ));
}

void showMapToast(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontStyle: FontStyle.normal,
      ),
    ),
    duration: const Duration(seconds: 2),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
  ));
}