import 'dart:async';
import 'package:flutter/foundation.dart';

class EntryChangeNotifier extends ChangeNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get stream => _controller.stream;

  void notifyListeners() {
    super.notifyListeners();
    _controller.add(null);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
