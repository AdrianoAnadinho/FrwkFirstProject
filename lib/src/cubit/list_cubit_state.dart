part of 'list_cubit_cubit.dart';

@immutable
abstract class ListCubitState extends Equatable {}

class ListCubitInitialState extends ListCubitState {
  @override
  List<Item> get props => [];
}

class ListCubitAddingState extends ListCubitState {
  @override
  List<Item> get props => [];
}

class ListCubitLoadedState extends ListCubitState {
  ListCubitLoadedState(items);

  @override
  List<Item> get props => [];
}

class ListCubitErrorState extends ListCubitState {
  @override
  List<Item> get props => [];
}
