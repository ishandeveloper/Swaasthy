import 'package:codered/services/index.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class ForumPostControls extends StatefulWidget {
  final String postID;
  final int index;
  final bool isExpanded;
  final Function expandHandler;

  ForumPostControls({
    this.postID,
    this.index,
    this.expandHandler,
    this.isExpanded,
  });

  @override
  _ForumPostControlsState createState() => _ForumPostControlsState();
}

class _ForumPostControlsState extends State<ForumPostControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ForumPostControlVotes(
              postID: this.widget.postID, index: this.widget.index),
          SizedBox(width: 20),
          ForumPostControlComments(
            postID: this.widget.postID,
            index: this.widget.index,
            isExpanded: widget.isExpanded,
            expandHandler: widget.expandHandler,
          ),
        ],
      ),
    );
  }
}

class ForumPostControlComments extends StatelessWidget {
  final String postID;
  final int index;
  final bool isExpanded;
  final Function expandHandler;

  ForumPostControlComments({
    this.index,
    this.postID,
    this.expandHandler,
    this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    RepliesService _commentsService =
        Provider.of<RepliesService>(context, listen: false);

    return InkWell(
      onTap: () => expandHandler(),
      child: Container(
        margin: EdgeInsets.only(top: 0),
        child: Row(
          children: [
            Icon(
              isExpanded ? Icons.mode_comment : Icons.mode_comment_outlined,
              size: 20,
              color: CodeRedColors.icon,
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                _commentsService.getCommentsCount(this.index).toString(),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumPostControlVotes extends StatelessWidget {
  final String postID;
  final int index;

  const ForumPostControlVotes({Key key, this.postID, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UpvotesService _votesService =
        Provider.of<UpvotesService>(context, listen: false);

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 50),
      child: Container(
        margin: EdgeInsets.only(top: 0),
        child: Row(
          children: [
            Icon(
              Octicons.arrow_up,
              size: 22,
              color: CodeRedColors.icon,
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                _votesService.getLikes(index: this.index).length.toString(),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
