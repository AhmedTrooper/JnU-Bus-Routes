import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/widgets/route_list.dart';

import '../database/database_helper.dart';

class BusDetailsScreen extends StatefulWidget {
  final String busName;
  final int upOrDown;

  const BusDetailsScreen({
    super.key,
    required this.busName,
    required this.upOrDown,
  });

  @override
  _BusDetailsScreenState createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  List<Map<String, dynamic>> _placeNames = [];

  @override
  void initState() {
    super.initState();
    _loadPlaceNames();
  }

  Future<void> _loadPlaceNames() async {
    try {
      List<Map<String, dynamic>> placeNames = await DatabaseHelper()
          .getBusInfo(busName: widget.busName, busType: widget.upOrDown);
      setState(() {
        _placeNames = placeNames;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.busName} ${widget.upOrDown == 1 ? '[Up]' : '[Down]'}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 25,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            splashRadius: 20,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          leadingWidth: 100,
        ),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
              ),
            ),
            RouteList(routeNames: _placeNames)
          ],
        ));
  }
}
