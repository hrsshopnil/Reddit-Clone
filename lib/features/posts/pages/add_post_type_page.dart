import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/theme/pallete.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/core/widgets/error_text.dart';
import 'package:reddit_clone/core/widgets/loader.dart';
import 'package:reddit_clone/features/community/model/community_model.dart';
import 'package:reddit_clone/features/community/viewmodel/community_viewmodel.dart';
import 'package:reddit_clone/features/posts/viewmodel/add_post_viewmodel.dart';

class AddPostTypePage extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypePage({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypePageState();
}

class _AddPostTypePageState extends ConsumerState<AddPostTypePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  List<Community> communities = [];
  Community? selectedCommunity;

  File? postImage;
  void selectPostImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        postImage = File(res.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.type}'),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedCommunity != null) {
                if (isTypeText) {
                  ref
                      .read(addPostViewModelProvider.notifier)
                      .shareTextPost(
                        context,
                        titleController.text,
                        selectedCommunity!,
                        descriptionController.text,
                      );
                } else if (isTypeLink) {
                  ref
                      .read(addPostViewModelProvider.notifier)
                      .shareLinkPost(
                        context: context,
                        title: titleController.text,
                        selectedCommunity: selectedCommunity!,
                        link: linkController.text,
                      );
                }
              } else {
                showSnackBar(context, 'Please select a community');
              }
            },
            child: Text('Share'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Pallete.drawerColor,
                hintText: 'Enter you title',
                hintStyle: TextStyle(color: Colors.white), // 👈 light grey hint

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Pallete.blueColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  // or any color
                  borderRadius: BorderRadius.circular(10), // more rounded
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
              style: TextStyle(color: Colors.white),
              maxLength: 30,
            ),
          ),
          SizedBox(height: 10),
          if (isTypeImage)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () => selectPostImage(),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: [10, 4],
                  strokeCap: StrokeCap.round,
                  color: Pallete.darkModeAppTheme.textTheme.bodyLarge!.color!,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        postImage != null
                            ? Image.file(postImage!, fit: BoxFit.cover)
                            : const Center(
                              child: Icon(Icons.camera_alt_outlined, size: 40),
                            ),
                  ),
                ),
              ),
            ),
          if (isTypeText)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Pallete.drawerColor,
                  hintText: 'Enter you Description',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ), // 👈 light grey hint

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Pallete.blueColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // or any color
                    borderRadius: BorderRadius.circular(10), // more rounded
                  ),
                  contentPadding: const EdgeInsets.all(18),
                ),
                style: TextStyle(color: Colors.white),
                maxLines: 5,
              ),
            ),
          if (isTypeLink)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: linkController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Pallete.drawerColor,
                  hintText: 'Enter you link',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ), // 👈 light grey hint

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Pallete.blueColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // or any color
                    borderRadius: BorderRadius.circular(10), // more rounded
                  ),
                  contentPadding: const EdgeInsets.all(18),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.topLeft,
            child: Text('Select Community'),
          ),
          ref
              .watch(userCommunitiesProvider)
              .when(
                data: (data) {
                  communities = data;

                  if (data.isEmpty) {
                    return const SizedBox();
                  }

                  return DropdownButton(
                    value: selectedCommunity ?? data[0],
                    items:
                        data
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundImage: NetworkImage(e.avatar),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(e.name),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCommunity = val;
                      });
                    },
                  );
                },
                error:
                    (error, stackTrace) => ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
