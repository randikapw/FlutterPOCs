import 'dart:async';

class NavHeaderPosition {
  double height,horizontalOffset;
  Duration animationDuration = Duration(milliseconds: 10);
  NavHeaderPosition(this.height, this.horizontalOffset);
}

class Bloc {


  // Key fields - StreamControllers.
  final _navHeaderHorisontalDragController = StreamController<double>();
  final _navHeaderRePositionController = StreamController<NavHeaderPosition>.broadcast();

  // Public constants
  static const double
    MaxNavigatorHeight = 100.0,
    MinNavigatorHeight = 40.0,
    MinNavigatorTop = -20.0,
    MaxNavigatorTop = 25.0;

  final NavHeaderPosition _navHeaderPosition = NavHeaderPosition(MaxNavigatorHeight, 0);

  // Add data to streams
  Function(double) get navHeaderSetSize => (double newSize){
    _navHeaderPosition.height = newSize;
    _navHeaderRePositionController.sink.add(_navHeaderPosition);
  };

  Function(double) get navHeaderSetHorizontalOffset => (double newOffset){
    _navHeaderPosition.horizontalOffset = newOffset;
    _navHeaderRePositionController.sink.add(_navHeaderPosition);
  };


  Function(double, Duration) get setNavHeaderHoffsetWithDuration => (double newOffset, Duration newDuratoin){
    _navHeaderPosition.horizontalOffset = newOffset;
    _navHeaderPosition.animationDuration = newDuratoin;
    _navHeaderRePositionController.sink.add(_navHeaderPosition);
  };

  //get current navHeaderPossition
  NavHeaderPosition get currentNavHeaderPosition => _navHeaderPosition;

  // Streams
  Stream<NavHeaderPosition> get navHeaderConfigs => _navHeaderRePositionController.stream;

//  Stream<double> get navHeaderTop => _navHeaderRePositionController.stream.transform(
//      StreamTransformer<double,double>.fromHandlers(
//        handleData: (data,sink){
//          sink.add(data - MaxNavigatorHeight);
//        }
//  ));

  void dispose(){
      _navHeaderRePositionController.close();
      _navHeaderHorisontalDragController.close();
  }
}