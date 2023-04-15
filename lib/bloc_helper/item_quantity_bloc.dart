import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:practical_demo/bloc_helper/item_list_bloc.dart';

part 'item_quantity_event.dart';
part 'item_quantity_state.dart';

class ItemQuantityBloc extends Bloc<ItemQuantityEvent, ItemQuantityState> {
  ItemQuantityBloc() : super(ItemQuantityInitial()) {
    on<ItemQuantityEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<NoOfItemsEvent>((event, emit){
      emit(NoOfItemState(quantity: event.quantity));
    });
  }
}
