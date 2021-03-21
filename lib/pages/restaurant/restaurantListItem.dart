import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant/restaurant.dart';

class RestaurantListItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantListItem(this.restaurant);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
      child: Container(
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              restaurant.name,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 12),
            FractionallySizedBox(
                widthFactor: 0.7,
                child: Text(
                    "${restaurant.address.street} ,${restaurant.address.city},${restaurant.address.district},${restaurant.address.state}",
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.black54))),
            SizedBox(
              height: 12,
            ),
            RatingBarIndicator(
              rating:4.5,
              itemCount: 5,
                itemBuilder: (context, index) => Icon(Icons.star_rate_rounded,
                    color: Theme.of(context).accentColor)),
                    Text("4.5",style: Theme.of(context).textTheme.headline5,),
                    SizedBox(height:12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [_createChip("Vegeterian",context),
                      _createChip("Vegan",context)],
                      
                                          )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context).accentColor,
                                        blurRadius: 0,
                                        offset: const Offset(5, 5))
                                  ]),
                            ),
                          );
                        }
                      
                        _createChip(String label,BuildContext context) => Chip(
                          backgroundColor: Colors.black54,
                          label:Text(label,style:Theme.of(context).textTheme.subtitle1.copyWith(
                            color:Theme.of(context).accentColor
                          ),
                          
                        ));
}
