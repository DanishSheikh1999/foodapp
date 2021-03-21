import 'dart:convert';

import 'package:common/infra/IhttpClient_contract.dart';
import 'package:common/infra/MHttpClient.dart';

import '../api/page.dart';

import '../domain/menu.dart';

import '../api/restaurant_api_contract.dart';
import '../domain/restaurant.dart';

class RestaurantApi implements IRestaurantApi{
  final MHttpClient httpClient;
  final String baseUrl;

  RestaurantApi(this.httpClient, this.baseUrl);
  @override
  Future<Page> fingRestaurant({int page, String searchTerm,int pageSize}) async {
      final endpoint = baseUrl + "/restaurant/page=$page&limit=$pageSize&searchTerm=$searchTerm";
    final response = await httpClient.get(endpoint);
    return _parseRestauratnsJson(response);
    }
  
    @override
    Future<Restaurant> getRestaurant({String id})async {
      final endpoint = baseUrl + "/restaurant/$id";
      final response = await httpClient.get(endpoint);
      if(response.status!=HttpStatus.Success) return null;
      final json = jsonDecode(response.data);
      return Restaurant.fromJson(json);
    }
  
    @override
    Future<List<Menu>> getRestaurantMenu({String restaurant_id}) async {
        final endpoint = baseUrl + "/restaurant/menu/$restaurant_id";
        final response = await httpClient.get(endpoint);
        print(response.data);
        return _parseRestauratnsMenu(response);
        
            }
          
            @override
            Future<Page> getAllRestaurants({int page,int pageSize}) async {
                final endpoint  = baseUrl + "/restaurants/page=$page&limit=$pageSize";
                final response = await httpClient.get(endpoint);
               
                return _parseRestauratnsJson(response);
                    }
                
                  
                    @override
                    Future<Page> getRestaurantswithLocation({int page, Location location,int pageSize}) async {
                    final endpoint = baseUrl+"/restaurant/page=$page&limit=$pageSize&longitude=${location.longitude}&lattitude=${location.latitude}";
                    final response = await httpClient.get(endpoint);
                    return _parseRestauratnsJson(response);
                  }
                
                  Page _parseRestauratnsJson(HttpResult response) {
                    if(response.status!= HttpStatus.Success )
                      return null;
                      final json = jsonDecode(response.data);
                      print(json);
                      var restaurants=  json["restaurants"]!=null && json["restaurants"]!=[]? _restaurantsfromJson(json):[];
                      return Page(
                        currentPage:json["metadata"]["page"],
                        totalPages:json["metadata"]["totatPages"],
                        restaurants: restaurants                       
                         );
                                }
                      
                        List<Restaurant> _restaurantsfromJson(json) {
                          var  restaurants = json["restaurants"] as List;
                      
                          return restaurants.map<Restaurant>((e) => Restaurant.fromJson(jsonEncode(e))).toList();
                        }
        
          List<Menu> _parseRestauratnsMenu(HttpResult response) {
            if(response.status!=HttpStatus.Success) return [];
            final json  =jsonDecode(response.data);
            if(json["menu"]==null) return [];
            final  menus = json["menu"] as List;
            return  menus.map<Menu>((e) => Menu.fromJson(jsonEncode(e))).toList();
          }

}