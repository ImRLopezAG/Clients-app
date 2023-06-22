import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Text title;
  final Widget child;
  const MainLayout({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: title,
          centerTitle: true),
      body: child,
    );
  }
}
