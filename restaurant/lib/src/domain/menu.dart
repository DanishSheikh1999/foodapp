import 'dart:convert';

import 'package:flutter/foundation.dart';

class Menu {
   String id;
   String name;
   String description;
   String displayImageUrl;
   List<MenuItem> items;
  Menu({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.displayImageUrl,
    @required this.items,
  });


  factory Menu.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Menu(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      displayImageUrl: map['displayImageUrl'],
      items:map['items']!=null? List<MenuItem>.from(map['items']?.map((x) => MenuItem.fromJson(jsonEncode(x)))):null,
    );
  }

  factory Menu.fromJson(String source) => Menu.fromMap(json.decode(source));
   }
 
class MenuItem {
      String id;
      String name;
      String description;
      List<String> imageUrls;
      int unitPrice;
  MenuItem({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageUrls,
    @required this.unitPrice,
  });
      

 

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MenuItem(
      id:map['id'],
      name: map['name'],
      description: map['description'],
      imageUrls: map['imageUrls'].cast<String>(),
      unitPrice: map['unitPrice'],
    );
  }

  factory MenuItem.fromJson(String source) => MenuItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MenuItem(id:$id ,name: $name, description: $description, imageUrls: $imageUrls, unitPrice: $unitPrice)';
  }
}
