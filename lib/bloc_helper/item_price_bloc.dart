import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'item_price_event.dart';
part 'item_price_state.dart';

class ItemPriceBloc extends Bloc<ItemPriceEvent, ItemPriceState> {
  ItemPriceBloc() : super(ItemPriceInitial()) {
    on<ItemPriceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TotalPriceSetEvent>((event, emit){
      emit(TotalPriceState(price: event.price));
    });
  }
}
