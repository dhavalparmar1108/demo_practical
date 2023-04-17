import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_demo/bloc_helper/cart_items_bloc.dart';
import 'package:practical_demo/bloc_helper/item_price_bloc.dart';
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
  late ItemPriceBloc itemPriceBloc;
  late double totalPrice = 0.0;

  calculatePrice() {
    totalPrice = 0;
    for (int i = 0; i <
        (cartItemsBloc.state as CartItemListState).cartItems!.length; i++) {
      totalPrice +=
          (cartItemsBloc.state as CartItemListState).cartItems![i].quantity! *
              (cartItemsBloc.state as CartItemListState).cartItems![i].price!;
    }
    print("total is ${totalPrice}");
    itemPriceBloc.add(TotalPriceSetEvent(price: totalPrice));
  }

  Future initDb() async {
    cartDatabase = await CommonFunctions().openDb();
    cartDatabase.query("cart").then((value) async {
      List<ItemModel> x = value.map((e) => ItemModel.fromJson(e)).toList();
      cartItemsBloc.add(CartItemListEvent(cartItems: x));
      calculatePrice();
    });
    return;
  }


  deleteItems(int id) async {
    await cartDatabase.delete("cart", where: 'id = $id');
    cartDatabase.query("cart").then((value) async {
      List<ItemModel> x = value.map((e) => ItemModel.fromJson(e)).toList();
      cartItemsBloc.add(CartItemListEvent(cartItems: x));
      calculatePrice();
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
                child: Image.network(
                  itemModel.featuredImage!, errorBuilder: (ctx, _, __) {
                  return Container();
                },)),
            const SizedBox(width: 5,),
            Expanded(flex: 8, child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(onPressed: () {
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
                          children: [
                            const TableCell(child: Text("Price")),
                            TableCell(child: Text(itemModel.price.toString())),
                          ]
                      ),
                      TableRow(
                          children: [
                            Container(height: 10,),
                            Container(height: 10,)
                          ]
                      ),
                      TableRow(
                          children: [
                            const TableCell(child: Text("quantity")),
                            TableCell(child: Text(
                                itemModel.quantity.toString())),
                          ]
                      ),
                    ],
                  ),
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      cartItemsBloc.add(CartItemListEvent(cartItems: []));
      itemPriceBloc.add(TotalPriceSetEvent(price: 0.0));
      initDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    cartItemsBloc = BlocProvider.of<CartItemsBloc>(context);
    itemPriceBloc = BlocProvider.of<ItemPriceBloc>(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text("My cart"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          BlocConsumer<CartItemsBloc, CartItemsState>(
            listener: (context, state) {
              if(state is CartItemListState)
                {
                  calculatePrice();
                }
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is CartItemListState) {
                return state.cartItems!.isNotEmpty ? Column(
                  children: [
                    Expanded(
                      flex: 9,
                      child: ListView.builder(
                          itemCount: state.cartItems!.length,
                          itemBuilder: (ctx, i) {
                            return cartItemsList(state.cartItems!.elementAt(i));
                          }),
                    ),

                  ],
                ) : Center(child: Text('Your cart is empty'),);
              }
              return Container();
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: BlocConsumer<ItemPriceBloc, ItemPriceState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
                    color: Colors.blue,
                    child: Text("Total  $totalPrice", style: TextStyle(color: Colors.white , fontSize: 17),));
              },
            ),
          )
        ],
      ),
    ));
  }
}
