import 'package:flutter/material.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class MenuItemList extends StatefulWidget {
  final List<MenuItem> items;

  const MenuItemList(this.items);
  @override
  _MenuItemListState createState() => _MenuItemListState();
}

class _MenuItemListState extends State<MenuItemList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
        subtitle: Text(widget.items[index].description,
        softWrap: true,
        style: Theme.of(context).textTheme.subtitle2,
              overflow: TextOverflow.ellipsis),
              
      ),
      itemCount: widget.items.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}
