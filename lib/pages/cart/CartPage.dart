import 'package:cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/states_management/cart/cartCubit.dart';

import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:foodapp/states_management/cart/cartstate.dart';
import 'package:transparent_image/transparent_image.dart';

class CartPage extends StatefulWidget {
  final CartCubit cubit;

  const CartPage(this.cubit);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItems> items = [];
  List<CartItems> orders = [];
  @override
  void initState() {
    super.initState();
    widget.cubit.getAllCarts();
    widget.cubit.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CubitConsumer(
          cubit: widget.cubit,
          builder: (context, state) {
            if (state is CartLoaded) {
              items.addAll(state.cart);
              print(items[0].quantity);
            }
            if (state is OrdersLoaded) {
              orders.addAll(state.orders);
            }
            return _buildCart();
          },
          listener: (context, state) {
            // if (state is Loading)
            //   return Center(child: CircularProgressIndicator());
            if (state is ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.grey[400],
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Theme.of(context).accentColor))),
              );
            }
            if (state is OrderPlaceSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.grey[400],
                    content: Text("Order Successfully placed",
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Theme.of(context).accentColor))),
              );
            }
          }),
    );
  }

  Widget _buildCart() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Cart",
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Theme.of(context).accentColor),
          ),
          items.isEmpty ? Text("Cart is Empty") : Container(),
          ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      elevation: 1,
                      shadowColor: Theme.of(context).accentColor,
                      child: Row(children: [
                        Container(
                          width: 400,
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index].menuItems.name,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        color: Theme.of(context).accentColor),
                              ),
                              SizedBox(height: 12),
                              Text(
                                  items[index].quantity.toString() +
                                      " x " +
                                      items[index]
                                          .menuItems
                                          .unitPrice
                                          .toString(),
                                  softWrap: true,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(color: Colors.black54)),
                              SizedBox(height: 12),
                            ],
                          ),
                        )
                      ])),
                );
              }),
          items.isEmpty
              ? Container()
              : ElevatedButton(
                  onPressed: () async {
                    await widget.cubit.placeOrder();
                  },
                  child: Text("Place Order"),
                ),
                Text(
            "Orders",
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Theme.of(context).accentColor),
          ),
          orders.isEmpty ? Text("There are no orders") : Container(),
          ListView.builder(
              shrinkWrap: true,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      elevation: 1,
                      shadowColor: Theme.of(context).accentColor,
                      child: Row(children: [
                        Container(
                          width: 400,
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orders[index].menuItems.name,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        color: Theme.of(context).accentColor),
                              ),
                              SizedBox(height: 12),
                              Text(
                                  orders[index].quantity.toString() +
                                      " x " +
                                      orders[index]
                                          .menuItems
                                          .unitPrice
                                          .toString() +" = " +(orders[index].quantity*orders[index].menuItems.unitPrice).toString(),
                                  softWrap: true,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(color: Colors.black54)),
                              SizedBox(height: 12),
                            ],
                          ),
                        )
                      ])),
                );
              }),
        ],
      );
}
