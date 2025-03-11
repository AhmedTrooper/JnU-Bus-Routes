import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/widgets/bus_list.dart';

import '../database/database_helper.dart';

class PlaceDetailsScreen extends ConsumerStatefulWidget {
  final String placeName;
  final int upOrDown = 1;

  const PlaceDetailsScreen({
    super.key,
    required this.placeName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends ConsumerState<PlaceDetailsScreen> {
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
    final bgColor = ref.watch(backgroundColor);
    int stColor = bgColor.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " ${widget.placeName}",
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(stColor),
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
          BusList(busNames: _busNames),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
