import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              elevation: 10,
              shadowColor: Colors.black.withOpacity(1),
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.white
                        : Colors.grey[800]!,
                    width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Change/Reset Theme/Color",
                        style: TextStyle(
                            color: Color(stColor),
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
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
                                ref.read(backgroundColor.notifier).state =
                                    newValue;
                                SharedPreferencesHelper.setBgColor(newValue);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            ref.read(backgroundColor.notifier).state =
                                const Color(0xfff50057);
                            await SharedPreferencesHelper.setBgColor(
                                const Color(0xfff50057));
                          },
                          icon: Icon(
                            LucideIcons.undo2,
                            color: Color(stColor),
                            size: 30,
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
                                    size: 30,
                                    color: Color(stColor),
                                  )
                                : Icon(
                                    LucideIcons.moon,
                                    size: 30,
                                    color: Color(stColor),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}
