import 'package:codered/screens/indicator.dart';
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
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        children: [
          ForumPostControlVotes(
              postID: this.widget.postID, index: this.widget.index),
          SizedBox(width: 12),
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
              padding: EdgeInsets.only(left: 6),
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

class ForumPostControlVotes extends StatefulWidget {
  final String postID;
  final int index;

  const ForumPostControlVotes({Key key, this.postID, this.index})
      : super(key: key);

  @override
  _ForumPostControlVotesState createState() => _ForumPostControlVotesState();
}

class _ForumPostControlVotesState extends State<ForumPostControlVotes> {
  @override
  Widget build(BuildContext context) {
    UpvotesService _votesService =
        Provider.of<UpvotesService>(context, listen: true);

    bool isVoted =
        _votesService.getLikes(index: widget.index).contains(user.uid);

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 50),
      child: Container(
        margin: EdgeInsets.only(top: 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                ForumsHelper.toggleUpvote(
                    userID: user.uid, postID: widget.postID, isVoted: isVoted);

                _votesService.updateLike(index: widget.index, uid: user.uid);
              },
              child: Icon(
                isVoted
                    ? FontAwesome5Solid.arrow_alt_circle_up
                    : FontAwesome5Regular.arrow_alt_circle_up,
                size: 22,
                color: isVoted ? CodeRedColors.primary : CodeRedColors.icon,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                _votesService
                    .getLikes(index: this.widget.index)
                    .length
                    .toString(),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
