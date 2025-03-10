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
          child: SizedBox(height: 20),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<Color>(
                value: _selectedColor,
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
                      await SharedPreferencesHelper.setBgColor(newValue);
                      ref.read(backgroundColor.notifier).state = newValue;
                    },
                  );
                },
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
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
                    IconButton(
                      onPressed: () async {
                        ref.read(backgroundColor.notifier).state =
                            Colors.blueAccent;
                        await SharedPreferencesHelper.setBgColor(
                            Colors.blueAccent);
                      },
                      icon: Icon(
                        LucideIcons.redo,
                        color: isDarkModeStatus ? Colors.white : Color(stColor),
                        size: 35,
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
                            ? const Icon(
                                LucideIcons.sun,
                                size: 35,
                                color: Colors.white,
                              )
                            : Icon(
                                LucideIcons.moon,
                                size: 35,
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
                                    'Username',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(stColor),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              placeholder: const Text('Enter your username'),
                              description: const Text(
                                "Set up you homepage profile",
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
                                fixedSize: const Size(120, 60),
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
        )
      ],
    );
  }
}
