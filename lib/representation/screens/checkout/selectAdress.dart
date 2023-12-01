import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/screens/customer/account/address/new_address_screen.dart';
import 'package:frs_mobile/services/address_provider.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:frs_mobile/utils/dialog_helper.dart';
import 'package:provider/provider.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  late AddressProvider _addressProvider;
  int customerID = AuthProvider.userModel!.customer!.customerID;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addressProvider = Provider.of<AddressProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() async {
    final addresses =
        await AuthenticationService.getAllAddressByCustomerID(customerID);

    if (addresses != null && addresses.isNotEmpty) {
      _addressProvider.setAddresses(addresses);
      _addressProvider.notifyListeners();
    }
  }

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
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Địa chỉ',
              style: TextStyles.h4.bold,
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<AddressProvider>(
                builder: (context, addressProvider, child) {
                  final addresses = addressProvider.addresses;
                  if (addresses.isEmpty) {
                    return Center(child: Text('Bạn chưa có địa chỉ'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(kDefaultCircle14),
                          ),
                          child: ListTile(
                            onTap: () {
                              addressProvider.selectAddress(address);
                              final addressSelected = addressProvider
                                  .selectedAddress!.addressDescription;
                              print(addressSelected);
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kDefaultCircle14),
                            ),
                            // tileColor: Colors.white,
                            title: Text(address.addressDescription),
                            leading: Icon(FontAwesomeIcons.locationDot),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 61,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, NewAddressScreen.routeName);
          },
          backgroundColor: ColorPalette.primaryColor,
          child: Icon(
            FontAwesomeIcons.plus,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
