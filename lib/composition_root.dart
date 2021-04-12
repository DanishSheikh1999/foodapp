import 'package:auth/auth.dart';
import 'package:common/infra/MHttpClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:foodapp/cache/IlocalStore.dart';
import 'package:foodapp/cache/localStore.dart';
import 'package:foodapp/decorators/sercure_client.dart';
import 'package:foodapp/fakeRestauranApi.dart';
import 'package:foodapp/helpers/headerCubit.dart';
import 'package:foodapp/pages/auth/authPage.dart';
import 'package:foodapp/pages/auth/authPage_adapter.dart';
import 'package:foodapp/pages/menus/menu_adapter.dart';
import 'package:foodapp/pages/restaurant/restaurantListPage.dart';
import 'package:foodapp/pages/restaurant/restaurant_page_adapter.dart';
import 'package:foodapp/states_management/auth/auth_cubit.dart';
import 'package:foodapp/states_management/restaurant/restaurantCubit.dart';
import 'package:foodapp/states_management/restaurant/restaurantState.dart';
import 'package:restaurant/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class CompositionRoot {
  static SharedPreferences sharedPreferences;
  static ILocalStore localStore;
  static String baseUrl;
  static Client client;
  static SecureClient secureClient;
  static AuthManger _manager;
  static RestaurantApi api;
  static IAuthApi  authApi;
  
  static configure() async  {
    sharedPreferences = await SharedPreferences.getInstance();
    localStore = LocalStore(sharedPreferences);
    client = Client();
    secureClient = SecureClient(MHttpClient(client), localStore);
    baseUrl = "http://localhost:3000";
    api = RestaurantApi(secureClient, baseUrl);
    authApi = AuthApi(client, baseUrl);
    _manager= AuthManger(authApi);
    
  }

  static Future<Widget> start() async {
    var token = await localStore.fetch();
    var authType = await localStore.fetchAuthType();
    var service  = _manager.service(authType);
    return token==null?createAuthUI():composeHomeUI(service);
  }
  static Widget createAuthUI() {
    AuthCubit authCubit = AuthCubit(localStore);

    ISignUpService signUpService = SignUpService(authApi);
    IAuthPageAdatper pageAdatper = AuthPageAdapter(composeHomeUI);
    return CubitProvider(
      create: (BuildContext context) => authCubit,
      child: AuthPage(
        authManger: _manager,
        signUpService: signUpService,
        pageAdatper: pageAdatper,
      ),
    );
  }

  static Widget composeHomeUI(IAuthService authService) {  

    // MHttpClient mHttpClient = MHttpClient(client);
    // IRestaurantApi api  = RestaurantApi(mHttpClient, baseUrl);
   
    AuthCubit authCubit = AuthCubit(localStore);
    RestaurantCubit restaurantCubit = RestaurantCubit(api, defaultPageSize: 5);
     IMenuAdapter menuAdapter = MenuAdapter(restaurantCubit);
    IRestaurantPageAdapter pageAdapter = RestaurantPageAdapter(restaurantCubit,menuAdapter,createAuthUI);
   
    return MultiCubitProvider(
      providers: [
        CubitProvider<RestaurantCubit>(
            create: (BuildContext context) => restaurantCubit),
        CubitProvider<HeaderCubit>(
            create: (BuildContext context) => HeaderCubit()),
          CubitProvider<AuthCubit>(create: (BuildContext context)=> authCubit)
      ],
      child: RestaurantListPage(pageAdapter,menuAdapter,authService),
    );
  }
}
