import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_demo/api_helper/apis.dart';
import 'package:practical_demo/app_screens/cart_screen.dart';
import 'package:practical_demo/bloc_helper/item_list_bloc.dart';
import 'package:practical_demo/bloc_helper/item_quantity_bloc.dart';
import 'package:practical_demo/models/error_model.dart';
import 'package:practical_demo/models/item_list_response.dart';
import 'package:practical_demo/models/item_model.dart';
import 'package:practical_demo/utilities/common_functions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {

  late ItemListBloc itemListBloc;
  Database? cartDatabase;
  late ItemQuantityBloc itemQuantityBloc;
  ScrollController scrollController = ScrollController();

  showQuantityDialog(ItemModel itemModel)
  async {
    int n = await findItemWithSameID(itemModel.id!);
    if(n != 0)
      {
        return CommonFunctions.showFlutterToast("Can't insert duplicate items!");
      }
    return showDialog(context: context, builder: (context){
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10,),
            const Text("Select quantity"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              IconButton(onPressed: (){
                itemQuantityBloc.add(NoOfItemsEvent(quantity: (itemQuantityBloc.state as NoOfItemState).quantity + 1));
              }, icon: const Icon(Icons.add)),
              BlocConsumer<ItemQuantityBloc , ItemQuantityState>(builder: (context , state){
                if(state is NoOfItemState)
                  {
                    return Text(state.quantity.toString());
                  }
                return const Text("1");
              }, listener: (context , state){}),
              IconButton(onPressed: (){
                if((itemQuantityBloc.state as NoOfItemState).quantity - 1 >= 1 ) {
                  itemQuantityBloc.add(NoOfItemsEvent(quantity: (itemQuantityBloc.state as NoOfItemState).quantity - 1));
                }
              }, icon: const Icon(Icons.remove))
            ],),
            MaterialButton(onPressed: (){
              Navigator.pop(context);
              addToCart(itemModel);
            } , child: const Text("Add Item"),)
          ],
        ),
      );
    });
  }

  addToCart(ItemModel itemModel)
  async {
    itemModel.quantity = (itemQuantityBloc.state as NoOfItemState).quantity;
    await cartDatabase!.insert("cart", itemModel.toJson() , conflictAlgorithm: ConflictAlgorithm.replace);
    CommonFunctions.showFlutterToast("Successfully Added");
    (itemQuantityBloc.state as NoOfItemState).quantity = 1;
  }

  findItemWithSameID(int id) async
  {
    cartDatabase ??= await CommonFunctions().initDb();
    print("-- ${cartDatabase?.isOpen}");
    List<Map<String, dynamic>> n = await cartDatabase!.query("cart" , where: "id=$id" , columns: ["id"]);
    return n.length;
  }
  fetchItems() async
  {

    if(itemListBloc.state is ItemListInitial)
       {
         itemListBloc.add(ListOfItemsEvent(itemList: []));
         //(itemListBloc.state as ListOfItemsState).itemList = [];
       }
    Map<String,dynamic> data = {
      "page": 1,
      "perPage": 5
    };
    Response response = await Apis().fetchItems(data);

    ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(response.data));

    if(errorModel.error == null)
      {
        ItemListResponseModel itemListResponseModel = ItemListResponseModel.fromJson(jsonDecode(response.data));
        (itemListBloc.state as ListOfItemsState ).itemList?.addAll(itemListResponseModel.data!.map((e) => ItemModel.fromJson(e.toJson())).toList());
        itemListBloc.add(ListOfItemsEvent(itemList:(itemListBloc.state as ListOfItemsState ).itemList ));
      }
    else
      {
        CommonFunctions.showFlutterToast(errorModel.message??"");
      }
  }

  Widget Item(ListOfItemsState state,int index)
  {
    return  Material(
      elevation: 5, borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              child: Image.network(state.itemList!.elementAt(index).featuredImage!),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: Text(state.itemList!.elementAt(index).title??"" , overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  InkWell(
                    onTap: (){
                      showQuantityDialog(state.itemList!.elementAt(index));
                    },
                    child: const Icon(Icons.add_shopping_cart),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { 
      itemListBloc = BlocProvider.of<ItemListBloc>(context);
      itemListBloc.add(ListOfItemsEvent(itemList: []));
      itemQuantityBloc = BlocProvider.of<ItemQuantityBloc>(context);
      itemQuantityBloc.add(NoOfItemsEvent(quantity: 1));

      /// This is used for Pagination.
      scrollController.addListener(() {
        if(scrollController.position.pixels == scrollController.position.maxScrollExtent)
          {
            fetchItems();
          }

      });
      fetchItems();
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar:  AppBar(
        title: const Text("Shopping Mall"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CartItems()));
          }, icon: const Icon(Icons.shopping_cart))
        ],
        centerTitle: true,
      ),
      body: BlocConsumer<ItemListBloc, ItemListState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if(state is ListOfItemsState)
            {
              return Container(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                    controller: scrollController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10.0,
                ),
                    itemCount: state.itemList?.length,
                    itemBuilder: (ctx , index){
                      return Item(state, index);
                    }),
              );
            }
         return Container();
        },
      ),
    ));
  }
}
