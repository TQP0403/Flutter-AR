import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class AugmentedPage extends StatefulWidget {
  @override
  _AugmentedPageState createState() => _AugmentedPageState();
}

class _AugmentedPageState extends State<AugmentedPage> {
  ArCoreController arCoreController;
  Map<int, ArCoreAugmentedImage> augmentedImagesMap = Map();
  String _model = 'Andy';

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Single Augmented Image'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          type: ArCoreViewType.AUGMENTEDIMAGES,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) async {
    arCoreController = controller;
    arCoreController.onTrackingImage = _handleOnTrackingImage;
    // loadSingleImage(imageName: 'earth_augmented_image.jpg');
    loadSingleImage(imageName: 'dino.jpg');

    // OR
    // loadSingleImage();
    // loadImagesDatabase();
  }

  // void loadSingleImage() async {
  //   final ByteData bytes =
  //       await rootBundle.load('assets/images/earth_augmented_image.jpg');
  //   await arCoreController.loadSingleAugmentedImage(
  //       bytes: bytes.buffer.asUint8List());
  // }

  void loadSingleImage({String imageName}) => rootBundle
      .load('assets/images/' + imageName)
      .then((data) async => await arCoreController.loadSingleAugmentedImage(
          bytes: data.buffer.asUint8List()));

  void loadImagesDatabase() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/myimages.imgdb');
    arCoreController.loadAugmentedImagesDatabase(
        bytes: bytes.buffer.asUint8List());
  }

  void _handleOnTrackingImage(ArCoreAugmentedImage augmentedImage) {
    if (!augmentedImagesMap.containsKey(augmentedImage.index)) {
      augmentedImagesMap[augmentedImage.index] = augmentedImage;
      // _addSphere(augmentedImage);
      _addModel(augmentedImage);
    }
  }

  void _addModel(ArCoreAugmentedImage augmentedImage) {
    var rotation = augmentedImage.centerPose.rotation;
    var translation = augmentedImage.centerPose.translation;

    print('rotation: $rotation');
    print('translation: $translation');

    var node = ArCoreReferenceNode(
      name: _model,
      object3DFileName: _model + '.sfb',
      // position: translation,
      // rotation: rotation,
    );

    arCoreController.addArCoreNodeToAugmentedImage(node, augmentedImage.index);
  }

  Future _addSphere(ArCoreAugmentedImage augmentedImage) async {
    final ByteData textureBytes =
        await rootBundle.load('assets/images/earth.jpg');

    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      textureBytes: textureBytes.buffer.asUint8List(),
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: augmentedImage.extentX / 2,
    );
    final node = ArCoreNode(
      shape: sphere,
    );

    arCoreController.addArCoreNodeToAugmentedImage(node, augmentedImage.index);
  }
}
