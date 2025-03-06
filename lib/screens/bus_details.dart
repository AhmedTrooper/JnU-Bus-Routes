import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/widgets/route_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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
        title: Text('${widget.busName} ${widget.upOrDown == 1 ? '[Up]' : '[Down]'}',
        style:   const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
        ),
        backgroundColor: Colors.redAccent,
        leading:IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,size: 25,), // Replace with your desired icon
          color: Colors.black, // Set the icon color (optional)
          onPressed: () {
            Navigator.pop(context); // Pop the current route
          },
          splashRadius: 20, // Reduce the splash effect radius
          splashColor: Colors.transparent, // Make the splash effect transparent
          highlightColor: Colors.transparent, // Remove highlight effect
        ),
        leadingWidth: 100,

      ),
      body: CustomScrollView(
        slivers: [
          RouteList(routeNames: _placeNames)
        ],
      )
    );
  }
}