import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/widgets/error_text.dart';
import 'package:reddit_clone/core/widgets/loader.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';
import 'package:reddit_clone/features/community/viewmodel/community_viewmodel.dart';

class AddModsPage extends ConsumerStatefulWidget {
  final String name;
  const AddModsPage({super.key, required this.name});

  @override
  ConsumerState<AddModsPage> createState() => _AddModsPageState();
}

class _AddModsPageState extends ConsumerState<AddModsPage> {
  Set<String> uids = {};
  bool initialized = false;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref
        .read(communityViewModelProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    final communityAsync = ref.watch(getCommunityByNameProvider(widget.name));

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: saveMods, icon: const Icon(Icons.done)),
        ],
      ),
      body: communityAsync.when(
        data: (community) {
          // 👇 Initialize mods just once
          if (!initialized) {
            uids = {...community.mods};
            initialized = true;
          }

          return ListView.builder(
            itemCount: community.members.length,
            itemBuilder: (context, index) {
              final member = community.members[index];

              final userAsync = ref.watch(getUserDataProvider(member));

              return userAsync.when(
                data: (user) {
                  return CheckboxListTile(
                    value: uids.contains(user.uid),
                    onChanged: (val) {
                      if (val == true) {
                        addUid(user.uid);
                      } else {
                        removeUid(user.uid);
                      }
                    },
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                        ),
                        const SizedBox(width: 10),
                        Text(user.name),
                      ],
                    ),
                  );
                },
                error:
                    (error, stackTrace) => ErrorText(error: error.toString()),
                loading: () => const Loader(),
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
