import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //init state
  @override
  void initState() {
    load();
    super.initState();
  }

  //variables
  TextEditingController nomeItemCont = TextEditingController();
  var items = <Item>[];

  //methods
  Future load() async {
    var prefs = await SharedPreferences.getInstance();

    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((e) => Item.fromJson(e)).toList();
      setState(() {
        items = result;
      });
    }
  }

  Future save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(items));
  }

  //widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return itemWidget(index, item);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Stack(
                children: [
                  const IgnorePointer(
                      child: Scaffold(backgroundColor: Colors.transparent)),
                  AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (nomeItemCont.text.isNotEmpty) {
                            setState(() {
                              items.add(
                                  Item(done: false, title: nomeItemCont.text));
                              nomeItemCont.clear();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Item inserido com sucesso'),
                                ),
                              );
                            });
                            save();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content:
                                    Text('Não foi possível inserir o item'),
                              ),
                            );
                          }
                        },
                        child: const Text('Add'),
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

  Dismissible itemWidget(int index, Item item) {
    return Dismissible(
      background: Container(
        color: Colors.grey[250],
      ),
      onDismissed: (direction) {
        setState(() {
          items.removeAt(index);
        });
        save();
      },
      key: UniqueKey(),
      child: CheckboxListTile(
        title: Text(item.title.toString()),
        value: item.done,
        onChanged: (value) {
          save();
          setState(() {
            item.done = value;
          });
        },
        key: Key(item.title.toString()),
      ),
    );
  }
}
