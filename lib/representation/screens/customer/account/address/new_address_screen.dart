import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/my_textformfield.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/models/address_model.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/services/address_provider.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:frs_mobile/services/ghn_api_service.dart';
import 'package:frs_mobile/utils/dialog_helper.dart';
import 'package:provider/provider.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({super.key});
  static const String routeName = '/new_address_screen';

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  String provinceName = 'Tỉnh/Thành phố';
  String districtName = 'Quận/Huyện';
  String wardName = 'Phường/Xã';
  String streetName = 'Tên đường, Tòa nhà, Số nhà';
  int selectedProvinceId = -1;
  int selectedDistrictId = -1;
  TextEditingController _controller = TextEditingController();

  Future<void> _showProvinceDialog() async {
    List<Map<String, dynamic>> provinces = await GHNApiService.getProvinces();
    List<Map<String, dynamic>> provincesTrue = provinces
        .where((province) =>
            province['NameExtension'] != null &&
            province['NameExtension'].isNotEmpty)
        .toList();
    provincesTrue
        .sort((a, b) => a['NameExtension'][0].compareTo(b['NameExtension'][0]));
    showModalBottomSheet(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14)),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        String currentFirstLetter = '';
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorPalette.primaryColor,
                        borderRadius: BorderRadius.circular(kDefaultCircle14)),
                    height: 7,
                    width: 50,
                  ),
                ),
                SizedBox(height: 20),
                Text('Chọn Tỉnh/Thành phố', style: TextStyles.h5.bold),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provincesTrue.length,
                    itemBuilder: (context, index) {
                      String firstLetter = provincesTrue[index]['NameExtension']
                              [0][0]
                          .toUpperCase();
                      Widget firstLetterWidget =
                          (firstLetter != currentFirstLetter)
                              ? Column(
                                  children: [
                                    Text(
                                      firstLetter,
                                      style: TextStyles.defaultStyle,
                                    ),
                                    SizedBox(height: 17)
                                  ],
                                )
                              : SizedBox(
                                  width: 10,
                                );
                      currentFirstLetter = firstLetter;
                      return Row(
                        children: [
                          firstLetterWidget,
                          SizedBox(width: 20),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedProvinceId =
                                      provincesTrue[index]['ProvinceID'];
                                  provinceName =
                                      provincesTrue[index]['NameExtension'][0];
                                  districtName = 'Quận/Huyện';
                                  wardName = 'Phường/Xã';
                                  selectedDistrictId = -1;
                                });
                                Navigator.pop(context);
                                print(selectedProvinceId);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: double.infinity,
                                      child: Text(provincesTrue[index]
                                          ['NameExtension'][0])),
                                  Divider(
                                    thickness: 0.5,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDistrictDialog(int provinceId) async {
    List<Map<String, dynamic>> districts =
        await GHNApiService.getDistricts(provinceId);
    List<Map<String, dynamic>> districtTrue = districts
        .where((district) =>
            district['NameExtension'] != null &&
            district['NameExtension'].isNotEmpty)
        .toList();

    districtTrue
        .sort((a, b) => a['NameExtension'][0].compareTo(b['NameExtension'][0]));
    return showModalBottomSheet(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14)),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        String currentFirstLetter = '';
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorPalette.primaryColor,
                        borderRadius: BorderRadius.circular(kDefaultCircle14)),
                    height: 7,
                    width: 50,
                  ),
                ),
                SizedBox(height: 20),
                Text('Chọn Quận/Huyện', style: TextStyles.h5.bold),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: districtTrue.length,
                    itemBuilder: (context, index) {
                      String firstLetter = districtTrue[index]['NameExtension']
                              [0][0]
                          .toUpperCase();
                      Widget firstLetterWidget =
                          (firstLetter != currentFirstLetter)
                              ? Column(
                                  children: [
                                    Text(
                                      firstLetter,
                                      style: TextStyles.defaultStyle,
                                    ),
                                    SizedBox(height: 17)
                                  ],
                                )
                              : SizedBox(
                                  width: 10,
                                );
                      currentFirstLetter = firstLetter;
                      return Row(
                        children: [
                          firstLetterWidget,
                          SizedBox(width: 20),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDistrictId =
                                      districtTrue[index]['DistrictID'];
                                  districtName =
                                      districtTrue[index]['NameExtension'][0];
                                  wardName = 'Phường/Xã';
                                });
                                Navigator.of(context).pop();
                                print(selectedDistrictId);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: double.infinity,
                                      child: Text(districtTrue[index]
                                          ['NameExtension'][0])),
                                  Divider(
                                    thickness: 0.5,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showWardDialog(int districtId) async {
    List<Map<String, dynamic>> wards = await GHNApiService.getWards(districtId);
    List<Map<String, dynamic>> wardsTrue = wards
        .where((ward) =>
            ward['NameExtension'] != null && ward['NameExtension'].isNotEmpty)
        .toList();
    wardsTrue
        .sort((a, b) => a['NameExtension'][0].compareTo(b['NameExtension'][0]));

    return showModalBottomSheet(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14)),
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      context: context,
      builder: (BuildContext context) {
        String currentFirstLetter = '';
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorPalette.primaryColor,
                        borderRadius: BorderRadius.circular(kDefaultCircle14)),
                    height: 7,
                    width: 50,
                  ),
                ),
                SizedBox(height: 20),
                Text('Chọn Phường/Xã', style: TextStyles.h5.bold),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: wardsTrue.length,
                    itemBuilder: (context, index) {
                      String firstLetter =
                          wardsTrue[index]['NameExtension'][0][0].toUpperCase();
                      Widget firstLetterWidget =
                          (firstLetter != currentFirstLetter)
                              ? Column(
                                  children: [
                                    Text(
                                      firstLetter,
                                      style: TextStyles.defaultStyle,
                                    ),
                                    SizedBox(height: 17)
                                  ],
                                )
                              : SizedBox(
                                  width: 10,
                                );

                      currentFirstLetter = firstLetter;
                      return Row(
                        children: [
                          firstLetterWidget,
                          SizedBox(width: 20),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  wardName =
                                      wardsTrue[index]['NameExtension'][0];
                                });
                                Navigator.of(context).pop();
                                print(wardName);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: double.infinity,
                                      child: Text(wardsTrue[index]
                                          ['NameExtension'][0])),
                                  Divider(
                                    thickness: 0.5,
                                    color: ColorPalette.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleCompletion() async {
    if (selectedProvinceId == -1) {
      showCustomDialog(context, "Lỗi", "Vui lòng chọn Tỉnh/Thành phố", true);
    } else if (selectedDistrictId == -1) {
      showCustomDialog(context, "Lỗi", "Vui lòng chọn Quận/Huyện", true);
    } else if (wardName == 'Phường/Xã') {
      showCustomDialog(context, "Lỗi", "Vui lòng chọn Phường/Xã", true);
    } else if (_controller.text.isEmpty) {
      showCustomDialog(
          context, "Lỗi", "Vui lòng nhập Tên đường, Tòa nhà, Số nhà", true);
    } else {
      if (validateStreet(_controller.text) == null) {
        String addressString =
            "${_controller.text}, $wardName, $districtName, $provinceName";
        final response = await AuthenticationService.createNewAddress(
          addressString,
          AuthProvider.userModel!.customer!.customerID,
        );
        if (response != null) {
          final newAddress = AddressModel(
            addressID: response['addressID'],
            addressDescription: response['addressDescription'],
            customerID: response['customerID'],
          );
          Provider.of<AddressProvider>(context, listen: false)
              .addAddress(newAddress);
        }
        print("Địa chỉ hoàn thành: $addressString");
        Navigator.pop(context);
      }
    }
  }

  String? validateStreet(String? street) {
    if (street == null || street.isEmpty) {
      return 'Vui lòng nhập Tên đường, Tòa nhà, Số nhà';
    }

    if (street.contains(',')) {
      return 'Không được chứa dấu ","';
    }

    String pattern = r'[!@#\$%^&*(),.?":{}|<>]';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(street)) {
      return 'Không được chứa ký tự đặc biệt';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              color: ColorPalette.backgroundScaffoldColor,
              child: Icon(FontAwesomeIcons.angleLeft)),
        ),
        centerTitle: true,
        title: Text(
          'Địa chỉ mới',
          style: TextStyles.defaultStyle.setTextSize(18).bold,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Text(
                  'Địa chỉ',
                  style: TextStyles.h4.bold,
                ),
                SizedBox(height: 20),
                Text(
                  'Tỉnh/Thành phố',
                  style: TextStyles.h5.bold,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    await _showProvinceDialog();
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        color: Colors.white),
                    child: ListTile(
                      title: Text('${provinceName}'),
                      trailing: Icon(FontAwesomeIcons.angleRight),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Quận/Huyện',
                  style: TextStyles.h5.bold,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    if (selectedProvinceId != -1) {
                      await _showDistrictDialog(selectedProvinceId);
                      setState(() {});
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        color: Colors.white),
                    child: ListTile(
                      title: Text('${districtName}'),
                      trailing: Icon(FontAwesomeIcons.angleRight),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Phường/Xã',
                  style: TextStyles.h5.bold,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    if (selectedDistrictId != -1) {
                      await _showWardDialog(selectedDistrictId);
                      setState(() {});
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        color: Colors.white),
                    child: ListTile(
                      title: Text('${wardName}'),
                      trailing: Icon(FontAwesomeIcons.angleRight),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tên đường, Tòa nhà, Số nhà',
                  style: TextStyles.h5.bold,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultCircle14),
                      color: Colors.white),
                  child: MyTextFormField(
                    controller: _controller,
                    hintText: streetName,
                    validator: validateStreet,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ButtonWidget(
              onTap: _handleCompletion,
              title: "Hoàn thành",
              height: 70,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
