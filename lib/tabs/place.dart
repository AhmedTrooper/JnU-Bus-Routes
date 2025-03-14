import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/widgets/place_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PlaceTab extends ConsumerStatefulWidget {
  const PlaceTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlaceTabState();
  }
}

class _PlaceTabState extends ConsumerState<PlaceTab> {
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
    final bgColor = ref.watch(backgroundColor);
    int stColor = bgColor.value;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leadingWidth: 100,
          toolbarHeight: 100,
          titleSpacing: 5,
          leading: ShadButton.ghost(
            child: Icon(
              LucideIcons.filter,
              color: Color(stColor),
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
                        backgroundColor: Color(stColor),
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
              },
            ),
          ),
          pinned: true,
        ),
        _filteredPlaceNames.isNotEmpty
            ? PlaceList(placeNames: _filteredPlaceNames)
            : SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ShadCard(
                    description: const Text(
                        "Sorry! Your searched letter hasn't matched any place !"),
                    title: Text(
                      "No Place found!",
                      style: TextStyle(
                          color: Color(stColor), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
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
