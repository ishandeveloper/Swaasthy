import '../../indicator.dart';
import '../../../services/index.dart';
import '../../../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class ForumPostControls extends StatefulWidget {
  final String postID;
  final int index;
  final bool isExpanded;
  final Function expandHandler;

  const ForumPostControls(
      {this.postID, this.index, this.expandHandler, this.isExpanded, Key key})
      : super(key: key);

  @override
  _ForumPostControlsState createState() => _ForumPostControlsState();
}

class _ForumPostControlsState extends State<ForumPostControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        children: [
          ForumPostControlVotes(postID: widget.postID, index: widget.index),
          const SizedBox(width: 12),
          ForumPostControlComments(
            postID: widget.postID,
            index: widget.index,
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

  const ForumPostControlComments(
      {this.index, this.postID, this.expandHandler, this.isExpanded, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _commentsService =
        Provider.of<RepliesService>(context, listen: false);

    return InkWell(
      onTap: () => expandHandler(),
      child: Container(
        margin: const EdgeInsets.only(top: 0),
        child: Row(
          children: [
            Icon(
              isExpanded ? Icons.mode_comment : Icons.mode_comment_outlined,
              size: 20,
              color: CodeRedColors.icon,
            ),
            Container(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                _commentsService.getCommentsCount(index).toString(),
                style: const TextStyle(fontSize: 16),
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
    final _votesService = Provider.of<UpvotesService>(context, listen: true);

    final isVoted =
        _votesService.getLikes(index: widget.index).contains(user.uid);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 50),
      child: Container(
        margin: const EdgeInsets.only(top: 0),
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
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                _votesService.getLikes(index: widget.index).length.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
