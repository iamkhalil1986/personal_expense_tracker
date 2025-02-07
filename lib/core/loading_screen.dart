import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Widget? titleWidget;
  const LoadingScreen({super.key, this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: titleWidget ?? Text("")),
        body: SafeArea(child: Center(child: CircularProgressIndicator())));
  }
}
