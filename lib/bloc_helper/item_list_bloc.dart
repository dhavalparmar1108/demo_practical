import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:practical_demo/models/item_model.dart';

part 'item_list_event.dart';
part 'item_list_state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc() : super(ItemListInitial()) {
    on<ItemListEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ListOfItemsEvent>((event,emit){
      emit(ListOfItemsState(itemList: event.itemList));
    });
  }
}
