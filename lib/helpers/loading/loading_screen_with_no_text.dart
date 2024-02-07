import 'package:flutter/material.dart';
import 'package:foodhub/helpers/loading/loading_screen_controller_with_no_text.dart';

class LoadingScreenWithNoText {
  static final LoadingScreenWithNoText _shared =
      LoadingScreenWithNoText._sharedInstance();
  LoadingScreenWithNoText._sharedInstance();
  factory LoadingScreenWithNoText() => _shared;

  LoadingScreenControllerWithNoText? controller;

  void show({
    required BuildContext context,
  }) {
    controller = showOverlay(
      context: context,
    );
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenControllerWithNoText showOverlay({
    required BuildContext context,
  }) {
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(100),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenControllerWithNoText(
      close: () {
        overlay.remove();
        return true;
      },
    );
  }
}
