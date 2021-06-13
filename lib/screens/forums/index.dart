import 'package:flutter/material.dart';

import 'local_widgets/index.dart';

class ForumsScreen extends StatelessWidget {
  final bool refresh;
  const ForumsScreen({@required this.refresh, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ForumsFeed(refresh: refresh);
  }
}
