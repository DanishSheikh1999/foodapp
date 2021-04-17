import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodapp/pages/menus/menuitemlist.dart';
import 'package:foodapp/states_management/cart/cartCubit.dart';
import 'package:foodapp/states_management/restaurant/restaurantState.dart';
import 'package:restaurant/restaurant.dart';

import 'package:foodapp/states_management/restaurant/restaurantCubit.dart';
import 'package:transparent_image/transparent_image.dart';

class DisplayMenus extends StatefulWidget {
  final Restaurant restaurant;
  final RestaurantCubit restaurantCubit;
  final CartCubit cartCubit;
  const DisplayMenus({
    Key key,
    this.restaurant,
    this.restaurantCubit,
    this.cartCubit
  }) : super(key: key);


  
  @override
  _DisplayMenusState createState() => _DisplayMenusState();
}

class _DisplayMenusState extends State<DisplayMenus>  {
  List<Menu> menus=[];
  MenuLoaded currentState;
 
  @override
  void initState(){
    widget.restaurantCubit.getRestaurantMenu(widget.restaurant.id);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
     
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment:Alignment.topCenter,
            child:_header()
                      ),
            Align(
              alignment:Alignment.bottomCenter,
              child:FractionallySizedBox(
                heightFactor:.52,
                child:CubitConsumer<RestaurantCubit,RestaurantState>(
                  cubit: widget.restaurantCubit,
                  builder: (_,state){
                      if(state is MenuLoaded){
                        currentState = state;
                        
                        menus.addAll(state.menu);
                      }
                      return _buildMenuList();
                                           
                                        },
                                        listener: (context,state) async {
                                            if(state is ErrorState){
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
                                        })
                                    )
                                  )
                                          ]
                                          ,),
                                      );
                                    }
                                  
                                    _header() =>
                                    FractionallySizedBox(
                                      heightFactor: .48,
                                      child: Stack(
                                        children:[
                                            Align(
                                              alignment:Alignment.topCenter,
                                              child:  FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: widget.restaurant.displayImageUrl,
                                  height: 350,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                            )),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 150,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [BoxShadow(
                                            color:Theme.of(context).accentColor,
                                            blurRadius:1,
                                            spreadRadius:1
                                          )]
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                           
                                            Text(widget.restaurant.name,
                                            softWrap:true,
                                            overflow:TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.headline5.copyWith(
                                              color:Theme.of(context).accentColor
                                            ),),
                                            SizedBox(height: 12),
                                  FractionallySizedBox(
                                      widthFactor: 0.7,
                                      child: Text(
                                          "${widget.restaurant.address.street} ,${widget.restaurant.address.city},${widget.restaurant.address.district},${widget.restaurant.address.state}",
                                          softWrap: true,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(color: Colors.black54))),
                                              SizedBox(height:12),
                                              RatingBarIndicator(itemBuilder: (context,_)=>Icon(Icons.star,color:Theme.of(context).accentColor),rating: 4.5,itemCount: 5,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                        ])
                                      );
                      
                         _buildMenuList()=>DefaultTabController(
                           length: menus.length,
                           child: Container(
                             child: Column(
                               children: [
                                 TabBar(
                                   
                                   indicatorColor: Theme.of(context).accentColor,
                                   labelColor: Theme.of(context).accentColor,
                                   isScrollable: true,
                                   unselectedLabelColor: Colors.black54,
                                   tabs: menus.map<Widget>((e) => Tab(text: e.name)).toList()),
                                   Expanded(
                                     child:TabBarView(children: menus.map<Widget>((e) => MenuItemList(e.items,widget.cartCubit)).toList(),)
                                   )
                               ],
                             ),
                               ),
                           );
}