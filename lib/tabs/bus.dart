import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/widgets/bus_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BusTab extends ConsumerStatefulWidget {
  const BusTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BusTabState();
  }
}

class _BusTabState extends ConsumerState<BusTab> {
  List<Map<String, dynamic>> _busNames = [];
  List<Map<String, dynamic>> _filteredBusNames = [];
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
    _loadBusNames();
  }

  Future<void> _loadBusNames() async {
    try {
      final dbHelper = DatabaseHelper();
      final busNames = await dbHelper.getBusInfo();
      setState(() {
        _busNames = busNames;
        _filteredBusNames = busNames;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterBusName(String filterLetter) async {
    final dbHelper = DatabaseHelper();
    final busNames = await dbHelper.getFilteredBusList(filterLetter);
    setState(() {
      _filteredBusNames = busNames;
    });
  }

  void clearFilter() {
    setState(() {
      _filteredBusNames = _busNames;
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
                      onPressed: () => _filterBusName(alphabetList[index]),
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
            pinned: false,
          ),
          _filteredBusNames.isNotEmpty
              ? BusList(busNames: _filteredBusNames)
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
                      "Sorry! Your searched letter hasn't matched any bus!",
                      style: TextStyle(
                        fontSize: 20,
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
