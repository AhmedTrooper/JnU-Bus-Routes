import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/widgets/place_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../database/database_helper.dart';

class PlaceTab extends StatefulWidget {
  const PlaceTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _PlaceTabState();
  }
}

class _PlaceTabState extends State<PlaceTab> {
  List<String> _placeNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusNames();
  }

  Future<void> _loadBusNames() async {
    try {
      final dbHelper = DatabaseHelper();
      final placeNames = await dbHelper.getPlaceList();
      setState(() {
        _placeNames = placeNames;
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : PlaceList(placeNames: _placeNames);
  }
}
