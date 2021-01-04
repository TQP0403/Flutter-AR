import 'package:flutter/material.dart';
import 'ar_plane.dart';
import 'augmented_images.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ARCore'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Plane Detect'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlaneDetect(selectedModel: 'Andy'),
                ));
              },
            ),
            RaisedButton(
              child: Text('Augumented Image'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AugmentedPage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
