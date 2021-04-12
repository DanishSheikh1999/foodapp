
import 'package:common/infra/MHttpClient.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/src/api/restaurant_api.dart';

import '../restaurant_test.dart';

void main(){
  RestaurantApi sut;
  MHttpClient client;
  String baseUrl = "http://localhost:3000";
  setUp((){
    
    client = MHttpClient( new http.Client());
    sut = RestaurantApi(client,baseUrl);
  });

  group("getAllRestaurants",(){
    test("should return status 200",() async{
      
    });

  });

}