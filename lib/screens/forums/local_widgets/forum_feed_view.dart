import '../../../models/forums/posts.dart';
import 'package:flutter/material.dart';

import 'index.dart';

class ForumFeedView extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final ScrollController scrollController;
  final Function onScroll;

  const ForumFeedView({
    this.snapshot,
    this.scrollController,
    this.onScroll,
    Key key,
  }) : super(key: key);
  @override
  _ForumFeedViewState createState() => _ForumFeedViewState();
}

class _ForumFeedViewState extends State<ForumFeedView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, __) => const Divider(thickness: 5, height: 5),
        itemCount: widget.snapshot.data.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          if (!widget.snapshot.hasData)
            return const CircularProgressIndicator();

          return ForumPost(
              index: index,
              data: ForumPostModel.getModel(
                widget.snapshot.data[index].data(),
                widget.snapshot.data[index].id,
                widget.snapshot.data[index].reference,
              ));
        });
  }
}
