import 'dart:convert';

import 'package:flutter/foundation.dart';

class Restaurant {
  final String id;
  final String  name;
  final String  displayImageUrl;
  final String type;
  final Location location;
  final Address address;

  Restaurant({
    @required this.id,
    @required this.name,
    @required this.displayImageUrl,
    @required this.type,
    @required this.location,
    @required  this.address
  });

  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'displayImageUrl': displayImageUrl,
      'type': type,
      'location': location?.toMap(),
      'address': address?.toMap(),
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    print(map['location']);
    return Restaurant(
      id:map['id'],
      name:map['name'],
      displayImageUrl:map['displayImageUrl'],
      type:map['type'],
      location:Location.fromJson(json.encode(map['location'])),
      address:Address.fromJson(json.encode( map['address'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory Restaurant.fromJson(String source) => Restaurant.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, displayImageUrl: $displayImageUrl, type: $type, location: $location, address: $address)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Restaurant &&
      o.id == id &&
      o.name == name &&
      o.displayImageUrl == displayImageUrl &&
      o.type == type &&
      o.location == location &&
      o.address == address;
  }


}

class Location {
  final double longitude;
  final double latitude;

  Location({@required this.longitude, @required this.latitude});

  Map<String, dynamic> toMap() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Location(
      longitude: map['longitude'],
      latitude: map['latitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source));
}

class Address {
  final String street;
  final String city;
  final String district;
  final String state;
  final int pinCode;

  Address({

   @required this.street,
   @required this.city, 
   @required this.district, 
   @required this.state, 
   @required this.pinCode});

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'district': district,
      'state': state,
      'pinCode': pinCode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Address(
      street: map['street'],
      city: map['city'],
      district: map['district'],
      state: map['state'],
      pinCode: map['pinCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source));
}
