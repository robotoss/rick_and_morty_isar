import 'package:flutter/widgets.dart';

class AppState extends ChangeNotifier {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  void setAppInit() {
    _isInitialized = true;
    notifyListeners();
  }
}
