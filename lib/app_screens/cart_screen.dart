import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_demo/bloc_helper/cart_items_bloc.dart';
import 'package:practical_demo/models/item_model.dart';
import 'package:practical_demo/utilities/common_functions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class CartItems extends StatefulWidget {
  const CartItems({Key? key}) : super(key: key);

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {

  late Database cartDatabase;
  late CartItemsBloc cartItemsBloc;
  
  Future initDb() async {
    cartDatabase = await CommonFunctions().openDb();
    cartDatabase.query("cart").then((value) {
      List<ItemModel> x = value.map((e) => ItemModel.fromJson(e)).toList();
      cartItemsBloc.add(CartItemListEvent(cartItems: x));
    });
    return;
  }


  deleteItems(int id)
  async {
    await cartDatabase.delete("cart",where:'id = $id');
    cartDatabase.query("cart").then((value) {
      List<ItemModel> x = value.map((e) => ItemModel.fromJson(e)).toList();
      cartItemsBloc.add(CartItemListEvent(cartItems: x));
    });
  }

  Widget cartItemsList(ItemModel itemModel) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Image.network(itemModel.featuredImage! , errorBuilder: (ctx,_, __){
                  return Container();
                },) ),
            const SizedBox(width: 5,),
            Expanded( flex : 8 ,child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment : Alignment.topRight,
                    child: IconButton(onPressed: (){
                      deleteItems(itemModel.id!);
                    }, icon: Icon(Icons.delete)),
                  ),
                  Text(itemModel.title!),
                  SizedBox(height: 10,),
                  Table(
                    columnWidths: const {
                      8: FlexColumnWidth(1),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                          children:[
                            const TableCell(child: Text("Price")),
                            TableCell(child: Text(itemModel.price.toString())),
                          ]
                      ),
                      TableRow(
                        children:[
                          Container(height: 10,),
                          Container(height: 10,)
                        ]
                      ),
                      TableRow(
                          children:[
                            const TableCell(child: Text("quantity")),
                            TableCell(child: Text(itemModel.quantity.toString())),
                          ]
                      ),
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDb();
  }

  @override
  Widget build(BuildContext context) {
    cartItemsBloc = BlocProvider.of<CartItemsBloc>(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text("My cart"),
        centerTitle: true,
      ),
      body: BlocConsumer<CartItemsBloc, CartItemsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if(state is CartItemListState)
            {
              return state.cartItems!.isNotEmpty ? ListView.builder(itemCount : state.cartItems!.length , itemBuilder: (ctx, i) {
                return cartItemsList(state.cartItems!.elementAt(i));
              }) : Center(child: Text('Your cart is empty'),);
            }
         return Container();
        },
      ),
    ));
  }
}
