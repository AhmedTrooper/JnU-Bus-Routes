import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/bus_provider.dart';
import 'package:jnu_bus_routes/providers/place_provider.dart';
import 'package:jnu_bus_routes/providers/route_provider.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
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
    final bgColor = ref.watch(backgroundColor);
    int stColor = bgColor.value;
    final destination = ref.watch(destinationProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final placeName = widget.placeNames[index];

          return placeName != "Jagannath University"
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).brightness != Brightness.dark
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.map,
                                color: Color(stColor),
                                size: 35,
                              ),
                              IconButton(
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
                                        title: const Text('Selected'),
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.transparent
                                                  : Colors.grey[800]!,
                                              style: BorderStyle.solid),
                                          top: BorderSide(
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.transparent
                                                  : Colors.grey[800]!,
                                              style: BorderStyle.solid),
                                          right: BorderSide(
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.transparent
                                                  : Colors.grey[800]!,
                                              style: BorderStyle.solid),
                                          left: BorderSide(
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.transparent
                                                  : Colors.grey[800]!,
                                              style: BorderStyle.solid),
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
                                icon: Icon(
                                  LucideIcons.bookmarkPlus,
                                  size: 35,
                                  color: Color(stColor),
                                ),
                              ),
                            ],
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
                          ElevatedButton(
                            onPressed: () => context.push("/place/$placeName"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(stColor),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              fixedSize: const Size(200, 50),
                            ),
                            child: const Text(
                              'Available Bus',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
