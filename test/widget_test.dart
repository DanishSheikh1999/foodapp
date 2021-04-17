// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cart/cart.dart';
import 'package:common/infra/MHttpClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodapp/main.dart';
import 'package:foodapp/states_management/cart/cartCubit.dart';
import 'package:foodapp/states_management/cart/cartstate.dart';

import 'package:matcher/matcher.dart' as matcher;
import 'package:http/http.dart' as http;

import 'helpers/sercure_client.dart';

void main() {
  CartCubit sut;
  CartApi api;
  setUp((){
    String baseUrl =  "http://localhost:3000";
    String token =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjA3NmMxNWE5ZGQwNzY5NWQ4ZjRkMjkzIiwiaWF0IjoxNjE4NTEzNDA3LCJleHAiOjE2MTkxMTgyMDcsImlzcyI6ImNvbS5mb29kYXBwIn0.Xx4gonaPIGKkM47YAXzsmNRfg6AElDT7NeUwE_Uya5w";
    SecureClient httpClient = SecureClient(MHttpClient(http.Client()), token);
    api = CartApi(httpClient, baseUrl);
    sut = CartCubit(api);
  });

  

  group('findItem',(){
    test('returns first page with correct number of restaurants',() async {
        await sut.getAllCarts();
        await expectLater(sut,emits(matcher.TypeMatcher<CartLoaded>()));
        final state =sut.state as CartLoaded;
       
        print(state.cart.length);
    });
  });
  group('AddItem',(){
    String menuItem = "606df27aae5aad68e3931cd4";
    int quantity = 10;
    test('new menuItems',() async {
        await sut.addCarts(menuItem: menuItem, quantity: quantity);
        await expectLater(sut,emits(matcher.TypeMatcher<PushCartSuccess>()));
      

        
    });
  });


}
