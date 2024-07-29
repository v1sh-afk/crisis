import 'package:flutter/material.dart';

class ContentState extends InheritedWidget {
  final Function(String) removeContent;
  final Widget child;

  ContentState({
    required this.removeContent,
    required this.child,
  }) : super(child: child);

  static ContentState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ContentState>();
  }

  @override
  bool updateShouldNotify(ContentState oldWidget) {
    return oldWidget.removeContent != removeContent;
  }
}
