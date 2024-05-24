import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListViewScreen extends StatefulWidget {
  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  List<String> items2 = [];

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
        items2 = savedItems;
      });
    }
  }

  void addItem(String item) {
    setState(() {
      items2.add(item);
      saveText(items2);
    });
  }

  void removeItem(int index) {
    setState(() {
      items2.removeAt(index);
      saveText(items2);
    });
  }

  Future<void> saveText(List<String> items2) async {
    final sharedPreferences = GetIt.instance<SharedPreferences>();
    await sharedPreferences.setStringList('items2', items2);
  }

  Future<List<String>> getSavedText(SharedPreferences sharedPreferences) async {
    return sharedPreferences.getStringList('items2') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Контакты'),
      ),
      body: ListView.builder(
        itemCount: items2.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items2[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                removeItem(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          String newItem1 = '';
          String newItem2 = '';
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.blueAccent,
                title: const Text('Новый контакт'),
                content: Column(
                  children: <Widget>[
                    const Text('Имя'),
                    TextField(
                      controller: nameController,
                      onChanged: (value) {
                        newItem1 = value;
                      },
                    ),
                    const Text('Номер'),
                    TextField(
                      controller: numberController,
                      onChanged: (value) {
                        newItem2 = value;
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop('$newItem1 - $newItem2');
                      nameController.clear();
                      numberController.clear();
                    },
                  ),
                ],
              );
            },
          );
          if (newItem1.isNotEmpty && newItem2.isNotEmpty) {
            addItem('$newItem1 - $newItem2');
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}