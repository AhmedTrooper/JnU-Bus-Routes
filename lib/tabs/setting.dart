import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnu_bus_routes/constants/color_list.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingTab extends ConsumerStatefulWidget {
  const SettingTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SettingTabState();
  }
}

class _SettingTabState extends ConsumerState<SettingTab> {
  final formKey = GlobalKey<ShadFormState>();
  final _userNameController = TextEditingController();
  Color _selectedColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    final isDarkModeStatus = ref.watch(isDarkTheme);
    final bgColor = ref.watch(backgroundColor);
    int stColor = bgColor.value;
    _selectedColor = Color(stColor);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(
            "Settings",
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Theme.of(context).brightness != Brightness.dark
                    ? Colors.black
                    : Colors.white),
          ),
        ),
        SliverToBoxAdapter(
            child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Color",
                  style: TextStyle(
                      // color: Color(stColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: GoogleFonts.poppins().fontFamily),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: DropdownButton<Color>(
                    icon: const Icon(LucideIcons.arrowDown),
                    borderRadius: BorderRadius.circular(10),
                    enableFeedback: true,
                    underline: const SizedBox(
                      height: 0,
                    ),
                    isExpanded: false,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    value: _selectedColor,
                    autofocus: false,
                    dropdownColor: Colors.transparent,
                    focusColor: Colors.greenAccent,
                    elevation: 0,
                    iconSize: 0.0,
                    items: backgroundColorList.map(
                      (color) {
                        return DropdownMenuItem<Color>(
                          value: color,
                          child: Container(
                            width: 200,
                            height: 40,
                            color: color,
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (Color? newValue) {
                      setState(
                        () {
                          _selectedColor = newValue!;
                          ref.read(backgroundColor.notifier).state = newValue;
                          SharedPreferencesHelper.setBgColor(newValue);
                        },
                      );
                    },
                  ),
                ),
              ),
              Divider(
                height: 5,
                color: mounted
                    ? Theme.of(context).brightness != Brightness.dark
                        ? Colors.black12
                        : Colors.grey[800]
                    : Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Reset Color",
                      style: TextStyle(
                          // color: Color(stColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: GoogleFonts.poppins().fontFamily),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () async {
                        ref.read(backgroundColor.notifier).state =
                            const Color(0xfff50057);
                        await SharedPreferencesHelper.setBgColor(
                            const Color(0xfff50057));
                      },
                      icon: Icon(
                        LucideIcons.undo2,
                        color: Theme.of(context).brightness != Brightness.dark
                            ? Colors.black54
                            : Colors.white70,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                height: 5,
                color: mounted
                    ? Theme.of(context).brightness != Brightness.dark
                        ? Colors.black12
                        : Colors.grey[800]
                    : Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isDarkModeStatus ? "Dark Mode" : "Light Mode",
                      style: TextStyle(
                          // color: Color(stColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: GoogleFonts.poppins().fontFamily),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () {
                        ref.read(isDarkTheme.notifier).state =
                            !isDarkModeStatus;
                        SharedPreferencesHelper.setThemeStatus(
                            !isDarkModeStatus);
                      },
                      icon: isDarkModeStatus
                          ? Icon(
                              LucideIcons.sun,
                              size: 25,
                              color: Theme.of(context).brightness !=
                                      Brightness.dark
                                  ? Colors.black54
                                  : Colors.white70,
                            )
                          : Icon(
                              LucideIcons.moon,
                              size: 25,
                              color: Theme.of(context).brightness !=
                                      Brightness.dark
                                  ? Colors.black54
                                  : Colors.white70,
                            ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 5,
                color: mounted
                    ? Theme.of(context).brightness != Brightness.dark
                        ? Colors.black12
                        : Colors.grey[800]
                    : Colors.grey,
              ),
            ],
          ),
        )),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}
