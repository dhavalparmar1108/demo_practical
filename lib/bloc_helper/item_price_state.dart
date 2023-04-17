part of 'item_price_bloc.dart';

@immutable
abstract class ItemPriceState {}

class ItemPriceInitial extends ItemPriceState {}

class TotalPriceState extends ItemPriceState
{
  double price;
  TotalPriceState({required this.price});
}