import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/database/forums.dart';
import '../../../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'index.dart';

class ForumsFeed extends StatefulWidget {
  const ForumsFeed({bool refresh = false, Key key}) : super(key: key);

  @override
  _ForumsFeedState createState() => _ForumsFeedState();
}

class _ForumsFeedState extends State<ForumsFeed> {
  // This variable will contain the total number of feed items available in the snapshot
  int totalFeedItems;

  // This variable contains the max number of items that should currently be displayed to the user based on scroll position
  int feedItemsToDisplay;

  // This controller helps to determine scroll position of Feed
  ScrollController _scrollController;

  // This variable will hold the last fetched document snapshot, so that it can be used to query more data again
  DocumentSnapshot _lastDocument;

  // This variable will hold all the fetched feed snapshots data
  List<DocumentSnapshot> _data;

  bool _fetchingMoreItems = false;

  bool _moreItemsAvailable = true;

  /*
  This function will request more data snapshots from backend, store the 
  last document for future and return snapshots

  [_count] paramter here, defines the total number of posts that we want to display in the feed
           It'll automatically cancel request for pre-existing posts and only fetch the ones
           that are not being displayed currently
  */
  Future<void> requestFeedItems(int _count, {bool refresh = false}) async {
    print('43');
    if (refresh) {
      // Delete all the existing data for comments and likes, when refreshed

      netSensitiveCall(
          context: context,
          callback: () {
            ForumsHelper.resetInteractions();
          });

      setState(() => _data = null);
      // return Future.value(true);
    }

    // If already fetching items in callstack, then don't fetch again
    if (_fetchingMoreItems) return;

    setState(() => _fetchingMoreItems = true);

    //  Ensures that only non-existing snapshots are being requested
    if (_data != null)
      _count = _count - _data.length > 0
          ? _count - _data.length
          : 1; //For fetch request a minimum of 1 snapshot must be there

    // This will get & temporary store a limited number of snapshots
    final _ = await ForumsHelper.getLimitedSnapshots(_count,
        lastDocument: _lastDocument);

    if (_.docs.length < 3) _moreItemsAvailable = false;

    // If this is the inital call for fetching data or no data is there currently [refresh]
    if (_data == null) {
      setState(() {
        _data = _.docs;
        _lastDocument = _?.docs?.last;
        feedItemsToDisplay = _?.docs?.length;
        _fetchingMoreItems = false;
      });
    }

    // Only add snapshot changes if more document snapshots exist & are not pre-existing
    else if (_data != null &&
        _.docs.length > 0 &&
        _.docs.last != _lastDocument) {
      print('87');
      setState(() {
        _lastDocument = _.docs.last;
        _data = [..._data, ..._.docs];
        _fetchingMoreItems = false;
        feedItemsToDisplay = _data?.length;
      });
    }

    if (refresh) setState(() => _moreItemsAvailable = true);
  }

  /* 
  This function listens to the updates of user's scroll position and
  determines how many items should be displayed
  */
  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // double delta = getContextHeight(context) * 0.25;
    const delta = 1000;

    // If no more items are available then do not fetch more
    if (maxScroll - currentScroll <= delta && _moreItemsAvailable)
      requestFeedItems(feedItemsToDisplay + 3);
  }

/*
  This function accepts position of a new comment textbox and 
  scrolls the feed listview to the desired height
*/
  void scrollToComment(double _) {
    var _height = getContextHeight(context) - getKeyboardHeight(context) - 400;

    _height = _ + _scrollController.offset - _height;

    // To ensure this does not trigger a pull to refresh on iOS
    if (_height > 0)
      _scrollController.animateTo(_height,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void dispose() {
    // Removes the position update listener from scroll controller
    _scrollController.removeListener(_scrollListener);

    // Disposes the scroll controller, to free up memory resources
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    ForumsHelper.resetInteractions();

    //Let's assume initially we will at least 3 posts, so that app does not throw up an error
    if (feedItemsToDisplay == null) feedItemsToDisplay = 5;

    // Initializes the scroll controller and adds a listener to check for scroll updates
    _scrollController = ScrollController(keepScrollOffset: true);
    _scrollController.addListener(_scrollListener);

    // This method will request feed items data initially on the start
    requestFeedItems(feedItemsToDisplay);
  }

  Future<dynamic> requestInteractionSnapshots(
      AsyncSnapshot snapshot, BuildContext context) async {
    final int _items = snapshot.data.length;

    for (var i = 0; i < _items; i++) {
      ForumsHelper.getInteractions(
          snapshot.data[i].id,
          i,
          snapshot.data[i].data()['upvotes_count'],
          snapshot.data[i].data()['replies_count'],
          context);

      if (i == _items - 1) {
        return Future.value(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: isKeyboardVisible(context)
      //     ? null
      //     : FloatingActionButton(
      //         backgroundColor: CodeRedColors.primary2,
      //         onPressed: () => netSensitiveCall(
      //             context: context,
      //             callback: () => Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => NewForumPost()))),
      //         child: Icon(Icons.add, size: 32),
      //       ),
      body: FutureBuilder(
        future: Future.value(_data),
        builder: (context, snapshot) {
          //If there is an error
          // if (snapshot.hasError) return ErrorWidget();

          return RefreshIndicator(
              color: CodeRedColors.primary,
              onRefresh: () => requestFeedItems(5, refresh: true),
              child: SingleChildScrollView(
                controller: _scrollController,
                key: const PageStorageKey('FORUMS'),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const ForumsTitle(),
                    // If no data is found in Firestore or is still loading
                    if (!snapshot.hasData)
                      const ShimmeringList()
                    else
                      FutureBuilder(
                          future:
                              requestInteractionSnapshots(snapshot, context),
                          builder: (_, intSnapshot) {
                            if (!intSnapshot.hasData)
                              return const ShimmeringList();

                            return ForumFeedView(
                                onScroll: scrollToComment, snapshot: snapshot);
                          }),

                    const Padding(padding: EdgeInsets.only(bottom: 20))
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class ForumsTitle extends StatelessWidget {
  const ForumsTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Forums',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              fontFamily: 'ProductSans',
            ),
          ),
          FloatingActionButton(
            mini: true,
            onPressed: () => Navigator.pushNamed(context, '/newpost'),
            backgroundColor: CodeRedColors.primary,
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

class ShimmeringList extends StatelessWidget {
  const ShimmeringList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: getContextWidth(context),
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Shimmer.fromColors(
            direction: ShimmerDirection.ttb,
            child: ListView.builder(
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              color: Colors.grey[400],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: getContextWidth(context) - 100,
                                  height: 10,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: getContextWidth(context) - 100,
                                  height: 10,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: getContextWidth(context) - 100,
                                  height: 10,
                                  color: Colors.grey[400],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 300,
                          width: getContextWidth(context) - 32,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  );
                }),
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[100]));
  }
}
