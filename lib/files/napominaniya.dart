import 'package:flutter/material.dart';


class ListViewSeparatedScreen extends StatefulWidget {
  @override
  _ListViewSeparatedScreenState createState() => _ListViewSeparatedScreenState();
}

class _ListViewSeparatedScreenState extends State<ListViewSeparatedScreen> {
  final TextEditingController textController = TextEditingController();
  List<String> items = [];

  void addItem() {
    setState(() {
      items.add('Напоминание ${items.length + 1}');
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Напоминания'),
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
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
        onPressed: addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}