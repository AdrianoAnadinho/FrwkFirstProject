import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/list_cubit_cubit.dart';
import '../models/item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ListCubit _cubit;
  TextEditingController nomeItemCont = TextEditingController();

  // var items = <Item>[];

  @override
  void initState() {
    super.initState();

    _cubit = ListCubit();
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocBuilder<ListCubit, List>(
        bloc: _cubit,
        builder: (context, state) {
          return ListView.builder(
            itemCount: _cubit.items.length,
            itemBuilder: (context, index) {
              final item = _cubit.items[index];

              // print('itens: ${_cubit.items}');

              return Dismissible(
                background: Container(
                  color: Colors.grey[250],
                ),
                onDismissed: (direction) {
                  _cubit.remove(index);
                  // setState(() {
                  //   items.removeAt(index);
                  // });
                  _cubit.save();
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
                            _cubit.add(
                                Item(done: false, title: nomeItemCont.text));

                            setState(() {
                              // items.add(
                              //     Item(done: false, title: nomeItemCont.text));
                              nomeItemCont.clear();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Item inserido com sucesso'),
                                ),
                              );
                            });
                            _cubit.save();
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
