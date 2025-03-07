import 'package:flutter/material.dart';

class RouteList extends StatefulWidget {
  List<Map<String, dynamic>> routeNames = [];

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
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Theme.of(context).brightness != Brightness.dark
                      ? Colors.white
                      : Colors.grey[800]!,
                  width: 1,
                ),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      routeName.toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  leading: routeName.toString() == "Jagannath University"
                      ? const Icon(
                          Icons.school,
                          color: Colors.redAccent,
                          size: 35,
                        )
                      : const Icon(
                          Icons.arrow_circle_down,
                          color: Colors.redAccent,
                          size: 35,
                        ),
                ),
              ),
            ),
          );
        },
        childCount: widget.routeNames.length,
      ),
    );
  }
}
