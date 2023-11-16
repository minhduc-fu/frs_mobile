import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frs_mobile/services/address_provider.dart';
import 'package:provider/provider.dart';

class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn địa chỉ'),
      ),
      body: ListView.builder(
        itemCount: addressProvider.addresses.length,
        itemBuilder: (context, index) {
          final address = addressProvider.addresses[index];
          return ListTile(
            title: Text(address.addressDescription),
            onTap: () {
              addressProvider.selectAddress(address);
              final addressSelected =
                  addressProvider.selectedAddress!.addressDescription;
              print(addressSelected);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
