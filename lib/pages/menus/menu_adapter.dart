import 'package:flutter/material.dart';
import 'package:foodapp/pages/menus/menu_display.dart';
import 'package:foodapp/states_management/restaurant/restaurantCubit.dart';
import 'package:restaurant/restaurant.dart';

abstract class IMenuAdapter{

  void find_menu(BuildContext context,Restaurant restaurant);
}

class MenuAdapter implements IMenuAdapter{
  final RestaurantCubit restaurantCubit;

  MenuAdapter(this.restaurantCubit);

  @override
  void find_menu(BuildContext context,Restaurant restaurant) {
     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>DisplayMenus(restaurantCubit:restaurantCubit,restaurant:restaurant)));
              
  }

}