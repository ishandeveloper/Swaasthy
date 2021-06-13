import 'package:cached_network_image/cached_network_image.dart';
import '../../../services/index.dart';
import '../../../utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timeago/timeago.dart' as timeago;

class ForumPostComments extends StatefulWidget {
  final String postID;
  final int index;
  final Function moreComments;

  const ForumPostComments({Key key, this.postID, this.index, this.moreComments})
      : super(key: key);

  @override
  _ForumPostCommentsState createState() => _ForumPostCommentsState();
}

class _ForumPostCommentsState extends State<ForumPostComments> {
  @override
  Widget build(BuildContext context) {
    final _commentsService =
        Provider.of<RepliesService>(context, listen: false);

    final _replies = _commentsService.getComments(index: widget.index);

    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _replies?.length,
          itemBuilder: (BuildContext context, index) {
            final _reply = _replies[index];

            return Container(
              color: index % 2 != 0
                  ? const Color(0xffF5F5F5)
                  : const Color(0xffFFFFFF),
              padding:
                  const EdgeInsets.only(top: 6, left: 12, right: 6, bottom: 6),
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        CachedNetworkImageProvider(_reply.user.userimage),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(_reply.user.username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 4),
                            Text(_reply.body),
                          ],
                        ),
                        Text(
                          timeago.format(_reply.timestamp.toDate()),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 12, color: CodeRedColors.icon),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        if (_replies.length < _commentsService.getCommentsCount(widget.index))
          Container(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        primary: CodeRedColors.primary),
                    onPressed: widget.moreComments,
                    child: const Text('View more comments'),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
