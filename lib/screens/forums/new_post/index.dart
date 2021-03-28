import 'package:codered/models/index.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

import '../../index.dart';

class NewForumPost extends StatefulWidget {
  @override
  _NewForumPostState createState() => _NewForumPostState();
}

class _NewForumPostState extends State<NewForumPost> {
  bool isValid = false;

  Asset _selectedImage;

  TextEditingController _plainTextController = TextEditingController();
  TextEditingController _titleTextController = TextEditingController();

  _plainTextHandler(_) {
    // If User is not allowed to post, and updated string is not empty,
    // Then allow the user to post

    if (_.length == 0 && isValid)
      setState(() => isValid = false);
    else if (_.length > 0 &&
        _titleTextController.value.text.length > 0 &&
        !isValid) setState(() => isValid = true);
  }

  _titleTextHandler(_) {
    // If User is not allowed to post, and updated string is not empty,
    // Then allow the user to post

    if (_.length == 0 && isValid)
      setState(() => isValid = false);
    else if (_.length > 0 &&
        _plainTextController.value.text.length > 0 &&
        !isValid) setState(() => isValid = true);
  }

  @override
  void dispose() {
    _plainTextController.dispose();
    _titleTextController.dispose();
    super.dispose();
  }

  void _postSubmitHandler() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PostUpload(
                image: _selectedImage,
                title: _titleTextController.value.text.toString(),
                body: _plainTextController.value.text,
                user: PostUserModel(
                    userID: "qUOmsgFAwKPHaBSAWTnLah7sjMd2", //TODO:ADD USER ID
                    username: 'ishandeveloper',
                    userimage:
                        'https://avatars.githubusercontent.com/u/54989142?s=460&u=dae5bd5b626e6e4ed70d23fe25d1eba5d510efc6&v=4'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _buildBottomSheet(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 8.0,
                right: 16,
                top: 16,
                bottom: isKeyboardVisible(context) ? 72 : 0),
            child: Column(
              children: [
                NewPostHeader(isValid: isValid, onClick: _postSubmitHandler),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: TextField(
                      maxLines: 1,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: false,
                      style: const TextStyle(
                          fontSize: 18, fontFamily: 'ProductSans'),
                      onChanged: _titleTextHandler,
                      controller: _titleTextController,
                      decoration: const InputDecoration(
                          hintText: "Give it a title..",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none),
                    )),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      //If keyboard is not visible, maximum height 0f 500
                      maxHeight: !isKeyboardVisible(context)
                          ? 500
                          // else if keyboard is visible, calculate height for sticky keyboard

                          : getContextHeight(context) -
                              getKeyboardHeight(context) -
                              260),
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, bottom: 8, top: 0),
                      child: TextField(
                        // If Post Is Single Image, Multi Image, Link
                        // or Video type, restrict the text area
                        maxLines: 12, minLines: 12,
                        textCapitalization: TextCapitalization.sentences,
                        autofocus: false,
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'ProductSans'),

                        onChanged: _plainTextHandler,
                        controller: _plainTextController,

                        decoration: const InputDecoration(
                            hintText: "What's on your mind?",
                            border: InputBorder.none),
                      )),
                ),
                if (_selectedImage != null)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: getContextWidth(context) - 16,
                                maxHeight: getContextWidth(context) - 16),
                            child: FittedBox(
                              child: AssetThumb(
                                asset: _selectedImage,
                                width: (getContextWidth(context)).toInt(),
                                // height: (getContextWidth(context) * 0.5).toInt(),
                                height: (getContextWidth(context) *
                                        (_selectedImage.originalWidth /
                                            _selectedImage.originalHeight))
                                    .toInt(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 2,
                          right: 2,
                          child: FloatingActionButton(
                            onPressed: () =>
                                setState(() => _selectedImage = null),
                            child: Icon(Icons.close,
                                size: 20, color: Colors.black),
                            splashColor: Colors.white,
                            mini: true,
                            backgroundColor:
                                Color.fromRGBO(255, 255, 255, 0.75),
                          ))
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildBottomSheet() {
    if ((getKeyboardHeight(context) == 0)) {
      return Container(
        decoration: BoxDecoration(
            color: Color(0xffFFFFFF),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 3,
                  spreadRadius: 0.1)
            ]),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ExpandedSheetItem(
            icon: Icons.camera_alt,
            iconColor: Colors.blue,
            onClick: () => _pickImage(),
            text: "Image",
          ),
          ExpandedSheetItem(
            icon: Icons.videocam,
            iconColor: Colors.red,
            onClick: () => _pickVideo(),
            text: "Video",
          ),
        ]),
      );
    }
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 1,
                spreadRadius: 0.1)
          ]),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.camera_alt, size: 24, color: Colors.blue),
                  onPressed: () => _pickImage()),
              IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.videocam, size: 28, color: Colors.red),
                  onPressed: () => _pickVideo()),
            ],
          ),
          IconButton(
              icon: Icon(Icons.keyboard_hide, color: Colors.grey[600]),
              onPressed: () {
                FocusScope.of(context).unfocus();
              })
        ],
      ),
    );
  }

  void _pickImage() async {
    // if (hasShownDiscardedAlert) hasShownDiscardedAlert = false;

    List<Asset> _selection = [];
    // bool _areImagesDiscarded = false;
    try {
      _selection = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: true,
          materialOptions: MaterialOptions(
            actionBarTitle: "Choose Image",
            useDetailsView: false,
            actionBarColor: "#EE466E",
            statusBarColor: "#EE466E",
            selectCircleStrokeColor: "#000000",
          ));
    } on Exception catch (e) {
      print("[!] : $e");
    }

    if (_selection.length > 0) {
      setState(() => _selectedImage = _selection[0]);
    }
  }

  void _pickVideo() async {
    // File _ = await FilePicker.getFile(type: FileType.video);

    // try {
    //   if (await _.exists()) {
    //     final String _thumb = await VideoThumbnail.thumbnailFile(
    //         video: _.path,
    //         thumbnailPath: (await getTemporaryDirectory()).path,
    //         imageFormat: ImageFormat.PNG,
    //         quality: 50);

    //     // INITIALIZE VIDEO CONTROLLER FOR DURATION
    //     _videoController = CachedVideoPlayerController.file(_)
    //       ..initialize().then((value) => setState(() {
    //             _videoFile = _;
    //             _videoThumbnail = _thumb;
    //             _postType = FeedType.video;
    //           }));

    //     _videoController.setVolume(0);
    //   }
    // } on Exception catch (e) {
    //   print("[!] : $e");
    // }
  }
}

class ExpandedSheetItem extends StatelessWidget {
  final IconData icon;
  final Function onClick;
  final String text;
  final Color iconColor;

  ExpandedSheetItem(
      {this.icon, this.onClick, this.text, this.iconColor = Colors.black});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: this.onClick,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              this.icon,
              size: 24,
              color: this.iconColor,
            ),
            SizedBox(width: 15),
            Text(this.text,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProductSans',
                    color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class NewPostHeader extends StatelessWidget {
  const NewPostHeader({
    Key key,
    @required this.isValid,
    @required this.onClick,
  }) : super(key: key);

  final bool isValid;

  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  color: CodeRedColors.icon,
                  iconSize: 24,
                  splashRadius: 20,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
              SizedBox(width: 8),
              Text(
                'New Post',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'ProductSans',
                ),
              ),
            ],
          ),
          if (isValid)
            FloatingActionButton(
              mini: true,
              onPressed: onClick,
              backgroundColor: CodeRedColors.primary,
              child: Icon(Icons.check),
            )
        ],
      ),
    );
  }
}
