import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCommunityPage extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityPage({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityPageState();
}

class _EditCommunityPageState extends ConsumerState<EditCommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
