import 'package:cached_network_image/cached_network_image.dart';
import 'package:codered/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:another_flushbar/flushbar.dart';

// Checks if the keyboard is visible on user screen or in a dismissed state
bool isKeyboardVisible(BuildContext context) {
  if (MediaQuery.of(context).viewInsets.bottom == 0) return false;
  return true;
}

// Returns the maximum available context height
double getContextHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

// Returns the maximum height of keyboard
double getKeyboardHeight(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}

// Returns the maximum available context width
double getContextWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// Returns a CachedNetworkProvider Image
ImageProvider getImage(String url) {
  return CachedNetworkImageProvider(url);
}

// Takes text and maxLines as parameter and returns a boolean, about whether
// text exceeds maxLines or not
bool doesExceedsMaxLines(BuildContext context, String text, int maxLines) {
  final span = TextSpan(text: text, style: TextStyle(fontSize: 16));

  final tp = TextPainter(
      text: span, maxLines: maxLines, textDirection: TextDirection.ltr);
  tp.layout(maxWidth: MediaQuery.of(context).size.width);
  if (tp.didExceedMaxLines) return true;

  return false;
}

// Takes String url as a parameter and opens them in a webview
void openURL(String url, BuildContext context) async {
  // If PDF then open PDF Preview
  if (url.toString().endsWith('.pdf'))
    //HandlePDF
    print("PDF");
  else if (url.toString().contains('.pdf')) {
    try {
      RegExp _queryNeglector = RegExp(r"([^\?]+)(\?.*)?");
      if (_queryNeglector.firstMatch(url.toString()).group(1) != null) {
        // Handle PDF
      } else {
        if (await canLaunch(url))
          await launch(url, forceWebView: true, enableJavaScript: true);
      }
    } catch (e) {
      if (await canLaunch(url))
        await launch(url, forceWebView: true, enableJavaScript: true);
    }
  }

  // Else open webview
  else {
    // if (Platform.isIOS) {
    if (await canLaunch(url))
      await launch(url, forceWebView: true, enableJavaScript: true);
    // } else {
    //   await showModalBottomSheet(
    //       isDismissible: false,
    //       enableDrag: false,
    //       isScrollControlled: true,
    //       context: context,
    //       builder: (_) => Container(
    //             color: FeedColors.feedBackgroundColor,
    //             padding: const EdgeInsets.only(top: 40.0),
    //             child: SafeArea(child: CustomWebView(url: url)),
    //           ));
    // }
  }
}

void openURLinBrowser(String url) async {
  if (await canLaunch(url))
    await launch(url, forceWebView: false, enableJavaScript: true);
}

/*
  Accepts a string message and displays a snackbar
*/
void displaySnackbar(BuildContext context, String message) {
  Flushbar(
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
    messageText: Row(
      children: [
        const Icon(Icons.error, color: Colors.white, size: 24),
        const SizedBox(width: 10),
        Flexible(
            child: Text(message,
                style: TextStyle(color: Colors.white, fontSize: 14))),
      ],
    ),
    backgroundColor: CodeRedColors.primary,
    duration: Duration(seconds: 2),
  )..show(context);
}
