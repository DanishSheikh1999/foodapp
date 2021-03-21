import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:foodapp/cache/IlocalStore.dart';
import 'package:foodapp/cache/localStore.dart';
import 'package:foodapp/fakeRestauranApi.dart';
import 'package:foodapp/helpers/headerCubit.dart';
import 'package:foodapp/pages/auth/authPage.dart';
import 'package:foodapp/pages/menus/menu_adapter.dart';
import 'package:foodapp/pages/restaurant/restaurantListPage.dart';
import 'package:foodapp/pages/restaurant/restaurant_page_adapter.dart';
import 'package:foodapp/states_management/auth/auth_cubit.dart';
import 'package:foodapp/states_management/restaurant/restaurantCubit.dart';
import 'package:foodapp/states_management/restaurant/restaurantState.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class CompositionRoot {
  static SharedPreferences sharedPreferences;
  static ILocalStore localStore;
  static String baseUrl;
  static Client client;

  static configure() {
    localStore = LocalStore(sharedPreferences);
    client = Client();
    baseUrl = "http://localhost:3000";
  }

  static Widget createAuthUI() {
    IAuthApi authApi = AuthApi(client, baseUrl);
    AuthManger authManager = AuthManger(authApi);
    AuthCubit authCubit = AuthCubit(localStore);
    ISignUpService signUpService = SignUpService(authApi);
    return CubitProvider(
      create: (BuildContext context) => authCubit,
      child: AuthPage(
        authManger: authManager,
        signUpService: signUpService,
      ),
    );
  }

  static Widget composeHomeUI() {
    FakeRestaurantApi api = FakeRestaurantApi(20);
    RestaurantCubit restaurantCubit = RestaurantCubit(api, defaultPageSize: 5);
     IMenuAdapter menuAdapter = MenuAdapter(restaurantCubit);
    IRestaurantPageAdapter pageAdapter = RestaurantPageAdapter(restaurantCubit,menuAdapter);
   
    return MultiCubitProvider(
      providers: [
        CubitProvider<RestaurantCubit>(
            create: (BuildContext context) => restaurantCubit),
        CubitProvider<HeaderCubit>(
            create: (BuildContext context) => HeaderCubit())
      ],
      child: RestaurantListPage(pageAdapter,menuAdapter),
    );
  }
}
