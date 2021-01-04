import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class PlaneDetect extends StatefulWidget {
  const PlaneDetect({
    @required this.selectedModel,
    Key key,
  }) : super(key: key);

  final String selectedModel;

  @override
  _PlaneDetectState createState() => _PlaneDetectState();
}

class _PlaneDetectState extends State<PlaneDetect> {
  ArCoreController _arCoreController = new ArCoreController();
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
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Plane Detect'),
        ),
        body: new ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }

  _onArCoreViewCreated(ArCoreController localController) {
    _arCoreController = localController;
    _arCoreController.onPlaneTap = _onPlaneTap;
    _arCoreController.onNodeTap = (name) => onTapHandler(name);
  }

  _onPlaneTap(List<ArCoreHitTestResult> hits) => _onHitDetected(hits.first);

  _onHitDetected(ArCoreHitTestResult plane) async {
    _count++;
    await _arCoreController.addArCoreNodeWithAnchor(
      ArCoreReferenceNode(
        name: widget.selectedModel + ' ' + _count.toString(),
        object3DFileName: widget.selectedModel + ".sfb",
        position: plane.pose.translation,
        rotation: plane.pose.rotation,
      ),
    );
  }

  void onTapHandler(String name) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Row(
          children: <Widget>[
            Text('Remove $name?'),
            IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () async {
                  _arCoreController
                      .removeNode(nodeName: name)
                      .then((value) => Navigator.pop(context));
                  // Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
