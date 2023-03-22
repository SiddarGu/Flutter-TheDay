import 'package:flutter/material.dart';
import 'package:the_day/days_screen.dart';
import 'package:the_day/months_screen.dart';
import 'package:the_day/weeks_screen.dart';
import 'package:the_day/item.dart';

class Screens {
  static List<Widget Function(List<Item>)> get screens => [
        (items) => DaysScreen(items: items),
        (items) => WeeksScreen(items: items),
        (items) => MonthsScreen(items: items),
      ];
}
