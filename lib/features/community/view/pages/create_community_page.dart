import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/theme/pallete.dart';
import 'package:reddit_clone/core/widgets/loader.dart';
import 'package:reddit_clone/features/community/viewmodel/community_viewmodel.dart';

class CreateCommunityPage extends ConsumerStatefulWidget {
  const CreateCommunityPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityPageState();
}

class _CreateCommunityPageState extends ConsumerState<CreateCommunityPage> {
  final TextEditingController communityName = TextEditingController();

  @override
  void dispose() {
    communityName.dispose();
    super.dispose();
  }

  void createCommunity() {
    ref
        .read(communityViewModelProvider.notifier)
        .createCommunity(communityName.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityViewModelProvider);
    return isLoading
        ? Loader()
        : Scaffold(
          appBar: AppBar(title: const Text('Create a community')),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Community Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: communityName,
                  decoration: InputDecoration(
                    hintText: 'r/Community_name',

                    filled: true,
                    fillColor: Pallete.drawerColor,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLength: 21,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => createCommunity(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                    foregroundColor: Pallete.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Create Community",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
