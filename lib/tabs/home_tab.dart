import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeTabState();
  }
}

class _HomeTabState extends State<HomeTab>{
  bool _isLoading = true;
  String? userName;
  @override
  void initState() {
    super.initState();
    getBusInfo();
  
  }








  Future<void> getBusInfo() async {
    await DatabaseHelper().getAllBusInfo();
    setState(() {
      _isLoading = false;
    });
  }

@override
  Widget build(BuildContext context) {
  return  const SingleChildScrollView(
    child: Column(
      children: [
  Text("No data yet in homepage")
      ],
    ),
  );
  }
}