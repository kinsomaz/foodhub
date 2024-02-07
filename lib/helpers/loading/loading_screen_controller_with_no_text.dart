typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

class LoadingScreenControllerWithNoText {
  final CloseLoadingScreen close;
  LoadingScreenControllerWithNoText({
    required this.close,
  });
}
