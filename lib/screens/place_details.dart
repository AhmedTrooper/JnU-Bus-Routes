import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/main.dart';
import 'package:jnu_bus_routes/widgets/bus_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../database/database_helper.dart';
import 'package:go_router/go_router.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeName;
  final int upOrDown = 1 ;

  const PlaceDetailsScreen({
    super.key,
    required this.placeName,
  });

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  List<Map<String, dynamic>> _busNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusNames();
  }

  Future<void> _loadBusNames() async {
    try {
      final dbHelper = DatabaseHelper();
      final busNames = await dbHelper.getBusInfo(placeName: widget.placeName);
      setState(() {
        _busNames = busNames;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" ${widget.placeName}",
          style:  const TextStyle(
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
          BusList(busNames: _busNames)
        ],
      ),
    );
  }
}