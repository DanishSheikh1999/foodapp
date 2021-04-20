import 'package:cart/cart.dart';
import 'package:cubit/cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:foodapp/states_management/cart/cartstate.dart';
import 'package:http/http.dart';
import 'package:restaurant/restaurant.dart';
import 'package:geolocator/geolocator.dart';

class CartCubit extends Cubit<CartState> {
  final ICartApi _api;
// final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

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
  cancelOrders() async{
    _startLoading();
    final response = await _api.cancelOrder();
    print(response);
    emit(OrderCancelState(response));
  }
  placeOrder({Location location}) async {
      _startLoading();
      var _currentPosition = _getCurrentLocation();
      
      final response = await _api.placeOrder(location:Location(longitude: _currentPosition.longitude, latitude: _currentPosition.latitude));
      response ==null?_showError("Unable to place order"):emit(OrderPlaceSuccess());
  }
  void _startLoading() {
    emit(Loading());
  }

  _showError(String s) {
    emit(ErrorState(s));
  }

  _getCurrentLocation() {
  // geolocator
  //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //     .then((Position position) {
  //         return position;
  // }).catchError((e) {
  //   emit(ErrorState("Please check your internet connection"));
  // });
  return Location(latitude: 16,longitude:45);
  }
}
