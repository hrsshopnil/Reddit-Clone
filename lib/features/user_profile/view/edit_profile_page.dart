import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/theme/pallete.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final String uid;
  const EditProfilePage({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(getUserDataProvider(widget.uid))
        .when(
          data:
              (community) => Scaffold(
                //backgroundColor: Pallete.greyColor,
                appBar: AppBar(
                  title: const Text('Edit Community'),
                  centerTitle: false,
                  actions: [
                    TextButton(onPressed: () {}, child: const Text('Save')),
                    const SizedBox(width: 10),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () => selectBannerImage(),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: [10, 4],
                                strokeCap: StrokeCap.round,
                                color:
                                    Pallete
                                        .darkModeAppTheme
                                        .textTheme
                                        .bodyLarge!
                                        .color!,
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                      bannerFile != null
                                          ? Image.file(
                                            bannerFile!,
                                            fit: BoxFit.cover,
                                          )
                                          : community.banner.isEmpty ||
                                              community.banner ==
                                                  Constants.bannerDefault
                                          ? const Center(
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 40,
                                            ),
                                          )
                                          : Image.network(community.banner),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: GestureDetector(
                                onTap: () => selectProfileImage(),
                                child: CircleAvatar(
                                  backgroundImage:
                                      profileFile != null
                                          ? FileImage(profileFile!)
                                          : NetworkImage(community.profilePic),
                                  radius: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Pallete.drawerColor,
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ), // 👈 light grey hint

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Pallete.blueColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // or any color
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // more rounded
                          ),
                          contentPadding: const EdgeInsets.all(18),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Text('Loading'),
        );
  }
}
