import 'package:flutter/material.dart';

Widget defaultAppBuilder(BuildContext context, Widget? child) {
  return SafeArea(
    top: false,
    child: child ?? const SizedBox(),
  );
}
