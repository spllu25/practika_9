import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColumnListScreen extends StatefulWidget {
  @override
  _ColumnListScreenState createState() => _ColumnListScreenState();
}

class _ColumnListScreenState extends State<ColumnListScreen> {
  final TextEditingController textController = TextEditingController();
  List<String> items1 = [];

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  void loadSharedPreferences() async {
    final sharedPreferences = GetIt.instance<SharedPreferences>();
    final savedItems = await getSavedText(sharedPreferences);
    if (savedItems.isNotEmpty) {
      setState(() {
        items1 = savedItems;
      });
    }
  }

  void addItem(String item) {
    setState(() {
      items1.add(item);
      saveText(items1);
    });
  }

  void removeItem(int index) {
    setState(() {
      items1.removeAt(index);
      saveText(items1);
    });
  }

  Future<void> saveText(List<String> items1) async {
    final sharedPreferences = GetIt.instance<SharedPreferences>();
    await sharedPreferences.setStringList('items1', items1);
  }

  Future<List<String>> getSavedText(SharedPreferences sharedPreferences) async {
    return sharedPreferences.getStringList('items1') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      appBar: AppBar(
        title: Text('Заметки'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(width: 100.0, height: 50.0),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
            ),
            onPressed: () async {
              String newItem = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  String inputText = '';
                  return AlertDialog(
                    backgroundColor: Colors.blueAccent,
                    title: Text('Новая заметка'),
                    content: TextField(
                      controller: textController,
                      onChanged: (value) {
                        inputText = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop(inputText);
                          textController.clear();
                        },
                      ),
                    ],
                  );
                },
              );

              if (newItem != null && newItem.isNotEmpty) {
                addItem(newItem);
              }
            },
            child: Text('Добавить заметку'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items1.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items1[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeItem(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
