part of 'item_quantity_bloc.dart';

@immutable
abstract class ItemQuantityEvent {}

class NoOfItemsEvent extends ItemQuantityEvent
{
  int quantity = 1 ;

  NoOfItemsEvent({required this.quantity});
}