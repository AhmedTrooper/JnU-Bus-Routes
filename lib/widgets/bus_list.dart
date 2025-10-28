import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/bus_provider.dart';
import 'package:jnu_bus_routes/providers/route_provider.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BusList extends ConsumerStatefulWidget {
  List<Map<String, dynamic>> busNames = [];

  BusList({super.key, required this.busNames});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BusListState();
  }
}

class _BusListState extends ConsumerState<BusList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = ref.watch(backgroundColorProvider);
    int stColor = bgColor.value;
    // final busNameFromProvider = ref.watch(busNameProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: widget.busNames.length,
        (context, index) {
          final busName = widget.busNames[index];
          return Card(
            color: Colors.black12,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Theme.of(context).brightness != Brightness.dark
                    ? Colors.white12
                    : Colors.grey[800]!,
                width: 1,
              ),
            ),
            // shadowColor: Colors.black.withOpacity(1),
            // borderOnForeground: true,
            child: Container(
              width: 350,
              // height: 800,
              // color: Color(stColor),
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/bus.png",
                    width: 80,
                  ),
                  const SizedBox(height: 20),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "🚎 ${busName['bus_name']}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Theme.of(context).brightness != Brightness.dark
                            ? Colors.black
                            : Colors.white70,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () =>
                                context.push("/bus/${busName['bus_name']}/1"),
                            icon: Icon(
                              Icons.arrow_upward_outlined,
                              color: Theme.of(context).brightness !=
                                      Brightness.dark
                                  ? Colors.black54
                                  : Colors.white70,
                              size: 30,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                context.push("/bus/${busName['bus_name']}/0"),
                            icon: Icon(
                              Icons.arrow_downward_outlined,
                              color: Theme.of(context).brightness !=
                                      Brightness.dark
                                  ? Colors.black54
                                  : Colors.white70,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.location_on,
                            color:
                                Theme.of(context).brightness != Brightness.dark
                                    ? Colors.black54
                                    : Colors.white70,
                            size: 30,
                          ),
                          Text(
                            "${busName['last_stoppage']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: Theme.of(context).brightness !=
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white70),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${busName['up_time']}-${busName['down_time']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: Theme.of(context).brightness !=
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white70,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async => {
                      SharedPreferencesHelper.setBusName(busName['bus_name']),
                      ref.read(busNameProvider.notifier).state =
                          busName['bus_name'],
                      ref.read(routeListProvider.notifier).state =
                          await DatabaseHelper().getBusInfo(
                              busName: busName['bus_name'], busType: 1),
                      if (context.mounted)
                        {
                          ShadToaster.of(context).show(
                             ShadToast(
                              title: Text('Selected'),
                              description: Text('${busName['bus_name']} is selected'),
                            ),
                          ),
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness != Brightness.dark
                              ? Colors.black
                              : Colors.transparent,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).brightness != Brightness.dark
                              ? Colors.transparent
                              : Colors.grey[800]!,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      fixedSize: const Size(200, 50),
                    ),
                    child: Text(
                      'Select',
                      style: TextStyle(
                          color: Theme.of(context).brightness != Brightness.dark
                              ? Colors.white
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins().fontFamily),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
