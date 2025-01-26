import 'package:flutter/material.dart';
import 'package:pdf_hub/app/app_const.dart';
import 'package:pdf_hub/app/app_key_value.dart';
import 'package:pdf_hub/my_shared_preferences.dart';

class SettingsApp extends StatefulWidget {
  const SettingsApp({super.key});

  @override
  State<SettingsApp> createState() => _SettingsAppState();
}

class _SettingsAppState extends State<SettingsApp> {
  static const menuItems = <String>[
    nameFirstPagesHistory,
    nameFirstPagesFolder
  ];
  // String _history = 'history';
  // String _folder = 'folder';

  var _firstPages = AppKeyValue.settingsValueFirstPages;
  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // color: Colors.white,
      height: 400,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: theme.canvasColor,
          //Theme.of(context).cardColor,
          border: Border.all(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(18.0)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Стартовый экран',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            trailing: DropdownButton<String>(
                dropdownColor: theme.canvasColor,
                borderRadius: BorderRadius.circular(10.0),
                items: _dropDownMenuItems,
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    await MySharedPreferences().setFirstPage(
                        AppKeyValue.settingsKeyFirstPages, newValue);
                    setState(() {
                      _firstPages = newValue;
                    });
                  }
                },
                value: _firstPages),
          )
        ],
      ),
    );
  }
}
