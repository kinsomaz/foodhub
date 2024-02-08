import 'package:flutter/material.dart';

typedef AddressSelect = Function(String address);

class AddressSuggestion extends StatelessWidget {
  final List addresses;
  final AddressSelect onAddressSelected;
  const AddressSuggestion({
    super.key,
    required this.onAddressSelected,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses.elementAt(index);
        return ListTile(
          onTap: () {
            onAddressSelected(address);
          },
          title: Text(address),
        );
      },
    );
  }
}
