import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_demo/app_screens/cart_screen.dart';
import 'package:practical_demo/app_screens/item_list.dart';
import 'package:practical_demo/bloc_helper/cart_items_bloc.dart';
import 'package:practical_demo/bloc_helper/item_list_bloc.dart';
import 'package:practical_demo/bloc_helper/item_price_bloc.dart';
import 'package:practical_demo/bloc_helper/item_quantity_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ItemListBloc()),
        BlocProvider(create: (context) => CartItemsBloc()),
        BlocProvider(create: (context) => ItemQuantityBloc()),
        BlocProvider(create: (context) => ItemPriceBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ItemList();
  }
}
