import 'package:faker/faker.dart' as f;
import 'package:restaurant/restaurant.dart';

class FakeRestaurantApi implements IRestaurantApi {
  List<Restaurant> restaurants;
  List<Menu> all_menus=[];
  FakeRestaurantApi(int n) {
    print(n);
    f.Faker faker = f.Faker();
    restaurants = List.generate(
        n,
        (index) => Restaurant(
            id: index.toString(),
            name: faker.company.name(),
            displayImageUrl: faker.internet.httpUrl(),
            type: faker.food.cuisine(),
            location: Location(
                longitude: faker.randomGenerator.integer(10).toDouble(),
                latitude: faker.randomGenerator.integer(10).toDouble()),
            address: Address(
                street: faker.address.streetName(),
                city: faker.address.city(),
                district: faker.address.streetAddress(),
                state: faker.address.country(),
                pinCode: faker.randomGenerator.integer(999999, min: 100000))));

    restaurants.forEach((restaurant) {
var menus = List.generate(
        faker.randomGenerator.integer(6,min: 2),
        (index) => Menu(
            id: restaurant.id,
            name: faker.food.restaurant(),
            description: faker.lorem.sentences(2).join(),
            displayImageUrl: faker.internet.httpsUrl(),
            items: List.generate(
                5,
                (index) => MenuItem(
                    name: faker.food.dish(),
                    description: faker.lorem.sentence(),
                    imageUrls: [faker.internet.httpsUrl()],
                    unitPrice: faker.randomGenerator
                        .integer(600, min: 20)
                        .toDouble()))));
    all_menus.addAll(menus);
     });
  
  }
  @override
  Future<Page> fingRestaurant(
      {int page, int pageSize, String searchTerm}) async {
    final filter = searchTerm != null
        ? (Restaurant res) =>
            res.name.toLowerCase().contains(searchTerm.toLowerCase().trim())
        : null;
    await Future.delayed(Duration(seconds: 2));
    await Future.delayed(Duration(seconds: 2));
    return _paginatedRestaurant(page, pageSize, filter: filter);
  }

  @override
  Future<Page> getAllRestaurants({int page, int pageSize}) async {
    await Future.delayed(Duration(seconds: 1));
    return _paginatedRestaurant(page, pageSize);
  }

  @override
  Future<Restaurant> getRestaurant({String id}) async {
    return this
        .restaurants
        .singleWhere((element) => element.id == id, orElse: () => null);
  }

  @override
  Future<List<Menu>> getRestaurantMenu({String restaurant_id}) async{
  
    await Future.delayed(Duration(seconds: 2));
    return this.all_menus.where((element) => element.id==restaurant_id).toList();
  }

  @override
  Future<Page> getRestaurantswithLocation(
      {int page, int pageSize, Location location}) async {
    final filter =
        location != null ? (Restaurant res) => res.location == location : null;
    return _paginatedRestaurant(page, pageSize, filter: filter);
  }

  Page _paginatedRestaurant(int page, int pageSize,
      {Function(Restaurant) filter}) {
    final int offset = (page - 1) * pageSize;
    final restaurant = filter == null
        ? this.restaurants
        : this.restaurants.where(filter).toList();
    print(restaurant.length);
    final totalPages = (this.restaurants.length / pageSize).ceil();
    final result = restaurant.skip(offset).take(pageSize).toList();
    print(page);
    return Page(
        currentPage: page, totalPages: totalPages, restaurants: restaurant);
  }
}
