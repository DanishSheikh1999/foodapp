import 'package:cubit/cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:foodapp/states_management/restaurant/restaurantState.dart';
import 'package:restaurant/restaurant.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final IRestaurantApi _api;
  final int _pageSize;

  RestaurantCubit(this._api, {int defaultPageSize = 30})
      : _pageSize = defaultPageSize,
        super(Initial());

  getAllRestaurants({@required int page}) async {
    _startLoading();
    final pageResult =
        await _api.getAllRestaurants(page: page, pageSize: _pageSize);
    pageResult == null || pageResult.restaurants.isEmpty
        ? _showError("no restaurants found")
        : _setPageLoaded(pageResult);
  }

  getRestaurantsByLocation(int page, Location location) async {
    _startLoading();
    final pageResult = await _api.getRestaurantswithLocation(
        page: page, pageSize: _pageSize, location: location);

    pageResult == null || pageResult.restaurants.isEmpty
        ? _showError("no restaurants found")
        : _setPageLoaded(pageResult);
  }

  search(int page, String query) async {
    _startLoading();
    final searchResults = await _api.fingRestaurant(
        page: page, pageSize: _pageSize, searchTerm: query);

    searchResults == null || searchResults.restaurants.isEmpty
        ? _showError("no restaurants found")
        : _setPageLoaded(searchResults);
  }

  getRestaurant(String id) async {
    _startLoading();
    final restaurant = await _api.getRestaurant(id: id);

    restaurant == null
        ? emit(ErrorState("restaurant not found"))
        : emit(RestaurantLoaded(restaurant));
  }

  getRestaurantMenu(String restaurantId) async {
    _startLoading();
    final menu = await _api.getRestaurantMenu(restaurant_id: restaurantId);

    menu == null
        ? emit(ErrorState("no menu found for this restaurant"))
        : emit(MenuLoaded(menu));
  }

  void _startLoading() {
    emit(Loading());
  }

  _showError(String s) {
    emit(ErrorState(s));
  }

  _setPageLoaded(Page pageResult) {
    emit(PageLoaded(pageResult));
  }
}
