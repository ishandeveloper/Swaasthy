import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/user.dart';
import 'package:codered/screens/auth/signup/gender.dart';
import 'package:codered/screens/indicator.dart';
import 'package:codered/services/router/routes.dart';
import 'package:codered/services/signup_services.dart';
import 'package:codered/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'age.dart';
import 'username.dart';
import 'account_type.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  Animation<double> _progressAnimation;
  AnimationController _progressAnimcontroller;
  PageController pageController;

  double growStepWidth, beginWidth, endWidth = 0.0;
  int totalPages = 4;
  bool _isInitialized;
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
        leading: currentIndex > 0
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.grey[400],
                ),
                onPressed: () {
                  pageController.previousPage(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.ease);
                },
              )
            : null,
        title: Stack(
          children: <Widget>[
            Container(
              height: 15.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8)),
            ),
            AnimatedProgressBar(
              animation: _progressAnimation,
            ),
          ],
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
        children: [UserNamePage(), AgePage(), GenderPage(), AccountType()],
      ),
      floatingActionButton:
          Consumer<SignUpService>(builder: (context, ss, child) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          decoration: BoxDecoration(
              color: ss.active ? CodeRedColors.primary : Colors.grey,
              borderRadius: BorderRadius.circular(10)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus.unfocus();
                }
                if (ss.active) if (pageController.hasClients) {
                  if (currentIndex == totalPages - 1) {
                    user = User(
                        points: 0,
                        email: user.email,
                        uid: user.uid,
                        username: ss.name,
                        age: ss.age,
                        gender: ss.gender,
                        type: ss.accountType);
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set(user.toJson())
                        .then((value) => Navigator.pushNamedAndRemoveUntil(
                            context, CodeRedRoutes.home, (route) => false))
                        .onError((error, stackTrace) => print(error));
                  } else
                    pageController.nextPage(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.ease);
                }
              },
              child: Center(
                child: Text(
                  currentIndex == totalPages - 1 ? 'Finish' : 'NEXT',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          color: CodeRedColors.primary, borderRadius: BorderRadius.circular(8)),
    );
  }
}
