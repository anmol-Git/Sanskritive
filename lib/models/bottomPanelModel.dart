import 'package:flutter/material.dart';

class BottomPanelModel with ChangeNotifier {
  int index = 0;

  int get ind {
    return index;
  }

  void setInd(int ind) {
    index = ind;
    notifyListeners();
  }
}
