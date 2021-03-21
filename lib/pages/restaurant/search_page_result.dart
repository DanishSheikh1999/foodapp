import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:foodapp/customBuilds/utils.dart';
import 'package:foodapp/pages/menus/menu_adapter.dart';
import 'package:foodapp/states_management/restaurant/restaurantCubit.dart';
import 'package:foodapp/states_management/restaurant/restaurantState.dart';

class SearchResultsPage extends StatefulWidget {
  final RestaurantCubit cubit;
  final String query;
  final IMenuAdapter menuAdapter;
  SearchResultsPage(

    this.cubit,
    this.query,
    this.menuAdapter,
  ) ;
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  PageLoaded currentState;
  bool fetchMore = false;
  List<Restaurant> restaurants = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.cubit.search(1, widget.query);
    super.initState();
    _onScrollListener();
  }

  void _onScrollListener(){
    print(widget.query);
    scrollController.addListener(() {
      if(scrollController.offset==scrollController.position.maxScrollExtent && currentState.nextPage!=null){
        fetchMore =true;
      widget.cubit.search(currentState.nextPage, widget.query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).accentColor,
          ),
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "${widget.query} Results",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(child: _buildResult())
          ],
        ),
      ),
    );
  }

  _buildResult() => CubitBuilder<RestaurantCubit, RestaurantState>(
      cubit: widget.cubit,
      builder: (_, state) {
        if (state is PageLoaded) {
          currentState = state;
          fetchMore = false;
          restaurants.addAll(state.restaurants);
        }
        if (state is ErrorState) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        }
        if (currentState == null)
          return Center(child: CircularProgressIndicator());

        return _buildResultList();
      });

  _buildResultList() => ListView.separated(
        physics: BouncingScrollPhysics(),
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          return index >= restaurants.length
              ? bottomLoader()
              : GestureDetector(
                onTap:(){
                  widget.menuAdapter.find_menu(context, restaurants[index]);
                },
                              child: ListTile(
                    leading: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: "https://picsum.photos/id/292/300",
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurants[index].name,
                          overflow:TextOverflow.ellipsis,
                          softWrap:true,
                          style:Theme.of(context).textTheme.subtitle1
                        ),
                        RatingBarIndicator(
                          rating: 4,
                          itemSize: 25,
                          itemBuilder: (_,index){
                            return Icon(Icons.star,color: Theme.of(context).accentColor);},),
                            

                      ],
                    ),
                    subtitle:  Text(
                      "${restaurants[index].address.street} ,${restaurants[index].address.city},${restaurants[index].address.district},${restaurants[index].address.state}",
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.black54))),
              );
                
        },
        itemCount: !fetchMore ? restaurants.length : restaurants.length + 1,
        separatorBuilder: (BuildContext context, int index) => Divider(),
      );
}
