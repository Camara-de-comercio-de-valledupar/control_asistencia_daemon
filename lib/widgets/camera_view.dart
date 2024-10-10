import 'package:camera/camera.dart';
import 'package:camera_windows/camera_windows.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  final ValueChanged<Uint8List>? onPictureTaken;
  final ValueChanged<CameraController>? onCameraControllerLoaded;
  final ValueChanged<CameraException>? onError;
  const CameraView(
      {super.key,
      this.onPictureTaken,
      this.onCameraControllerLoaded,
      this.onError});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _cameraController;
  final cameraWindows = CameraWindows();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    try {
      final cameras = await cameraWindows.availableCameras();
      if (kDebugMode) {
        print(cameras);
      }

      if (cameras.isNotEmpty) {
        _cameraController =
            CameraController(cameras.first, ResolutionPreset.medium);
      }

      await Future.delayed(const Duration(seconds: 1), () {
        if (_cameraController != null) {
          _cameraController!.initialize().then((_) {
            if (!mounted) {
              return;
            }
            setState(() {});
          }).onError((error, stackTrace) {
            if (widget.onError != null) {
              widget.onError!(error as CameraException);
            }
          });
        }
      });

      if (widget.onCameraControllerLoaded != null) {
        widget.onCameraControllerLoaded!(_cameraController!);
      }
    } on CameraException catch (e) {
      if (widget.onError != null) {
        widget.onError!(e);
      }
    }
  }

  void _disposeCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }
  }

  void _takePicture() async {
    if (_cameraController?.value.isInitialized == true) {
      final picture = await _cameraController!.takePicture();
      if (widget.onPictureTaken != null) {
        widget.onPictureTaken!(await picture.readAsBytes());
      }
    }
  }

  @override
  void dispose() {
    _disposeCamera();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cameraWidth =
        (_cameraController?.value.previewSize?.width ?? 640) * 0.35;
    double cameraHeight =
        (_cameraController?.value.previewSize?.height ?? 480) * 0.35;
    if (kDebugMode) {
      print('cameraWidth: $cameraWidth');
      print('cameraHeight: $cameraHeight');
    }
    return Center(
      child: GestureDetector(
        onTap: () {
          _takePicture();
        },
        child: Container(
          width: cameraWidth,
          height: cameraHeight,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              border: Border.all(
                color: Colors.black,
                width: 4.0,
              ),
              borderRadius: BorderRadius.circular(20)),
          child: _cameraController != null &&
                  _cameraController!.value.isInitialized
              ? Center(
                  child: AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio / .992,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: CameraPreview(_cameraController!)),
                  ),
                )
              : const Center(
                  child: LoadingIndicator(
                  label: null,
                  color: Colors.black,
                )),
        ),
      ),
    );
  }
}
