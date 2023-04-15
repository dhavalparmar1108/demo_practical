part of 'item_list_bloc.dart';

@immutable
abstract class ItemListState {}

class ItemListInitial extends ItemListState {}

class ListOfItemsState extends ItemListState
{
   List<ItemModel>? itemList;

   ListOfItemsState({required this.itemList});
}