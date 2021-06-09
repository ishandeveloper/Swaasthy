import 'package:flutter/material.dart';

import 'local_widgets/index.dart';

class ForumsScreen extends StatelessWidget {
  final bool refresh;
  ForumsScreen({required this.refresh});

  @override
  Widget build(BuildContext context) {
    return ForumsFeed(refresh: refresh);
  }
}
