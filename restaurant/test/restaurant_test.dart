import 'dart:convert';

import 'package:common/infra/IhttpClient_contract.dart';
import 'package:common/infra/MHttpClient.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:restaurant/restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/src/api/restaurant_api.dart';
import 'package:restaurant/src/domain/restaurant.dart';
class HttpClient extends Mock implements MHttpClient {}
void main() {
 RestaurantApi sut;
 HttpClient client;
 setUp((){
   String baseUrl = "baseUrl";
   client = HttpClient();
   sut = RestaurantApi(client, baseUrl);
 });
 group("getAllRestaurants", (){
test("returns an empty list when no restaurants are found",() async {
when(client.get(any)).thenAnswer((_) async=> HttpResult(jsonEncode({
    "metadata": {"page": 1, "limit": 2},"restaurants":[]}),HttpStatus.Success));

final  result = await sut.getAllRestaurants(page:1,pageSize: 20);
expect(result.restaurants,[] );
});

test("returns all restaurants",() async {
when(client.get(any)).thenAnswer((_) async=> HttpResult(jsonEncode(_restaurantsJson()),HttpStatus.Success));

final  result = await sut.getAllRestaurants(page:1,pageSize: 20);

expect(result.restaurants, isNotEmpty);
});

test("returns menu",() async {
when(client.get(any)).thenAnswer((_) async=> HttpResult(jsonEncode({"menu":_restaurantMenuJson()}),HttpStatus.Success));

final  result = await sut.getRestaurantMenu(restaurant_id:"peek");
print(result);

expect(result, isNotEmpty);
});
 });
}

_restaurantsJson() {
  return {
    "metadata": {"page": 1, "limit": 2},
    "restaurants": [
      {
        "id": "12345",
        "name": "Restuarant Name",
        "type": "Fast Food",
        "image_url": "restaurant.jpg",
        "location": {"longitude": 345.33, "latitude": 345.23},
        "address": {
          "street": "Road 1",
          "city": "City",
          "parish": "Parish",
          "zone": "Zone"
        }
      },
      {
        "id": "12666",
        "name": "Restuarant Name",
        "type": "Fast Food",
        "imageUrl": "restaurant.jpg",
        "location": {"longitude": 345.33, "latitude": 345.23},
        "address": {
          "street": "Road 1",
          "city": "City",
          "parish": "Parish",
          "zone": "Zone"
        }
      }
    ]
  };
}

_restaurantMenuJson() {
  return [
    {
      "id": "12345",
      "name": "Lunch",
      "description": "a fun menu",
      "image_url": "menu.jpg",
      "items": [
        {
          "name": "nuff food",
          "description": "awasome!!",
          "image_urls": ["url1", "url2"],
          "unit_price": 12.99
        },
        {
          "name": "nuff food",
          "description": "awasome!!",
          "image_urls": ["url1", "url2"],
          "unit_price": 12.99
        }
      ]
    }
  ];
}
