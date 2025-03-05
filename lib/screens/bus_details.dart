
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
 List<Map<String,dynamic>> _placeNames = [];

  @override
  void initState() {
    super.initState();
    _loadPlaceNames();
  }

  Future<void> _loadPlaceNames() async {
    try{
      List<Map<String,dynamic>> placeNames = await DatabaseHelper().getBusInfo(busName: widget.busName,busType: widget.upOrDown);
      setState(() {
        _placeNames = placeNames;
      });
    } catch(e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.busName} Place Names ${widget.upOrDown == 1 ? '[Up]' : '[Down]'}'),
        backgroundColor: Colors.redAccent,
      ),
      body: CustomScrollView(
        slivers: [
          RouteList(routeNames: _placeNames)
        ],
      )
    );
  }
}