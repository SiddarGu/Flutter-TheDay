import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_day/item.dart';
import 'package:the_day/database.dart';
import 'package:the_day/screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en', 'US'),
    ],
    title: 'The Day',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const TheDay(),
  ));
}

class TheDay extends StatefulWidget {
  const TheDay({super.key});

  @override
  State<StatefulWidget> createState() => _TheDayState();
}

class _TheDayState extends State<TheDay> {
  int _currentIndex = 0;
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _getItemsFromDatabase();
  }

  Future<void> _getItemsFromDatabase() async {
    List<Item> items = await DatabaseProvider.dbProvider.getItems();
    setState(() {
      _items = items;
    });
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    DateTime? selectedDate = DateTime.now();

    nameController.text = '';
    dateController.text = DateFormat.yMd().format(DateTime.now());
    selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.create),
                    border: OutlineInputBorder(
                      //Outline border type for TextFeild
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.redAccent,
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        //Outline border type for TextFeild
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 3,
                        ))),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    //Outline border type for TextFeild
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                      width: 3,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      //Outline border type for TextFeild
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 3,
                      )),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate!,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                    dateController.text = DateFormat.yMd().format(pickedDate);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text;
                if (name.isNotEmpty && selectedDate != null) {
                  Item newItem = Item(
                    id: _items.length + 1,
                    description: name,
                    date: selectedDate!.toUtc(),
                  );
                  await DatabaseProvider.dbProvider.addItem(newItem);
                  _getItemsFromDatabase();
                  if (!mounted) return;
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Day'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: Screens.screens.map((screen) => screen(_items)).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Days',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Weeks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_time),
            label: 'Months',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _showAddItemDialog(context);
          },
          tooltip: 'Add Item',
          child: const Icon(Icons.add)),
    );
  }
}
