import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // late Future<List<Map<String, dynamic>>> _routeNames;
  // List<Map<String, dynamic>> _busList = [];

  @override
  void initState() {
    super.initState();
    // _routeNames = Future.value([]);
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
        // _routeNames =
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
    final bgColor = ref.watch(backgroundColorProvider);
    int stColor = bgColor.value;
    final placeListArr = ref.watch(placeListProvider);
    final filteredPlaceListArr = ref.watch(filteredPlaceListProvider);
    final busName = ref.watch(busNameProvider);
    final busListForDestination = ref.watch(busListForDestinationProvider);
    final destination = ref.watch(destinationProvider);
    final routeList = ref.watch(routeListProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          surfaceTintColor: Theme.of(context).brightness != Brightness.dark
              ? Colors.transparent
              : Colors.transparent,
          scrolledUnderElevation: 0.0,
          toolbarHeight: 50,
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              "Where to?",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Theme.of(context).brightness != Brightness.dark
                      ? Colors.black
                      : Colors.white),
            ),
          ),
          backgroundColor: Theme.of(context).brightness != Brightness.dark
              ? Colors.white
              : Colors.black12,
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border(
                top: BorderSide(
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.black12
                        : Color(Colors.grey[800]!.value),
                    width: 1),
                bottom: BorderSide(
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.black12
                        : Color(Colors.grey[800]!.value),
                    width: 1),
                right: BorderSide(
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.black12
                        : Color(Colors.grey[800]!.value),
                    width: 1),
                left: BorderSide(
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.black12
                        : Color(Colors.grey[800]!.value),
                    width: 1),
              ),
            ),
            child: TextFormField(
              onChanged: (value) {
                final filteredList = placeListArr
                    .where((place) => place
                        .trim()
                        .toLowerCase()
                        .contains(value.trim().toLowerCase()))
                    .toList();
                ref.read(filteredPlaceListProvider.notifier).state =
                    filteredList;
              },
              showCursor: true,
              style: TextStyle(
                color: Theme.of(context).brightness != Brightness.dark
                    ? Colors.black
                    : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              decoration: InputDecoration(
                  icon: Icon(
                    LucideIcons.search,
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 0.0,
                      style: BorderStyle.none,
                    ),
                  ),
                  hintText: "Search for destination"),
              textAlign: TextAlign.center,
              cursorColor: Theme.of(context).brightness != Brightness.dark
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final placeName = filteredPlaceListArr[index];
                    return placeName != "Jagannath University"
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    color: Theme.of(context).brightness !=
                                            Brightness.dark
                                        ? Colors.white12
                                        : Colors.grey[800]!,
                                    width: 1,
                                  ),
                                ),
                                color: Colors.black12,
                                elevation: 0.0,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/station.png",
                                        width: 60,
                                      ),
                                      SizedBox(
                                        height: 10,
                                        width: 0,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          placeName,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                          ),
                                          softWrap: false,
                                          overflow: TextOverflow.visible,
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                        width: 0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferencesHelper
                                              .setDestOrSource(placeName);
                                          ref
                                              .read(
                                                  destinationProvider.notifier)
                                              .state = placeName;
                                          ref
                                                  .read(
                                                      busListForDestinationProvider
                                                          .notifier)
                                                  .state =
                                              await DatabaseHelper().getBusInfo(
                                                  placeName: placeName);
                                          ref
                                              .read(busNameProvider.notifier)
                                              .state = null;
                                          ref
                                              .read(routeListProvider.notifier)
                                              .state = [];
                                          await SharedPreferencesHelper
                                              .setBusName("");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).brightness !=
                                                      Brightness.dark
                                                  ? Colors.black
                                                  : Colors.transparent,
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.transparent
                                                  : Colors.grey[800]!,
                                              width: 1,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          fixedSize: const Size(150, 50),
                                        ),
                                        child: Text(
                                          'Select',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          )
                        : const SizedBox(height: 0);
                  }, childCount: filteredPlaceListArr.length),
                )
              ],
            ),
          ),
        ),
        destination != null
            ? SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Buses to '$destination'",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily),
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
                    height: 330,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: [BusList(busNames: busListForDestination)],
                    ),
                  ),
                ),
              ),
        ((busName != null && busName != ""))
            ? SliverAppBar(
                expandedHeight: 50,
                collapsedHeight: 65,
                toolbarHeight: 50,
                pinned: true,
                flexibleSpace: Center(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                      border: Border.all(
                        color: Theme.of(context).brightness != Brightness.dark
                            ? Colors.transparent
                            : Color(Colors.grey[800]!.value),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (busName != "")
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Bus : $busName",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(1),
                          child: (busName != "")
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
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.black54
                                                  : Colors.white70,
                                              size: 30,
                                            ),
                                      onChanged: (v) => {
                                        setState(() => busOnUp = !busOnUp),
                                        ref
                                                .read(routeListProvider.notifier)
                                                .state =
                                            ref
                                                .read(
                                                    routeListProvider.notifier)
                                                .state
                                                .reversed
                                                .toList()
                                      },
                                    ),
                                  ],
                                )
                              : const SizedBox(width: 0, height: 0),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              )
            : const SliverToBoxAdapter(
                child: SizedBox(
                  height: 0,
                  width: 0,
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
            height: 20,
          ),
        )
      ],
    );
  }
}
