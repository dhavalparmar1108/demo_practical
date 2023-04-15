part of 'cart_items_bloc.dart';

@immutable
abstract class CartItemsEvent {}

class CartItemListEvent extends CartItemsEvent
{
  List<ItemModel>? cartItems;
  CartItemListEvent({this.cartItems});
}