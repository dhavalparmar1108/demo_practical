part of 'cart_items_bloc.dart';

@immutable
abstract class CartItemsState {}

class CartItemsInitial extends CartItemsState {}

class CartItemListState extends CartItemsState
{
  List<ItemModel>? cartItems;
  CartItemListState({this.cartItems});
}