import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class CustomFacebookIcon extends StatelessWidget {
  const CustomFacebookIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.string(
        '''<svg xmlns="http://www.w3.org/2000/svg" width="29" height="30" viewBox="0 0 29 30" fill="none">
  <rect width="28.62" height="28.62" rx="14.31" fill="#1877F2"/>
  <path d="M19.4036 18.868L20.0816 14.4622H15.8401V11.6041C15.8401 10.3974 16.4314 9.22241 18.3311 9.22241H20.2607V5.47072C19.1284 5.28838 17.9842 5.18883 16.8374 5.17285C13.3427 5.17285 11.0607 7.28337 11.0607 11.103V14.4615H7.17725V18.868H11.0607V29.5197C12.6442 29.7658 14.2565 29.7658 15.8401 29.5197V18.868H19.4036Z" fill="white"/>
</svg>''',
        width: 28,
        height: 28,
      ),
    );
  }
}
