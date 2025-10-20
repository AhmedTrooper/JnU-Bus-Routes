import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/providers/place_provider.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/widgets/route_tile.dart';

class RouteList extends ConsumerStatefulWidget {
  List<Map<String, dynamic>> routeNames = [];

  RouteList({super.key, required this.routeNames});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _RouteListState();
  }
}

class _RouteListState extends ConsumerState<RouteList> {
  @override
  Widget build(BuildContext context) {
    final bgColor = ref.watch(backgroundColorProvider);
    int stColor = bgColor.value;
    final destination = ref.watch(destinationProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final routeName = widget.routeNames[index]["place_name"];
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Theme.of(context).brightness != Brightness.dark
                      ? Colors.white
                      : Colors.grey[800]!,
                  width:
                      Theme.of(context).brightness != Brightness.dark ? 0 : 1,
                ),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: BusTile(routeName: routeName),
              ),
            ),
          );
        },
        childCount: widget.routeNames.length,
      ),
    );
  }
}
