
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
  late Future<List<String>> _placeNames;

  @override
  void initState() {
    super.initState();
    _loadPlaceNames();
  }

  Future<void> _loadPlaceNames() async {
    final dbHelper = DatabaseHelper();
    _placeNames = dbHelper.getPlaceNamesForBus(widget.busName, widget.upOrDown);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.busName} Place Names ${widget.upOrDown == 1 ? '[Up]' : '[Down]'}'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<String>>(
        future: _placeNames,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No place names found.'));
          } else {
            final placeNames = snapshot.data!;
            return RouteList(routeNames: placeNames);
          }
        },
      ),
    );
  }
}