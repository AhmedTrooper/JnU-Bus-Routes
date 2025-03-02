import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:jnu_bus_routes/widgets/bus_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../database/database_helper.dart';

class BusTab extends StatefulWidget {
  const BusTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BusTabState();
  }
}

class _BusTabState extends State<BusTab> {
  List<String> _busNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusNames();
  }

  Future<void> _loadBusNames() async {
    try {
      final dbHelper = DatabaseHelper();
      final busNames = await dbHelper.getBusList();
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : BusList(busNames: _busNames);
  }
}
