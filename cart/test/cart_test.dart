
import 'package:common/infra/IhttpClient_contract.dart';
import 'package:common/infra/MHttpClient.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cart/cart.dart';
import 'helpers/sercure_client.dart';
import 'package:http/http.dart' as http;
void main() {
  CartApi sut;
  IHttpClient client;
  String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjA3NmMxNWE5ZGQwNzY5NWQ4ZjRkMjkzIiwiaWF0IjoxNjE4NTEzNDA3LCJleHAiOjE2MTkxMTgyMDcsImlzcyI6ImNvbS5mb29kYXBwIn0.Xx4gonaPIGKkM47YAXzsmNRfg6AElDT7NeUwE_Uya5w";
  setUp((){
    String baseUrl = "http://localhost:3000";
    client = new SecureClient(MHttpClient(http.Client()), token);
    sut  = CartApi(client, baseUrl);
  });

  group("get Cart", (){
    test("returns the list of menuItems",() async{
      dynamic result =  await sut.find();
      expect(result,isNotEmpty);
      print(result[0].menuItems.toString());
    });
  });
}
