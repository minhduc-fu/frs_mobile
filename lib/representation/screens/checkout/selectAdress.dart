import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/services/address_provider.dart';
import 'package:frs_mobile/utils/dialog_helper.dart';
import 'package:provider/provider.dart';

class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            if (addressProvider.selectedAddress == null) {
              showCustomDialog(context, "Lỗi", "Làm ơn chọn địa chỉ", true);
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(FontAwesomeIcons.angleLeft),
        ),
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        title: Center(child: Text('Chọn địa chỉ')),
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
