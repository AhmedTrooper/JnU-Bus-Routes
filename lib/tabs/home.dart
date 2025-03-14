import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/bus_provider.dart';
import 'package:jnu_bus_routes/providers/place_provider.dart';
import 'package:jnu_bus_routes/providers/route_provider.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:jnu_bus_routes/widgets/bus_list.dart';
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
  String? _busName;
  String? destination;
  bool busOnUp = true;
  late Future<List<Map<String, dynamic>>> _routeNames;

  // List<String> placeNames = [
  //   "Azimpur",
  //   "Dhupkhola",
  //   "Iraqi Math",
  //   "Police fari"
  // ];
  List<Map<String, dynamic>> _busList = [];

  @override
  void initState() {
    super.initState();
    _routeNames = Future.value([]);
    loadData();
  }

  // Future<void> _loadPlaceName() async {
  //   try {
  //     final dbHelper = DatabaseHelper();
  //     final _placeNames = await dbHelper.getPlaceList();
  //     setState(() {
  //       placeNames = placeNames;
  //       // _filteredPlaceNames = placeNames;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _loadPlaceNames() async {
    if (_busName != null) {
      final dbHelper = DatabaseHelper();
      setState(() {
        _routeNames =
            dbHelper.getBusInfo(busName: _busName, busType: busOnUp ? 1 : 0);
      });
    }
  }

  Future<void> loadData() async {
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
    final placeListArr = ref.watch(placeListProvider);
    final busName = ref.watch(busNameProvider);
    final busListForDestination = ref.watch(busListForDestinationProvider);
    final destination = ref.watch(destinationProvider);
    final routeList = ref.watch(routeListProvider);
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "Place suggestions",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 230,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final placeName = placeListArr[index];
                    return placeName != "Jagannath University"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Theme.of(context).brightness !=
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.grey[800]!,
                                  width: 1,
                                ),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.map,
                                      color: Color(stColor),
                                      size: 35,
                                    ),
                                    const SizedBox(width: 8),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        placeName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: false,
                                        overflow: TextOverflow.visible,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Mark as your Source/ Destinition",
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              SharedPreferencesHelper
                                                  .setDestOrSource(placeName);
                                              ref
                                                  .read(destinationProvider
                                                      .notifier)
                                                  .state = placeName;
                                              ref
                                                      .read(
                                                          busListForDestinationProvider
                                                              .notifier)
                                                      .state =
                                                  await DatabaseHelper()
                                                      .getBusInfo(
                                                          placeName: placeName);
                                              ref
                                                  .read(
                                                      busNameProvider.notifier)
                                                  .state = null;
                                              ref
                                                  .read(routeListProvider
                                                      .notifier)
                                                  .state = [];
                                              await SharedPreferencesHelper
                                                  .setBusName("");
                                            },
                                            icon: Icon(
                                              LucideIcons.bookmarkPlus,
                                              size: 35,
                                              color: Color(stColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(height: 0);
                  }, childCount: placeListArr.length),
                )
              ],
            ),
          ),
        ),
        destination != null
            ? const SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Bus suggestions",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            : const SliverToBoxAdapter(
                child: SizedBox(
                  height: 0,
                  width: 0,
                ),
              ),
        destination == null
            ? const SliverToBoxAdapter(
                child: SizedBox(
                  height: 0,
                  width: 0,
                ),
              )
            : SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 300,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: [BusList(busNames: busListForDestination)],
                    ),
                  ),
                ),
              ),
        ((destination != null && destination != "") &&
                (busName != null && busName != ""))
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "🚩 $destination",
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              )
            : const SliverToBoxAdapter(
                child: SizedBox(
                  height: 0,
                  width: 0,
                ),
              ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: (busName != null && busName != "")
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("🚌 $busName",
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
            child: (busName != null && busName != "")
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
                          ref.read(routeListProvider.notifier).state = ref
                              .read(routeListProvider.notifier)
                              .state
                              .reversed
                              .toList()
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
        routeList.isEmpty
            ? const SliverToBoxAdapter(
                child: SizedBox(
                  height: 0,
                  width: 0,
                ),
              )
            : RouteList(routeNames: routeList),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        )
      ],
    );
  }
}
