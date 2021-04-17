import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:restaurant/restaurant.dart';

class CartItems {
  final MenuItem menuItems;
  final int quantity;
  CartItems({
    @required this.menuItems,
    @required this.quantity,
  });


  


  factory CartItems.fromMap(Map<String, dynamic> map) {
    return CartItems(
      menuItems: MenuItem.fromMap(map['menuItem']),
      quantity: map['quantity'],
    );
  }

  factory CartItems.fromJson(String source) => CartItems.fromMap(json.decode(source));

  @override
  String toString() => 'CartItems(menuItems: $menuItems, quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CartItems &&
      other.menuItems == menuItems &&
      other.quantity == quantity;
  }

  @override
  int get hashCode => menuItems.hashCode ^ quantity.hashCode;
}
