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
  TextEditingController nomeItemCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];

          return Dismissible(
            background: Container(
              color: Colors.grey[250],
            ),
            onDismissed: (direction) {
              setState(() {
                widget.items.removeAt(index);
              });
            },
            key: UniqueKey(),
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
              return Stack(
                children: [
                  IgnorePointer(
                      child: Scaffold(backgroundColor: Colors.transparent)),
                  AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (nomeItemCont.text.isNotEmpty) {
                            setState(() {
                              widget.items.add(
                                  Item(done: false, title: nomeItemCont.text));
                              nomeItemCont.clear();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Item inserido com sucesso'),
                                ),
                              );
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content:
                                    Text('Não foi possível inserir o item'),
                              ),
                            );
                          }
                        },
                        child: Text('Add'),
                      )
                    ],
                    title: Text('Adicione um item'),
                    content: TextFormField(
                      validator: (value) {},
                      controller: nomeItemCont,
                      decoration: InputDecoration(labelText: 'Nome do item'),
                    ),
                  )
                ],
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
