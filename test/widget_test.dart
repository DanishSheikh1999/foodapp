// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodapp/main.dart';
import 'package:foodapp/states_management/restaurant/restaurantCubit.dart';
import 'package:foodapp/states_management/restaurant/restaurantState.dart';
import '../lib/fakeRestauranApi.dart';
import 'package:matcher/matcher.dart' as matcher;
void main() {
  RestaurantCubit sut;
  FakeRestaurantApi api;
  setUp((){
    api = FakeRestaurantApi(10);
    sut = RestaurantCubit(api,defaultPageSize:5);
  });

  

  group('getAllRestaurants',(){
    test('returns first page with correct number of restaurants',() async {
        sut.getAllRestaurants(page: 1);
        await expectLater(sut,emits(matcher.TypeMatcher<PageLoaded>()));
        final state =sut.state as PageLoaded;
        expect(state.nextPage,2);
        expect(state.restaurants.length, 10);
    });
  });

  group('getRestaurants', (){
    test('returns restaurant when found',() async {
      sut.getRestaurant('1');
      await expectLater(sut,emits(matcher.TypeMatcher<RestaurantLoaded>()));
      final state = sut.state as RestaurantLoaded;
      expect(state.restaurant,isNotNull);
    });
     test('returns restaurant when found',() async {
      sut.getRestaurant("-1");
      await expectLater(sut,emits(matcher.TypeMatcher<ErrorState>()));
      final state = sut.state as ErrorState;
      print(state.message);
      expect(state.message,isNotNull);
    });
  });

   group('getRestaurantsBySearch', (){
    test('returns restaurant when found',() async {
      sut.search(1, "s");
      await expectLater(sut,emits(matcher.TypeMatcher<PageLoaded>()));
      final state = sut.state as PageLoaded;
      expect(state.restaurants,isNotNull);
    });

  
  });

}
