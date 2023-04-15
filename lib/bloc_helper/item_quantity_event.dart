part of 'item_quantity_bloc.dart';

@immutable
abstract class ItemQuantityEvent {}

class NoOfItemsEvent extends ItemQuantityEvent
{
  int quantity = 0 ;

  NoOfItemsEvent({required this.quantity});
}