part of 'item_list_bloc.dart';

@immutable
abstract class ItemListEvent {}

class ListOfItemsEvent extends ItemListEvent
{
    List<ItemModel>? itemList;
    ListOfItemsEvent({required this.itemList});
}