import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dismension_constants.dart';
import '../widgets/button_widget.dart';

class SelectDateScreen extends StatefulWidget {
  const SelectDateScreen({super.key, this.selectedRentalPeriod});
  final int? selectedRentalPeriod;
  static const String routeName = '/select_date_screen';

  @override
  State<SelectDateScreen> createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  DateTime? rangeStartDate;
  DateTime? rangeEndDate;
  int? selectedRentalPeriod;
  DateRangePickerController controller = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    selectedRentalPeriod = widget.selectedRentalPeriod ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(FontAwesomeIcons.angleLeft),
        ),
        title: Text('Chọn ngày'),
      ),
      body: Column(
        children: [
          SfDateRangePicker(
            controller: controller, // sử dụng controller để quản lý ngày
            minDate: DateTime.now(), // ngày tối thiểu là ngày hiện tại
            view: DateRangePickerView
                .month, // chế độ hiển thị theo tháng/năm/thập kỷ
            selectionMode: DateRangePickerSelectionMode
                .range, //range là chọn phạm vi, single chọn 1 ngày, multiple chọn nhiều ngày
            monthViewSettings: DateRangePickerMonthViewSettings(
                firstDayOfWeek:
                    1), // chế độ hiển thị theo tháng, ngày đầu tuần 1 là thứ 2
            selectionColor: ColorPalette.primaryColor,
            startRangeSelectionColor: ColorPalette.primaryColor,
            endRangeSelectionColor: ColorPalette.primaryColor,
            rangeSelectionColor: ColorPalette.hideColor,
            todayHighlightColor: ColorPalette.primaryColor,
            toggleDaySelection:
                true, // cho phép người  dùng chọn 1 ngày đã chọn trước đó để hủy chọn
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              // DateRangePickerSelectionChangedArgs là object chứa thông tin về lựa chọn ngày được thay đổi
              // khi mà người dùng chọn xong ngày bắt đầu và ngày kết thúc thì nó sẽ gán vào 2 biến này

              if (args.value.startDate != null) {
                rangeStartDate = args.value.startDate;
                if (selectedRentalPeriod != null) {
                  rangeEndDate = rangeStartDate!
                      .add(Duration(days: selectedRentalPeriod! - 1));
                  controller.selectedRange = PickerDateRange(rangeStartDate!,
                      rangeEndDate!); // dùng controller này để cập nhật lại UI
                }
              }
            },
          ),
          SizedBox(height: kBottomBarIconSize20),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kBottomBarIconSize20),
            child: ButtonWidget(
              title: 'Chọn',
              onTap: () {
                Navigator.of(context).pop([rangeStartDate, rangeEndDate]);
              },
              height: 70,
              size: 18,
            ),
          ),
          SizedBox(
            height: kDefaultPadding16,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kBottomBarIconSize20),
            child: ButtonWidget(
              title: 'Hủy',
              onTap: () {
                rangeStartDate = null;
                rangeEndDate = null;
                Navigator.of(context).pop([rangeStartDate, rangeEndDate]);
              },
              height: 70,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
