import 'package:restaurant/restaurant.dart';

import '../domain/Cart.dart';
abstract class ICartApi{
    Future<List<CartItems>>find();
    Future<String> add(String menuItemId,int quantity);
    Future<String> placeOrder({Location location});
    Future<List<CartItems>> findOrder();
    Future<String> cancelOrder();
}