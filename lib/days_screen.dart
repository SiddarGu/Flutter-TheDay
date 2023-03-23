import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_day/item.dart';
import 'package:the_day/database.dart';

class DaysScreen extends StatefulWidget {
  List<Item> items;

  DaysScreen({Key? key, required this.items}) : super(key: key);

  @override
  _DaysScreenState createState() => _DaysScreenState();
}

class _DaysScreenState extends State<DaysScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        Item item = widget.items[index];
        final difference = DateTime.now().difference(item.date).inDays;
        String date = DateFormat('yyyy-MM-dd').format(item.date);

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
          child: Card(
              child: ListTile(
            title: Text(item.description),
            subtitle: Text('$date'),
            trailing: Text('$difference days'),
          )),
        );
      },
    );
  }
}
