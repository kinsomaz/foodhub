import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodhub/views/payment/card_information.dart';

typedef CreditCardCallback = void Function(CardInformation card);

class CreditCardListView extends StatefulWidget {
  final List<CardInformation> cards;
  final CreditCardCallback onTap;
  const CreditCardListView({
    super.key,
    required this.cards,
    required this.onTap,
  });

  @override
  State<CreditCardListView> createState() => _CreditCardListViewState();
}

class _CreditCardListViewState extends State<CreditCardListView> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Wrap(
      runSpacing: screenWidth * 0.02,
      children: widget.cards
          .map(
            (card) => GestureDetector(
              onTap: () {
                widget.onTap(card);
              },
              onTapDown: (_) {
                setState(() {
                  isTapped = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isTapped = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  isTapped = false;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.008,
                ),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(10.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isTapped
                          ? Colors.black.withAlpha(25)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(FontAwesomeIcons.ccMastercard),
                        SizedBox(
                          width: screenWidth * 0.05,
                        ),
                        Text(
                          'Card ending in ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: true,
                            applyHeightToLastDescent: false,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                          style: TextStyle(
                            fontSize: screenWidth * 0.047,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
