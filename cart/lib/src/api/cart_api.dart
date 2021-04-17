import 'dart:convert';

import 'package:cart/src/domain/Cart.dart';
import 'package:common/infra/IhttpClient_contract.dart';
import 'package:http/http.dart';
import 'package:restaurant/src/domain/restaurant.dart';

import '../api/cart_api_contract.dart';
class CartApi implements ICartApi{
  final IHttpClient httpClient;
  final String baseUrl;

  CartApi(this.httpClient, this.baseUrl);
  @override
  Future<String> add(String menuItemId, int quantity) async {
      var item ={
    "menuItemId":menuItemId,
    "quantity":quantity
};
      print(jsonEncode(item));
      final endpoint = baseUrl + "/cart/add";
      final response = await httpClient.post(endpoint, jsonEncode(item));
      if(response.status==HttpStatus.Success)
        return response.data;
      return null;
    }
  
    @override
    Future<List<CartItems>> find() async {
      final  endpoint = baseUrl + "/cart/find";
      final response = await httpClient.get(endpoint);
      return _parseItems(response);
        }
      
        List<CartItems> _parseItems(HttpResult response) {
            if(response.status!=HttpStatus.Success)
              return null;
            final json = jsonDecode(response.data)["cart"] as List;
            return json.map<CartItems>((e)=>CartItems.fromJson(jsonEncode(e))).toList();

        }

  @override
  Future<String> placeOrder({Location location}) async {
    final endpoint = baseUrl + "/cart/placeOrder";
    String body  = "";
    if(location != null)
      body  = jsonEncode(location);
    final response = await httpClient.post(endpoint, body);
    if(response.status==HttpStatus.Success)
        return response.data;
      return null;
  }

  @override
  Future<List<CartItems>> findOrder() async {
     final  endpoint = baseUrl + "/cart/findOrder";
      final response = await httpClient.get(endpoint);
      return _parseItems(response);
        }
      
        
}