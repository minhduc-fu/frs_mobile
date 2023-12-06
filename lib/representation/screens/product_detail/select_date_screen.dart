import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../widgets/button_widget.dart';

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

  List<Map<String, List<int>>> apiResponse = [
    {
      "startDate": [2023, 12, 20],
      "endDate": [2023, 12, 26],
    },
    {
      "startDate": [2024, 1, 10],
      "endDate": [2024, 1, 15],
    },
  ];

  List<DateTime> bookedDates = [];
  @override
  void initState() {
    super.initState();
    selectedRentalPeriod = widget.selectedRentalPeriod ?? 0;
    for (var period in apiResponse) {
      DateTime startDate = DateTime(period["startDate"]![0],
          period["startDate"]![1], period["startDate"]![2]);

      DateTime endDate = DateTime(
          period["endDate"]![0], period["endDate"]![1], period["endDate"]![2]);
      for (int i = 1; i <= 4; i++) {
        DateTime disabledDate = endDate.add(Duration(days: i));
        bookedDates.add(disabledDate);
      }
      for (DateTime date = startDate;
          date.isBefore(endDate.add(Duration(days: 1)));
          date = date.add(Duration(days: 1))) {
        bookedDates.add(date);
      }
    }
  }

  bool isAnyDateDisabled(
      DateTime startDate, DateTime endDate, List<DateTime> disabledDates) {
    for (DateTime date = startDate;
        date.isBefore(endDate.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      if (disabledDates.contains(date)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 240, 242, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            FontAwesomeIcons.angleLeft,
          ),
        ),
        title: Center(child: Text('Chọn ngày')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Chúng tôi khuyên bạn nên chọn ngày giao hàng ít nhất 2 ngày trước sự kiện của bạn.',
              style: TextStyles.defaultStyle.bold,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          SfDateRangePicker(
            selectableDayPredicate: (DateTime date) {
              // Kiểm tra xem ngày có thể chọn không
              return !bookedDates.contains(date);
            },
            controller: controller, // sử dụng controller để quản lý ngày
            minDate: DateTime.now()
                .add(Duration(days: 2)), // ngày tối thiểu là ngày hiện tại
            view: DateRangePickerView
                .month, // chế độ hiển thị theo tháng/năm/thập kỷ
            selectionMode: DateRangePickerSelectionMode
                .range, //range là chọn phạm vi, single chọn 1 ngày, multiple chọn nhiều ngày
            monthViewSettings: DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1,
                showTrailingAndLeadingDates:
                    true), // chế độ hiển thị theo tháng, ngày đầu tuần 1 là thứ 2
            selectionColor: ColorPalette.primaryColor,
            startRangeSelectionColor: ColorPalette.primaryColor,
            endRangeSelectionColor: ColorPalette.primaryColor,
            rangeSelectionColor: ColorPalette.hideColor,
            todayHighlightColor: Colors.redAccent,
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
                if (rangeStartDate != null &&
                    rangeEndDate != null &&
                    isAnyDateDisabled(
                        rangeStartDate!, rangeEndDate!, bookedDates)) {
                  // Ngày đã disable trong khoảng đã chọn, hiển thị thông báo hoặc xử lý khác
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Khoảng thời gian chứa ngày đã được thuê, vui lòng chọn lại.'),
                    ),
                  );
                } else {
                  // Ngày không bị disable, có thể thực hiện xử lý tiếp
                  Navigator.of(context).pop([rangeStartDate, rangeEndDate]);
                }
                // Navigator.of(context).pop([rangeStartDate, rangeEndDate]);
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
