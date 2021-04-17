
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/pages/cart/CartPage.dart';
import 'package:foodapp/pages/menus/menu_adapter.dart';
import 'package:foodapp/pages/restaurant/search_page_result.dart';
import 'package:foodapp/states_management/cart/cartCubit.dart';
import 'package:foodapp/states_management/restaurant/restaurantCubit.dart';

abstract class IRestaurantPageAdapter{
  void search(BuildContext context,String query);
  void logout(BuildContext context);
  void cart(BuildContext context);
}

class RestaurantPageAdapter implements IRestaurantPageAdapter{
  final RestaurantCubit cubit;
  final CartCubit cartCubit;
  final IMenuAdapter menuAdapter;
  final Widget Function() onLogout;
  RestaurantPageAdapter(this.cubit, this.cartCubit,this.menuAdapter,this.onLogout);
  

  @override
  void search(BuildContext context, String query,) {
    Navigator.push(context, 
    MaterialPageRoute(builder:(_)=>SearchResultsPage(cubit,query,menuAdapter)));
  }
  @override
  void logout(BuildContext context){
     Navigator.pushAndRemoveUntil(context, 
    MaterialPageRoute(builder:(_)=>this.onLogout()),
    (Route<dynamic> route) =>false);
  }

  @override
  void cart(BuildContext context) {
    Navigator.push(context,MaterialPageRoute(builder:(_)=>CartPage(cartCubit)));
  }
  
} 