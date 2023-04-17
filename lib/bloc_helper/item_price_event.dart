part of 'item_price_bloc.dart';

@immutable
abstract class ItemPriceEvent {}

class TotalPriceSetEvent extends ItemPriceEvent
{
  double price;
  TotalPriceSetEvent({required this.price});
}