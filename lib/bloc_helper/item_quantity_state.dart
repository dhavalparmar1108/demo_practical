part of 'item_quantity_bloc.dart';

@immutable
abstract class ItemQuantityState {}

class ItemQuantityInitial extends ItemQuantityState {}

class NoOfItemState extends ItemQuantityState
{
  int quantity = 0;
  NoOfItemState({required this.quantity});
}