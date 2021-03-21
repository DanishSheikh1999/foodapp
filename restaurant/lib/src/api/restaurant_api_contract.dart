import 'dart:async';

import 'package:flutter/foundation.dart';
import '../api/page.dart';
import '../domain/menu.dart';
import '../domain/restaurant.dart';

abstract class IRestaurantApi{
  Future<Page> getAllRestaurants({@required int page,@required int pageSize});
  Future<Page> getRestaurantswithLocation({
    @required int page,
    @required int pageSize,
    @required Location location});
  // ignore: missing_return
  Future<Page> fingRestaurant({@required int page,
  @required int pageSize,@required String searchTerm});

  Future<Restaurant> getRestaurant({@required String id});
  Future<List<Menu>> getRestaurantMenu({@required String restaurant_id});

}