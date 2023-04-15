import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:practical_demo/models/item_model.dart';

part 'cart_items_event.dart';
part 'cart_items_state.dart';

class CartItemsBloc extends Bloc<CartItemsEvent, CartItemsState> {
  CartItemsBloc() : super(CartItemsInitial()) {
    on<CartItemsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<CartItemListEvent>((event, emit)
    {
      emit(CartItemListState(cartItems: event.cartItems));
    });
  }
}
