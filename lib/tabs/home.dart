import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:jnu_bus_routes/widgets/route_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeTabState();
  }
}

class _HomeTabState extends ConsumerState<HomeTab>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String? _userName;
  String? _busName;
  bool busOnUp = true;
  late Future<List<Map<String, dynamic>>> _placeNames;

  @override
  void initState() {
    super.initState();
    _placeNames = Future.value([]);
    loadData();
  }

  Future<void> _loadPlaceNames() async {
    if (_busName != null) {
      final dbHelper = DatabaseHelper();
      setState(() {
        _placeNames =
            dbHelper.getBusInfo(busName: _busName, busType: busOnUp ? 1 : 0);
      });
    }
  }

  Future<void> loadData() async {
    String? fetchedUserName = await getUserName();
    if (fetchedUserName != null) {
      setState(() {
        _userName = fetchedUserName;
      });
    }

    String? fetchedBusName = await getBusName();
    if (fetchedBusName != null) {
      setState(() {
        _busName = fetchedBusName;
      });
    }

    _loadPlaceNames();

    setState(() {
      _isLoading = false;
    });
  }

  Future<String?> getUserName() async {
    String? name = await SharedPreferencesHelper.getUserName();
    return name;
  }

  Future<String?> getBusName() async {
    String? busName = await SharedPreferencesHelper.getBusName();
    return busName;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = ref.watch(backgroundColor);
    int stColor = bgColor.value;
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _userName != null
                ? Image.asset(
                    "assets/images/human.png",
                    width: 150,
                    height: 150,
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _userName != null
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "🎗️$_userName🎗️",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _busName != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(" $_busName 🚌",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold))
                    ],
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _busName != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShadSwitch(
                        checkedTrackColor: Color(stColor),
                        value: busOnUp,
                        label: busOnUp
                            ? Icon(
                                LucideIcons.university,
                                color: Color(stColor),
                                size: 30,
                              )
                            : Icon(
                                LucideIcons.house,
                                color: Color(stColor),
                                size: 30,
                              ),
                        onChanged: (v) => {
                          setState(() => busOnUp = !busOnUp),
                          _loadPlaceNames()
                        },
                      )
                    ],
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
          ),
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _placeNames,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return SliverFillRemaining(
                child: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Icon(
                    LucideIcons.bus,
                    color: Color(stColor),
                    size: 35,
                  ),
                ),
              );
            } else {
              final routeNames = snapshot.data!;
              return RouteList(routeNames: routeNames);
            }
          },
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        )
      ],
    );
  }
}
