import 'package:codered/screens/auth/signup/password.dart';
import 'package:flutter/material.dart';

import 'email.dart';
import 'name.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  Animation<double> _progressAnimation;
  AnimationController _progressAnimcontroller;
  PageController pageController;

  double growStepWidth, beginWidth, endWidth = 0.0;
  int totalPages = 3;
  bool _isInitialized;
  bool active = false;
  String name, email, password, error;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: 0);

    /// Attach a listener which will update the state and refresh the page index
    pageController.addListener(() {
      if (pageController.page.round() != currentIndex) {
        setState(() {
          currentIndex = pageController.page.round();
        });
      }
    });

    _progressAnimcontroller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: beginWidth, end: endWidth)
        .animate(_progressAnimcontroller);

    _setProgressAnimation(0, 1);
  }

  @override
  void didChangeDependencies() {
    if (this._isInitialized == null || !this._isInitialized) {
      var mediaQD = MediaQuery.of(context);
      var maxWidth = mediaQD.size.width;
      _setProgressAnimation(maxWidth, 1);
      this._isInitialized = true;
    }

    super.didChangeDependencies();
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  _setProgressAnimation(double maxWidth, int curPageIndex) {
    setState(() {
      growStepWidth = maxWidth / totalPages;
      beginWidth = growStepWidth * (curPageIndex - 1);
      endWidth = growStepWidth * curPageIndex;

      _progressAnimation = Tween<double>(begin: beginWidth, end: endWidth)
          .animate(_progressAnimcontroller);
    });

    _progressAnimcontroller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQD = MediaQuery.of(context);
    var maxWidth = mediaQD.size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            currentIndex == 0
                ? Icons.arrow_back_ios_outlined
                : Icons.close_rounded,
            color: Colors.blueGrey,
          ),
          onPressed: () {},
        ),
        title: Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: 15.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(8)),
              ),
              AnimatedProgressBar(
                animation: _progressAnimation,
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (i) {
          //index i starts from 0!
          // _progressAnimcontroller.reset(); //reset the animation first
          _setProgressAnimation(maxWidth, i + 1);
        },
        physics: NeverScrollableScrollPhysics(),
        children: [
          NamePage(
            pageController: pageController,
            name: name,
          ),
          EmailPage(
            pageController: pageController,
            email: email,
            name: name,
          ),
          PasswordPage(),
        ],
      ),
    );
  }
}

class AnimatedProgressBar extends AnimatedWidget {
  AnimatedProgressBar({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return AnimatedContainer(
      height: 15.0,
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
      width: animation.value,
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(8)),
    );
  }
}
