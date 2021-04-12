import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:foodapp/states_management/auth/auth_cubit.dart';
import 'package:foodapp/states_management/auth/auth_state.dart' as authState; 
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:foodapp/customBuilds/customtextformfield.dart';
import 'package:foodapp/helpers/headerCubit.dart';
import 'package:foodapp/models/helper.dart';
import 'package:foodapp/pages/menus/menu_adapter.dart';
import 'package:foodapp/pages/restaurant/restaurantListItem.dart';
import 'package:foodapp/pages/restaurant/restaurant_page_adapter.dart';
import 'package:foodapp/states_management/restaurant/restaurantCubit.dart';
import 'package:foodapp/states_management/restaurant/restaurantState.dart';

class RestaurantListPage extends StatefulWidget {
  final IRestaurantPageAdapter adapter;
final IMenuAdapter menuAdapter;
final IAuthService service;
  const RestaurantListPage(
    this.adapter,
    this.menuAdapter,
    this.service
  ) ;
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  PageLoaded currentState;
  List<Restaurant> restaurants = [];
  double currentIndex = 0;
  double previousIndex = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    CubitProvider.of<RestaurantCubit>(context).getAllRestaurants(page: 1);
    _scrollListener();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading:IconButton(icon:Icon(Icons.power_settings_new_outlined),onPressed:(){
            _logout();
                      }),
                      actions: [
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.shopping_cart,
                                color: Colors.black54,
                                size: 36,
                              )),
                        )
                      ],
                    ),
                    extendBodyBehindAppBar: true,
                    body: GestureDetector(
                      onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
                              child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Align(
                            child: _header(),
                            alignment: Alignment.topCenter,
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: 0.75,
                                child: CubitConsumer<RestaurantCubit, RestaurantState>(
                                  builder: (_, state) {
                                    if (state is PageLoaded) {
                                      currentState = state;
            
                                      restaurants.addAll(state.restaurants);
                                      _updateHeader();
                                    }
            
                                    if (currentState == null)
                                      return Center(child: CircularProgressIndicator());
            
                                    return _buildListOfRestaurants();
                                  },
                                  listener: (context, state) {
                                    if (state is ErrorState) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.grey[400],
                                            content: Text(state.message,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                        color:
                                                            Theme.of(context).accentColor))),
                                      );
                                    }
                                  },
                                ),
                              )),
                             Align(
              child: CubitListener<AuthCubit, authState.AuthState>(
                  child: Container(),
                  listener: (context, state) {
                    if (state is authState.LoadingState) {
                      _showLoader();
                    }
                    if (state is authState.SignOutSuccesState) {
                      widget.adapter.logout(context);
                    }
                    if (state is authState.ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.error,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                          ),
                        ),
                      );
                      _hideLoader();
                    }
                  }),
              alignment: Alignment.center,
            ),
                        ],
                      ),
                    ));
              }
            
              _header() => Container(
                  decoration: BoxDecoration(color: Theme.of(context).accentColor),
                  height: 350,
                  child: Stack(
                    children: [
                      CubitBuilder<HeaderCubit, Header>(
                        builder: (_, state) => _buildDynamicHeaderInfo(state),
                      ),
                      Align(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 70),
                        child: CustomTextFormField(
                          hint: "Search Restaurants",
                          obscureText: false,
                          backgroundColor: Colors.black54,
                          color: Theme.of(context).accentColor,
                          onChanged: (value) {},
                          onSubmitted:(value){
                            if(value.isEmpty)return ;
                            widget.adapter.search(context, value);
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          validator: (value) {},
                          width: double.infinity,
                          icon: Icon(
                            Icons.search,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ))
                    ],
                  ));
            
              _buildDynamicHeaderInfo(Header state) => Stack(
                    children: [
                      FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: state.imageUrl,
                        height: 350,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Container(color: Theme.of(context).accentColor.withOpacity(0.7)),
                      Align(
                          child: Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 20),
                        child: Text(
                          state.title,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                        ),
                      ))
                    ],
                  );
            
              _updateHeader() {
                var restaurant = restaurants[currentIndex.toInt()];
                CubitProvider.of<HeaderCubit>(context)
                    .update(restaurant.type, restaurant.displayImageUrl);
              }
            
              Widget _buildListOfRestaurants() {
                return Container(
                    child: NotificationListener<ScrollEndNotification>(
                  onNotification: (_) {
                    print(currentIndex);
                    if (currentIndex != previousIndex) _updateHeader();
                    previousIndex = currentIndex;
                    return true;
                  },
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      itemCount: currentState == null
                          ? restaurants.length
                          : restaurants.length + 1,
                      itemBuilder: (context, index) {
                        return index >= restaurants.length
                            ? _bottomLoader()
                            : GestureDetector(
                              onTap: (){
                                widget.menuAdapter.find_menu(context, restaurants[index]);
                                   },
                              child: RestaurantListItem(restaurants[index]));
                      }),
                ));
              }
            
              _bottomLoader() => Container(
                  alignment: Alignment.center,
                  child: Center(
                      child: SizedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                    width: 30,
                    height: 30,
                  )));
            
              void _scrollListener() {
                _scrollController.addListener(() {
                  currentIndex = (_scrollController.offset.round() / 240).floorToDouble();
                  if (_scrollController.offset ==
                          _scrollController.position.maxScrollExtent &&
                      currentState.nextPage != null) {
                    CubitProvider.of<RestaurantCubit>(context)
                        .getAllRestaurants(page: currentState.nextPage);
                  }
                });
              }
            
              @override
              void dispose() {
                _scrollController.dispose();
                super.dispose();
              }
            
              _logout() {
              CubitProvider.of<AuthCubit>(context).signout(widget.service);
              }
_showLoader(){
  print("Inside");
  var alert = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Center(
      child:CircularProgressIndicator(backgroundColor:Colors.white70)

    ),
  );
  showDialog(context: context, barrierDismissible: true, builder: (_)=>alert);
}

_hideLoader(){
  Navigator.of(context,rootNavigator:true).pop();
}
}
