import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/bus_provider.dart';
import 'package:jnu_bus_routes/providers/place_provider.dart';
import 'package:jnu_bus_routes/providers/route_provider.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PlaceList extends ConsumerStatefulWidget {
  List<String> placeNames = [];

  PlaceList({super.key, required this.placeNames});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlaceListState();
  }
}

class _PlaceListState extends ConsumerState<PlaceList> {
  @override
  Widget build(BuildContext context) {
    // final bgColor = ref.watch(backgroundColorProvider);
    // int stColor = bgColor.value;
    // final destination = ref.watch(destinationProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final placeName = widget.placeNames[index];

          return placeName != "Jagannath University"
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).brightness != Brightness.dark
                            ? Colors.white
                            : Colors.grey[800]!,
                        width: 1,
                      ),
                    ),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/station.png",
                            width: 100,
                          ),
                          const SizedBox(width: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              placeName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                              softWrap: false,
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    context.push("/place/$placeName"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).brightness !=
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.transparent,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Theme.of(context).brightness !=
                                              Brightness.dark
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
                                  'Available Bus',
                                  style: TextStyle(
                                      color: Theme.of(context).brightness !=
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () async {
                                  SharedPreferencesHelper.setDestOrSource(
                                      placeName);
                                  ref.read(destinationProvider.notifier).state =
                                      placeName;
                                  ref
                                          .read(busListForDestinationProvider
                                              .notifier)
                                          .state =
                                      await DatabaseHelper()
                                          .getBusInfo(placeName: placeName);
                                  SharedPreferencesHelper.setDestOrSource(
                                      placeName);
                                  ref.read(destinationProvider.notifier).state =
                                      placeName;
                                  ref
                                          .read(busListForDestinationProvider
                                              .notifier)
                                          .state =
                                      await DatabaseHelper()
                                          .getBusInfo(placeName: placeName);
                                  ref.read(busNameProvider.notifier).state =
                                      null;
                                  ref.read(routeListProvider.notifier).state =
                                      [];
                                  await SharedPreferencesHelper.setBusName("");
                                  if (mounted) {
                                    ShadToaster.of(context).show(
                                      ShadToast(
                                        title: Text(
                                          'Selected',
                                          style: TextStyle(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily),
                                        ),
                                        description:
                                            Text('$placeName is selected'),
                                        action: ShadButton.outline(
                                          child: const Text('Close'),
                                          onPressed: () =>
                                              ShadToaster.of(context).hide(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).brightness !=
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.transparent,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Theme.of(context).brightness !=
                                            Brightness.dark
                                        ? Colors.transparent
                                        : Colors.grey[800]!,
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                fixedSize: const Size(200, 50),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Set as Destination',
                                    style: TextStyle(
                                        color: Theme.of(context).brightness !=
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily),
                                  ),
                                  Icon(Icons.place,color: Theme.of(context).brightness !=
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.white,)
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 0);
        },
        childCount: widget.placeNames.length,
      ),
    );
  }
}
