import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';

part 'list_cubit_state.dart';

class ListCubit extends Cubit<List<Item>> {
  ListCubit() : super([]);

  List<Item> items = [];

  void add(Item item) async {
    try {
      items.add(item);
      emit(items);
    } catch (e) {
      // emit(ListCubitErrorState());
    }
  }

  void remove(int index) async {
    try {
      items.removeAt(index);
      emit(items);
    } catch (e) {
      // emit(ListCubitErrorState());
    }
  }

  Future save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(items));
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();

    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((e) => Item.fromJson(e)).toList();

      items = result;
    }

    emit(items);
  }
}
