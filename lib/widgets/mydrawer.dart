import 'package:flutter/material.dart';
import 'package:notable/screens/notes.dart';
import 'package:notable/screens/app_settings.dart';
import 'package:notable/screens/trash.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Flutter Keep',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                minLeadingWidth: 27,
                leading: const Icon(Icons.lightbulb_outlined),
                title: const Text(
                  'Notes',
                  maxLines: 1,
                ),
                onTap: () =>
                    Navigator.popAndPushNamed(context, Notes.routeName),
              ),
              ListTile(
                minLeadingWidth: 27,
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text(
                  'Trash',
                  maxLines: 1,
                ),
                onTap: () =>
                    Navigator.popAndPushNamed(context, Trash.routeName),
              ),
              ListTile(
                minLeadingWidth: 27,
                leading: const Icon(Icons.settings_outlined),
                title: const Text(
                  'Settings',
                  maxLines: 1,
                ),
                onTap: () =>
                    Navigator.pushNamed(context, AppSettings.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
