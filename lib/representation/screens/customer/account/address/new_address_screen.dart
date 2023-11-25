import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
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
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn Tỉnh/Thành phố'),
          content: SingleChildScrollView(
            child: ListBody(
              children: provinces.map((province) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedProvinceId = province['ProvinceID'];
                      provinceName = province['NameExtension'][0];
                      districtName = 'Quận/Huyện';
                      wardName = 'Phường/Xã';
                      selectedDistrictId = -1;
                    });
                    Navigator.of(context).pop();
                    print(selectedProvinceId);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(province['NameExtension'][0]),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDistrictDialog(int provinceId) async {
    List<Map<String, dynamic>> districts =
        await GHNApiService.getDistricts(provinceId);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn Quận/Huyện'),
          content: SingleChildScrollView(
            child: ListBody(
              children: districts.map((district) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDistrictId = district['DistrictID'];
                      districtName = district['NameExtension'][0];
                      wardName = 'Phường/Xã';
                    });
                    Navigator.of(context).pop();
                    print(selectedDistrictId);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(district['NameExtension'][0]),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showWardDialog(int districtId) async {
    // Gọi API getWards và hiển thị danh sách phường xã dựa trên districtId
    List<Map<String, dynamic>> wards = await GHNApiService.getWards(districtId);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn Phường/Xã'),
          content: SingleChildScrollView(
            child: ListBody(
              children: wards.map((ward) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      wardName = ward['NameExtension'][0];
                    });
                    Navigator.of(context).pop();
                    print(wardName);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(ward['NameExtension'][0]),
                  ),
                );
              }).toList(),
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
    } else if (_controller.text.contains(',')) {
      showCustomDialog(context, "Lỗi",
          "Tên đường, Tòa nhà, Số nhà không được chứa dấu ','", true);
    } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(FontAwesomeIcons.angleLeft),
        ),
        title: Center(
          child: Text('Địa chỉ mới'),
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
                    setState(() {
                      // Update UI based on selected province
                    });
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
                      setState(() {
                        // Update UI based on selected district
                      });
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
                      setState(() {
                        // Update UI based on selected ward
                      });
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
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: streetName),
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
