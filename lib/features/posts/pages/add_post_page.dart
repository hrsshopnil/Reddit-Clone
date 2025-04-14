import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostPage extends ConsumerWidget {
  const AddPostPage({super.key});

  void navigateToAddPostTypePage(BuildContext context, String type) {
    Routemaster.of(context).push('/add_post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = 120;
    double iconSize = 60;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => navigateToAddPostTypePage(context, 'image'),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Pallete.drawerColor,
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                  color: currentTheme.iconTheme.color,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToAddPostTypePage(context, 'text'),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Pallete.drawerColor,
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.font_download_outlined,
                  size: iconSize,
                  color: currentTheme.iconTheme.color,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToAddPostTypePage(context, 'link'),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Pallete.drawerColor,
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.link_outlined,
                  size: iconSize,
                  color: currentTheme.iconTheme.color,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
