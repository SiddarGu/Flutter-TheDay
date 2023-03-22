import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_day/item.dart';
import 'package:the_day/database.dart';

class MonthsScreen extends StatefulWidget {
  List<Item> items;

  MonthsScreen({Key? key, required this.items}) : super(key: key);

  @override
  _MonthsScreenState createState() => _MonthsScreenState();
}

class _MonthsScreenState extends State<MonthsScreen> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          Item item = widget.items[index];
          final difference = (DateTime.now().difference(item.date).inDays / 30).toStringAsFixed(2);

          return Dismissible(
            key: Key(item.id.toString()),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) async {
              await DatabaseProvider.dbProvider.deleteItem(item.id);
              setState(() {
                widget.items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deletion successful!'),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        widget.items.insert(index, item);
                        DatabaseProvider.dbProvider.addItem(item);
                      });
                    },
                  ),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(item.description),
              subtitle: Text('$difference months'),
            ),
          );
        },
      );
  }
}
