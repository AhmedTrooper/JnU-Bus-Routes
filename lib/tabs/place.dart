import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/widgets/place_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PlaceTab extends StatefulWidget {
  const PlaceTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlaceTabState();
  }
}

class _PlaceTabState extends State<PlaceTab> {
  List<String> _placeNames = [];
  List<String> _filteredPlaceNames = [];
  bool _isLoading = true;
  String? selectedKey;
  final List<String> alphabetList = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  @override
  void initState() {
    super.initState();
    _loadPlaceName();
  }

  Future<void> _loadPlaceName() async {
    try {
      final dbHelper = DatabaseHelper();
      final placeNames = await dbHelper.getPlaceList();
      setState(() {
        _placeNames = placeNames;
        _filteredPlaceNames = placeNames;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterPlaceName(String filterLetter) async {
    final dbHelper = DatabaseHelper();
    final placeNames = await dbHelper.getFilteredPlaceList(filterLetter);
    setState(() {
      _filteredPlaceNames = placeNames;
    });
  }

  void clearFilter() {
    setState(() {
      _filteredPlaceNames = _placeNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leadingWidth: 100,
          toolbarHeight: 100,
          titleSpacing: 5,
          leading: ShadButton.ghost(
            child: const Icon(
              LucideIcons.filter,
              color: Colors.blue,
              size: 35,
            ),
            onPressed: () {
              clearFilter();
            },
          ),
          title: Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: alphabetList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        onPressed: () => _filterPlaceName(alphabetList[index]),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            fixedSize: const Size(50, 50)),
                        child: Text(
                          alphabetList[index],
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  })),
          pinned: true,
        ),
        _filteredPlaceNames.isNotEmpty
            ? PlaceList(placeNames: _filteredPlaceNames)
            : const SliverToBoxAdapter(
                child: Padding(
                padding: EdgeInsets.all(16),
                child: ShadCard(
                  description: Text(
                      "Sorry! Your searched letter hasn't matched any place !"),
                  title: Text(
                    "No Place found!",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ))
      ],
    );
  }
}
