import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModeToolsPage extends StatelessWidget {
  final String name;
  const ModeToolsPage({super.key, required this.name});

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit_community/$name');
  }

  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add_mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mod Tools")),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: Text("Add Mods"),
            onTap: () => navigateToAddMods(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text("Edit Community"),
            onTap: () => navigateToEditCommunity(context),
          ),
        ],
      ),
    );
  }
}
