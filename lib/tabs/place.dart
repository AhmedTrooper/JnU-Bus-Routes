import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final bgColor = ref.watch(backgroundColorProvider);
    int stColor = bgColor.value;
    return Container(
      color: Theme.of(context).brightness != Brightness.dark
          ? Colors.transparent
          : Colors.black12,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leadingWidth: 100,
            toolbarHeight: 100,
            titleSpacing: 5,
            backgroundColor: Theme.of(context).brightness != Brightness.dark
                ? Colors.transparent
                : Colors.black12,
            leading: ShadButton.ghost(
              child: Icon(
                LucideIcons.listFilter,
                color: Theme.of(context).brightness != Brightness.dark
                    ? Colors.black54
                    : Colors.white70,
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
                          backgroundColor:
                              Theme.of(context).brightness != Brightness.dark
                                  ? Colors.black12
                                  : Colors.transparent,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Theme.of(context).brightness !=
                                      Brightness.dark
                                  ? Colors.black12
                                  : Colors.grey[800]!,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          fixedSize: const Size(50, 50)),
                      child: Text(
                        alphabetList[index],
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness != Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                            fontWeight: FontWeight.bold),
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
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).brightness != Brightness.dark
                            ? Colors.black12
                            : Colors.transparent,
                        border: Border.all(
                          color: Theme.of(context).brightness != Brightness.dark
                              ? Colors.black12
                              : Colors.grey[800]!,
                          width: 1,
                        )),
                    child: Text(
                      "Sorry! Your searched letter hasn't matched any place !",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
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
      ),
    );
  }
}
