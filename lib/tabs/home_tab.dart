//Updated....
import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/screens/bus_details.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:jnu_bus_routes/widgets/route_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeTabState();
  }
}

class _HomeTabState extends State<HomeTab> {
  bool _isLoading = true;
  String? userName;
  String? busName;
  bool busOnUp = true;
  late Future<List<String>> _placeNames;

  @override
  void initState() {
    super.initState();
    _placeNames = Future.value([]);
    loadData();
  }

  Future<void> _loadPlaceNames() async {
    if (busName != null) {
      final dbHelper = DatabaseHelper();
      setState(() {
        _placeNames = dbHelper.getPlaceNamesForBus(busName!, busOnUp ? 1 : 0);
      });
    }
  }

  Future<void> loadData() async {
    String? fetchedUserName = await getUserName();
    if (fetchedUserName != null) {
      setState(() {
        userName = fetchedUserName;
      });
    }

    String? fetchedBusName = await getBusName();
    if (fetchedBusName != null) {
      setState(() {
        busName = fetchedBusName;
      });
    }

    await getBusInfo();
    _loadPlaceNames();

    setState(() {
      _isLoading = false;
    });
  }

  Future<String?> getUserName() async {
    String? name = await SharedPreferencesHelper.getUserNameStatus();
    return name;
  }

  Future<String?> getBusName() async {
    String? busName = await SharedPreferencesHelper.getBusName();
    return busName;
  }

  Future<void> getBusInfo() async {
    await DatabaseHelper().getAllBusInfo();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Container(
                height: 800,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    userName != null
                        ? SizedBox(
                            width: 150,
                            child: Image.asset(
                              'assets/images/human.png',
                            ),
                          )
                        : const SizedBox(
                            height: 10,
                          ),

                    userName != null
                        ? Text(
                            "Welcome, $userName!",
                            style: const TextStyle(fontSize: 25),
                          )
                        : const Text(
                            "Add your name from setting tab",
                            style: TextStyle(fontSize: 25),
                          ),

                    // Display bus name
                    busName != null
                        ? Text(
                            "Your selected bus is, $busName!",
                            style: const TextStyle(fontSize: 20),
                          )
                        : const Text(
                            "No Bus Selected!",
                            style: TextStyle(fontSize: 20),
                          ),
                    ShadSwitch(
                      value: busOnUp,
                      label: busOnUp ? const Text("Up") : const Text("Down"),
                      onChanged: (v) => {
                        setState(() => busOnUp = !busOnUp),
                        _loadPlaceNames()
                      },
                    ),

                    Expanded(
                      child: FutureBuilder<List<String>>(
                        future: _placeNames,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text(
                                    "No place's name found...Select bus first"));
                          } else {
                            final placeNames = snapshot.data!;
                            return RouteList(routeNames: placeNames);
                          }
                        },
                      ),
                    )
                  ],
                )),
          );
  }
}
