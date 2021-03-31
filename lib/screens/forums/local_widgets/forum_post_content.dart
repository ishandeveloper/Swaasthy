import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class ForumPostContent extends StatelessWidget {
  final String title;
  final String body;

  const ForumPostContent({
    Key key,
    this.title,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12, left: 0),
      child: Column(
        children: [
          Container(
            width: getContextWidth(context),
            padding: EdgeInsets.only(top: 12, left: 8),
            child: Text(this.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          ForumPostRichText(text: this.body)
        ],
      ),
    );
  }
}

class ForumPostRichText extends StatefulWidget {
  final String text;

  ForumPostRichText({Key key, @required this.text}) : super(key: key);

  @override
  _ForumPostRichTextState createState() => _ForumPostRichTextState();
}

class _ForumPostRichTextState extends State<ForumPostRichText>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      //Without this the text will appear horizontally centered
      constraints: BoxConstraints(minWidth: getContextWidth(context)),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: CodeRedColors.background,
          child: Linkify(
            text: widget.text,
            maxLines: 3,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            onOpen: (_) => openURL(_.url, context),
          )),
    );
  }
}
