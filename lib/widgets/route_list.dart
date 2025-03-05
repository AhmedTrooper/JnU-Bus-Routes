import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';


class RouteList extends StatefulWidget{
  List<Map<String,dynamic>> routeNames = [];
  RouteList({super.key, required this.routeNames});
  @override
  State<StatefulWidget> createState() {
    return _RouteListState();
  }
}

class _RouteListState extends State<RouteList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
      (context, index) {
        final routeName = widget.routeNames[index]["place_name"];
        return ListTile(
          title:  ShadCard(
            title: Text(routeName.toString()),
            leading: routeName.toString() =="Jagannath University" ? const Icon(Icons.school,color: Colors.redAccent,size: 35,) : const Icon(Icons.arrow_circle_down,color: Colors.redAccent,size: 35,),
          ),
        );

      } , childCount: widget.routeNames.length,

      ),
    );
  }
}

