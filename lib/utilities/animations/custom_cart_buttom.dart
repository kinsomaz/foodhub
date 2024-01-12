import 'package:flutter/material.dart';
import 'package:foodhub/icons/custom_cart_icon.dart';

class CustomCartButton extends StatefulWidget {
  const CustomCartButton({super.key});

  @override
  State<CustomCartButton> createState() => _CustomCartButtonState();
}

class _CustomCartButtonState extends State<CustomCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _iconSlideAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _iconSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(2.8, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.45, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFFFE724C)),
        padding: MaterialStateProperty.all(const EdgeInsets.only(
          left: 5,
          right: 12,
          top: 4,
          bottom: 4,
        )),
        elevation: MaterialStateProperty.all(10),
        alignment: AlignmentDirectional.centerStart,
      ),
      icon: SlideTransition(
        position: _iconSlideAnimation,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFFFFF),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomCartIcon(),
          ),
        ),
      ),
      label: SlideTransition(
        position: _textSlideAnimation,
        child: const Text(
          'ADD TO CART',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'SofiaPro',
            fontWeight: FontWeight.w400,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      onPressed: () {
        _animationController.forward();
        // Perform your add to cart logic here
      },
    );
  }
}
