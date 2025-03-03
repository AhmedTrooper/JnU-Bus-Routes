import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';


class RouteList extends StatefulWidget{
  List<String> routeNames = [];
   RouteList({super.key, required this.routeNames});
  @override
  State<StatefulWidget> createState() {
    return _RouteListState();
  }
}

class _RouteListState extends State<RouteList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.routeNames.length,
      itemBuilder: (context, index) {
        final routeName = widget.routeNames[index];
        return ListTile(
          title:  ShadCard(
            title: Text(routeName),
            leading: routeName =="Jagannath University" ? const Icon(Icons.school,color: Colors.redAccent,size: 35,) : const Icon(Icons.arrow_circle_down,color: Colors.redAccent,size: 35,),
          ),
        );
      },
    );
  }
}