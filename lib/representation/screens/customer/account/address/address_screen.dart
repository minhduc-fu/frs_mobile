import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/my_textfield.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/models/address_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/address/new_address_screen.dart';
import 'package:frs_mobile/representation/widgets/app_bar_main.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/services/address_provider.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});
  static const String routeName = '/address_screen';
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController _addressController = TextEditingController();
  // int customerID = AuthProvider.userModel!.customer!.customerID;
  late AddressProvider _addressProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addressProvider = Provider.of<AddressProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    if (AuthProvider.userModel!.status == "VERIFIED") {
      _loadAddresses();
    }
  }

  void _loadAddresses() async {
    final addresses = await AuthenticationService.getAllAddressByCustomerID(
        AuthProvider.userModel!.customer!.customerID);

    if (addresses != null && addresses.isNotEmpty) {
      _addressProvider.setAddresses(addresses);
      _addressProvider.notifyListeners();
    }
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm địa chỉ mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextField(
                  controller: _addressController,
                  hintText: 'Địa chỉ',
                  obscureText: false)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Hủy',
                style: TextStyles.defaultStyle.bold
                    .setColor(Colors.red)
                    .setTextSize(18),
              ),
            ),
            ButtonWidget(
              title: "Lưu",
              size: 18,
              height: 40,
              width: 70,
              onTap: () {
                String addressDescription = _addressController.text;
                _addNewAddress(addressDescription);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewAddress(String addressDescription) async {
    final response = await AuthenticationService.createNewAddress(
      addressDescription,
      AuthProvider.userModel!.customer!.customerID,
    );

    if (response != null) {
      final newAddress = AddressModel(
        addressID: response['addressID'],
        addressDescription: response['addressDescription'],
        customerID: response['customerID'],
      );
      _addressProvider.addAddress(newAddress);
    }
  }

  void _deleteAddress(int addressID) async {
    final response = await AuthenticationService.deleteAddress(addressID);

    if (response != null) {
      _addressProvider.deleteAddress(addressID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarMain(
      titleAppbar: 'Địa chỉ của tôi',
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            color: ColorPalette.backgroundScaffoldColor,
            child: Icon(FontAwesomeIcons.angleLeft)),
      ),
      child: Scaffold(
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
                child: AuthProvider.userModel!.status == "NOT_VERIFIED"
                    ? Text('Làm ơn Cập nhật thông tin cá nhân')
                    : Consumer<AddressProvider>(
                        builder: (context, addressProvider, child) {
                          final addresses = addressProvider.addresses;
                          if (addresses.isEmpty) {
                            return Text('Bạn chưa có địa chỉ.');
                          } else {
                            return ListView.builder(
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultCircle14),
                                    ),
                                    // tileColor: Colors.white,
                                    title: Text(address.addressDescription),
                                    leading: Icon(FontAwesomeIcons.locationDot),
                                    trailing: IconButton(
                                        onPressed: () {
                                          _deleteAddress(address.addressID);
                                        },
                                        icon: Icon(FontAwesomeIcons.trashCan)),
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
        floatingActionButton: AuthProvider.userModel!.status == "NOT_VERIFIED"
            ? SizedBox()
            : SizedBox(
                height: 61,
                child: FloatingActionButton(
                  // onPressed: () {
                  //   _showAddAddressDialog();
                  // },
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
      ),
    );
  }
}
