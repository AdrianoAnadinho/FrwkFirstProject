import 'package:flutter/material.dart';

import 'Item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  var items = <Item>[];

  MyHomePage() {
    // items = [];
    items.add(Item(done: true, title: 'levantou'));
    items.add(Item(done: false, title: 'caiu'));
    items.add(Item(done: true, title: 'subiu'));
    items.add(Item(done: false, title: 'desceu'));
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  TextEditingController nomeItemCont = TextEditingController();

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];

          return SizedBox(
            // height: 50,
            child: CheckboxListTile(
              title: Text(item.title.toString()),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                });
              },
              key: Key(item.title.toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.items
                            .add(Item(done: false, title: nomeItemCont.text));
                        nomeItemCont.clear();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context1).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Item inserido com sucesso'),
                          ),
                        );
                      });
                    },
                    child: Text('Add'),
                  )
                ],
                title: Text('Adicione um item'),
                content: TextFormField(
                  controller: nomeItemCont,
                  decoration: InputDecoration(labelText: 'Nome do item'),
                ),
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
