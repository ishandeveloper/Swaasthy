/*
  This service is responsible for keeping track of the current page in home 
  bottom navigation
*/

import 'package:flutter/material.dart';

class ScreensWrapperService with ChangeNotifier {
  int _currentIndex = 0;

  int getIndex() {
    print('getIndex-Called : $_currentIndex');
    return _currentIndex;
  }

  void changeIndex(int _) {
    _currentIndex = _;
    notifyListeners();
  }
}
