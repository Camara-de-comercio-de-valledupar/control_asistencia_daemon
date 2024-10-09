import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final RTCVideoRenderer _renderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    await _renderer.initialize();
    final mediaConstraints = {
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
      },
    };
    var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _renderer.setSrcObject(stream: stream);
    _renderer.onResize = () => setState(() {});
    setState(() {});
  }

  @override
  void dispose() {
    _renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RTCVideoView(
      mirror: true,
      _renderer,
    );
  }
}
