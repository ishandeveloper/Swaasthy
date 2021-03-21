import 'package:flutter/material.dart';

import 'local_widgets/index.dart';

class ForumsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ForumsFeed();
    // return Scaffold(
    //   body: SingleChildScrollView(
    //     child: Container(
    //       // padding: EdgeInsets.symmetric(horizontal: 16),
    //       child: Column(
    //         children: [
    //           SizedBox(height: 24),
    //           Container(
    //             padding: EdgeInsets.symmetric(horizontal: 16),
    //             child: Row(
    //               children: [
    //                 Text(
    //                   'Forums',
    //                   style: TextStyle(
    //                     fontSize: 28,
    //                     fontWeight: FontWeight.w600,
    //                     fontFamily: 'ProductSans',
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           SizedBox(height: 32),
    //           ForumsFeed()
    //           // FutureBuilder(
    //           //     future: ForumsHelper.getPosts(),
    //           //     builder: (BuildContext context, snapshot) {
    //           //       if (!snapshot.hasData) return CircularProgressIndicator();

    //           //       return ListView.builder(
    //           //           itemCount: snapshot.data.length,
    //           //           physics: NeverScrollableScrollPhysics(),
    //           //           shrinkWrap: true,
    //           //           itemBuilder: (BuildContext context, int index) {
    //           //             return ForumPost(data: snapshot.data[index]);
    //           //           });
    //           //     })
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
