import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:foodapp/states_management/cart/cartCubit.dart';
import 'package:foodapp/states_management/cart/cartstate.dart';
import 'package:http/http.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class MenuItemList extends StatefulWidget {
  final List<MenuItem> items;
  final CartCubit cubit;

  const MenuItemList(this.items,this.cubit);
  @override
  _MenuItemListState createState() => _MenuItemListState();
}

class _MenuItemListState extends State<MenuItemList> {
  List<int> quantities ;
  @override
  void initState(){
    super.initState();
    quantities= List.filled(widget.items.length, 1);
  }
  @override
  Widget build(BuildContext context) {
    
    return CubitConsumer(cubit:widget.cubit,builder: (conntext,state){
      return _buildList();
    }, listener: (context,state){
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

      if(state is PushCartSuccess){
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                      backgroundColor: Colors.grey[400],
                                                      content: Text("Added to cart",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .caption
                                                              .copyWith(
                                                                  color:
                                                                      Theme.of(context).accentColor))),
                                                );
                                            }
    });
              
              }
            
            
  _buildList()=>Container(
      key:UniqueKey() ,
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => ListTile(
          isThreeLine: false,
          leading: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.items[index].imageUrls[0],
            height: 50,
            width: 50,
            fit: BoxFit.fill,
          ),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.items[index].name,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline5.copyWith(
                  color:Theme.of(context).accentColor
                ),
                ),
                Text(widget.items[index].unitPrice.toString(),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle2)
              ]),
          subtitle: 
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              
                    IconButton(icon: Icon(Icons.add), onPressed: (){

                      setState(() {
                        quantities[index]+=1;
                        
                      });
                      print(quantities[index]);
                    }),
                    Text(quantities[index].toString()),
                  IconButton(icon: Icon(Icons.horizontal_rule), onPressed: (){
                    setState(() {
                      quantities[index]--;
                    });
                    
                    
                  }),
                          IconButton(icon: Icon(Icons.add_shopping_cart), onPressed: (
                              
                          )async{
                          
                            await widget.cubit.addCarts(menuItem: widget.items[index].id, quantity: quantities[index]);
                          }),
                        ],
                      ),
                            
                    ),
                    itemCount: widget.items.length,
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                  ),
    );
  
  
}
