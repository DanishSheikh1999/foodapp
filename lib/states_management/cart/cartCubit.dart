import 'package:cart/cart.dart';
import 'package:cubit/cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:foodapp/states_management/cart/cartstate.dart';
import 'package:http/http.dart';
import 'package:restaurant/restaurant.dart';

class CartCubit extends Cubit<CartState> {
  final ICartApi _api;

  CartCubit(this._api) : super(Initial());

  getAllCarts() async {
    _startLoading();
    final cartResult = await _api.find();
    cartResult == null || cartResult.isEmpty
        ? _showError("No Carts found")
        : emit(CartLoaded(cartResult));
  }

  addCarts({@required String menuItem, @required int quantity}) async {
    _startLoading();
    final response = await _api.add(menuItem, quantity);
    response == null ? _showError("Server") : emit(PushCartSuccess());
  }

  getOrders() async{
    _startLoading();
    final orderResult = await _api.findOrder();
    orderResult == null || orderResult.isEmpty
        ? _showError("No orders found")
        : emit(OrdersLoaded(orderResult));
  }

  placeOrder({Location location}) async {
      _startLoading();
      final response = await _api.placeOrder(location:location);
      response ==null?_showError("Unable to place order"):emit(OrderPlaceSuccess());
  }
  void _startLoading() {
    emit(Loading());
  }

  _showError(String s) {
    emit(ErrorState(s));
  }
}
