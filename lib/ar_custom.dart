import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ArCustom extends StatefulWidget {
  @override
  _ArCustomState createState() => _ArCustomState();
}

class _ArCustomState extends State<ArCustom> {
  ArCoreController _arCoreController;
  String _model = 'AndroidRobot';
  int _count = 0;

  @override
  void dispose() {
    _arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(_model)),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
          // enableUpdateListener: true,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    _arCoreController = controller;
    _arCoreController.onPlaneTap = _onPlaneTap;
    _arCoreController.onPlaneDetected = _onPlaneDetected;
    _arCoreController.onNodeTap = _onNodeTap;
  }

  void _onPlaneDetected(ArCorePlane plane) {
    _arCoreController.addArCoreNodeWithAnchor(
      ArCoreReferenceNode(
        name: _model,
        object3DFileName: _model + '.sfb',
        scale: vector.Vector3.all(0.3),
        position: plane.centerPose.translation,
        rotation: plane.centerPose.rotation,
      ),
    );
  }

  void _onPlaneTap(List<ArCoreHitTestResult> hits) {
    var plane = hits.first;

    _arCoreController.addArCoreNodeWithAnchor(
      ArCoreReferenceNode(
        name: _model + '$_count',
        object3DFileName: _model + '.sfb',
        scale: vector.Vector3(-0.5, -0.5, -0.5),
        position: plane.pose.translation,
        rotation: plane.pose.rotation,
      ),
    );

    _count++;
  }

  void _onNodeTap(String nodeName) {
    print('nodeName: $nodeName');
    _arCoreController.removeNode(nodeName: nodeName);
  }
}
