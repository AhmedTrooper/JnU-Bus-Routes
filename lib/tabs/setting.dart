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
                          iconEnabledColor: Color(stColor),
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
                              () async {
                                _selectedColor = newValue!;
                                await SharedPreferencesHelper.setBgColor(
                                    newValue);
                                ref.read(backgroundColor.notifier).state =
                                    newValue;
                              },
                            );
                          },
                        ),
                      ),
                    ),
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
                        onPressed: () async {
                          await SharedPreferencesHelper.setThemeStatus(
                              !isDarkModeStatus);
                          ref.read(isDarkTheme.notifier).state =
                              !isDarkModeStatus;
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
                    const SizedBox(height: 16),
                    ShadForm(
                      key: formKey,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: Column(
                          children: [
                            ShadInputFormField(
                              cursorColor: Color(stColor),
                              controller: _userNameController,
                              autofocus: false,
                              id: 'username',
                              label: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.user,
                                    color: Color(stColor),
                                  ),
                                  Text(
                                    'Profile Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(stColor),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              placeholder:
                                  const Text('Enter your profile name'),
                              description: const Text(
                                "Set up your homepage profile name!",
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.saveAndValidate()) {
                                  if (_userNameController.text.isNotEmpty) {
                                    SharedPreferencesHelper.setUserName(
                                        _userNameController.text);
                                    _userNameController.text = "";
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(stColor),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                fixedSize: const Size(110, 55),
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
