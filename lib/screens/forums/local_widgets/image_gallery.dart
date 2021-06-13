import 'package:cached_network_image/cached_network_image.dart';
import '../../../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGalleryView extends StatefulWidget {
  // Accepts a list of image urls
  final List<String> images;

  // Accepts the current index of the image
  final int currentIndex;

  const ImageGalleryView(
      {@required this.images, this.currentIndex = 0, Key key})
      : super(key: key);

  @override
  _ImageGalleryViewState createState() => _ImageGalleryViewState();
}

class _ImageGalleryViewState extends State<ImageGalleryView> {
  // Tracks the current index of the focused gallery image
  int _current;

  @override
  void initState() {
    _current = widget.currentIndex + 1;
    // DARK STATUS BAR
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light),
    );
    super.initState();
  }

  @override
  void dispose() {
    // LIGHT STATUS BAR
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: (e) {
          if (e.delta.dy > 2.5) Navigator.pop(context);
        },
        child: Container(
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                  customSize: MediaQuery.of(context).size,
                  onPageChanged: (index) =>
                      setState(() => _current = index + 1),
                  pageController:
                      PageController(initialPage: widget.currentIndex),
                  scrollPhysics: const BouncingScrollPhysics(),
                  itemCount: widget.images.length,
                  builder: buildGalleryImage,
                  loadingBuilder: (context, event) => const Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(CodeRedColors.primary)),
                      )),
              const GalleryBackButton(),
              Positioned(
                bottom: 20,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                        child: Text(
                          '${_current.toString()} of ${widget.images.length}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds a gallery image widget
  PhotoViewGalleryPageOptions buildGalleryImage(
      BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: CachedNetworkImageProvider(widget.images[index]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 3,
    );
  }
}

class GalleryBackButton extends StatelessWidget {
  const GalleryBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: SafeArea(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.5),
              borderRadius: BorderRadius.circular(25)),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
