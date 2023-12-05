import 'dart:async';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/constants/dismension_constants.dart';
import '../../core/constants/textstyle_constants.dart';
import '../../utils/asset_helper.dart';
import '../../utils/image_helper.dart';
import '../widgets/button_widget.dart';
import 'main_app.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static const String routeName = 'intro_screen';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final StreamController<int> _pageStreamController =
      StreamController<int>.broadcast();
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    // PageController là 1 dạng stream.
    // Mỗi khi người dùng lướt sang page khác, thêm thằng _pageController vào addListener. output 0 đến 1 đến 2
    _pageController.addListener(() {
      // khi mà nó chuyển sang 1 page khác rồi thì add nó vào luồng stream = giá trị của nó
      _pageStreamController.add(_pageController.page!.toInt());
    });
  }

  // Widget _buildItemIntroScreen(
  //     String image, String title, String description, Alignment alignment) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Image
  //       Container(
  //         alignment: alignment,
  //         child: ImageHelper.loadFromAsset(image,
  //             height: 400, fit: BoxFit.fitHeight),
  //       ),
  //       SizedBox(
  //         height: kMediumPadding24 * 2,
  //       ),
  //       Padding(
  //         padding: EdgeInsets.symmetric(horizontal: kMediumPadding24),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // title
  //             Text(
  //               title,
  //               style: TextStyles.defaultStyle.bold,
  //             ),
  //             SizedBox(
  //               height: kMediumPadding24,
  //             ),
  //             // description
  //             Text(
  //               description,
  //               style: TextStyles.defaultStyle,
  //             )
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _build(Widget icon, Color color, String title, String subTitle) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(kDefaultCircle14),
          ),
          child: icon,
        ),
        SizedBox(
          height: kItemPadding10,
        ),
        Text(
          title,
          style: TextStyles.defaultStyle.bold,
        ),
        Text(
          subTitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildItemIntroScreen1() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: ColorPalette.primaryColor,
                  borderRadius: BorderRadius.circular(kDefaultCircle14)),
              padding: EdgeInsets.all(10),
              height: 230,
              width: double.infinity,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kDefaultCircle14),
                  child: Opacity(
                    opacity: 0.2,
                    child: ImageHelper.loadFromAsset(AssetHelper.imageAboutUs,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'FRS là nền tảng thương mại điện tử hàng đầu trong tim chúng tôi',
              style: TextStyles.h5.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kDefaultCircle14),
              ),
              child: Column(
                children: [
                  Text(
                    'Ra mắt năm 2023, nền tảng thương mại FRS được xây dựng nhằm cung cấp cho người dùng những dịch vụ thuê và mua các mặt hàng thời trang hàng hiệu cao cấp.',
                  ),
                  Text(
                    'Chúng tôi có niềm tin mạnh mẽ rằng khi bạn sử dụng dịch vụ của FRS sẽ tiết kiệm được một khoản tiền lớn và đa dạng phong phú với phong cách ăn mặc của bản thân.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Đặc điểm về con người chúng tôi',
              style: TextStyles.h5.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _build(
                      ImageHelper.loadFromAsset(AssetHelper.imageGanGui,
                          width: 50, height: 50),
                      Colors.white,
                      'Thân thiện',
                      'Chúng tôi thân thiện, gần gũi với tất cả mọi người.'),
                ),
                SizedBox(
                  width: kDefaultPadding16,
                ),
                Expanded(
                  child: _build(
                      ImageHelper.loadFromAsset(AssetHelper.imageVuiVe,
                          width: 50, height: 50),
                      Colors.white,
                      'Vui vẻ',
                      'Chúng tôi dễ gần, đáng yêu và tràn đầy năng lượng.'),
                ),
                SizedBox(
                  width: kDefaultPadding16,
                ),
                Expanded(
                  child: _build(
                      ImageHelper.loadFromAsset(AssetHelper.imageDongLong,
                          width: 50, height: 50),
                      Colors.white,
                      'Đồng lòng',
                      'Chúng tôi lắng nghe, thấu hiểu và cùng nhau.'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemIntroScreen2() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return section(sections[index]['title'], sections[index]['content']);
        },
      ),
    );
  }

  Widget section(String title, List<String> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyles.h5.bold),
        Divider(
          thickness: 0.5,
          color: ColorPalette.primaryColor,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content
              .map((text) => ExpandableText(
                    text,
                    expandText: 'Xem thêm',
                    linkColor: Colors.blue,
                    collapseText: 'Thu gọn',
                    maxLines: 5,
                  ))
              .toList(),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> sections = [
    {
      'title': '1. Giới thiệu',
      'content': [
        '1.1. Chào mừng bạn đến với nền tảng FRS (bao gồm website và ứng dụng di động) được vận hành bởi nhóm năm anh em. FRS nghiêm túc thực hiện trách nhiệm của mình liên quan đến bảo mật thông tin theo các quy định về bảo vệ bí mật thông tin cá nhân của pháp luật Việt Nam (“Luật riêng tư”) và cam kết tôn trọng quyền riêng tư và sự quan tâm của tất cả người dùng đối với website và ứng dụng di động của chúng tôi (“Nền tảng”) (chúng tôi gọi chung Các Nền tảng và các dịch vụ chúng tôi cung cấp như được mô tả trong Nền tảng của chúng tôi là "các Dịch Vụ"). Người dùng có nghĩa là người đăng ký tài khoản với chúng tôi để sử dụng các Dịch Vụ, bao gồm cả người mua và người bán (gọi chung và gọi riêng là “Các Người Dùng”, “bạn” hoặc “của bạn”). Chúng tôi nhận biết tầm quan trọng của dữ liệu cá nhân mà bạn đã tin tưởng giao cho chúng tôi và tin rằng chúng tôi có trách nhiệm quản lý, bảo vệ và xử lý dữ liệu cá nhân của bạn một cách thích hợp. Chính sách bảo mật này ("Chính sách bảo mật" hay "Chính sách") được thiết kế để giúp bạn hiểu được cách thức chúng tôi thu thập, sử dụng, tiết lộ và/hoặc xử lý dữ liệu cá nhân mà bạn đã cung cấp cho chúng tôi và/hoặc lưu giữ về bạn, cho dù là hiện nay hoặc trong tương lai, cũng như để giúp bạn đưa ra quyết định sáng suốt trước khi cung cấp cho chúng tôi bất kỳ dữ liệu cá nhân nào của bạn.',
        '\n1.2. "Dữ Liệu Cá Nhân" hay "dữ liệu cá nhân" có nghĩa là dữ liệu, dù đúng hay không, về một cá nhân mà thông qua đó có thể được xác định được danh tính, hoặc từ dữ liệu đó và thông tin khác mà một tổ chức có hoặc có khả năng tiếp cận. Các ví dụ thường gặp về dữ liệu cá nhân có thể gồm có tên, số chứng minh nhân dân và thông tin liên hệ.',
        '\n1.3. Bằng việc sử dụng Các Dịch Vụ, đăng ký một tài khoản với chúng tôi hoặc truy cập Nền tảng, bạn xác nhận và đồng ý rằng bạn chấp nhận các phương pháp, yêu cầu, và/hoặc chính sách được mô tả trong Chính sách bảo mật này, và theo đây bạn xác nhận bạn đã biết rõ và đồng ý toàn bộ cho phép chúng tôi thu thập, sử dụng, tiết lộ và/hoặc xử lý dữ liệu cá nhân của bạn như mô tả trong đây. NẾU BẠN KHÔNG ĐỒNG Ý CHO PHÉP XỬ LÝ DỮ LIỆU CÁ NHÂN CỦA BẠN NHƯ MÔ TẢ TRONG CHÍNH SÁCH NÀY, VUI LÒNG KHÔNG SỬ DỤNG CÁC DỊCH VỤ CỦA CHÚNG TÔI HAY TRUY CẬP NỀN TẢNG HOẶC TRANG WEB CỦA CHÚNG TÔI. Nếu chúng tôi thay đổi Chính sách bảo mật của mình, chúng tôi sẽ thông báo cho bạn bao gồm cả thông qua việc đăng tải những thay đổi đó hoặc Chính sách bảo mật sửa đổi trên Nền tảng của chúng tôi. Trong phạm vi pháp luật cho phép, việc tiếp tục sử dụng các Dịch Vụ hoặc Nền Tảng, bao gồm giao dịch của bạn, được xem là bạn đã công nhận và đồng ý với các thay đổi trong Chính Sách Bảo Mật này.',
        '\n1.4. Chính sách này áp dụng cùng với các thông báo, điều khoản hợp đồng, điều khoản chấp thuận khác áp dụng liên quan đến việc chúng tôi thu thập, lưu trữ, sử dụng, tiết lộ và/hoặc xử lý dữ liệu cá nhân của bạn và không nhằm ghi đè những thông báo hoặc các điều khoản đó trừ khi chúng tôi có tuyên bố ràng khác.',
        '\n1.5. Chính sách này được áp dụng cho cả Người bán và Người mua đang sử dụng Dịch vụ trừ khi có tuyên bố rõ ràng ngược lại.',
      ],
    },
    {
      'title': '\n2. Khi nào FRS sẽ thu thập dữ liệu cá nhân?',
      'content': [
        '2.1. Chúng tôi sẽ/có thể thu thập dữ liệu cá nhân về bạn:\n- khi bạn đăng ký và/hoặc sử dụng Các Dịch Vụ hoặc Nền tảng của chúng tôi, hoặc mở một tài khoản với chúng tôi;\n- khi bạn gửi bất kỳ biểu mẫu nào, bao gồm đơn đăng ký hoặc các mẫu đơn khác liên quan đến bất kỳ sản phẩm và dịch vụ nào của chúng tôi, bằng hình thức trực tuyến hay dưới hình thức khác;\n- khi bạn ký kết bất kỳ thỏa thuận nào hoặc cung cấp các tài liệu hoặc thông tin khác liên quan đến tương tác giữa bạn với chúng tôi, hoặc khi bạn sử dụng các sản phẩm và dịch vụ của chúng tôi;\n- khi bạn tương tác với chúng tôi, chẳng hạn như thông qua các cuộc gọi điện thoại (có thể được ghi âm lại), thư từ, fax, gặp gỡ trực tiếp, các nền ứng dụng truyền thông xã hội và email;\nCác trường hợp trên không nhằm mục đích liệt kê đầy đủ các trường hợp và chỉ đưa ra một số trường hợp phổ biến về thời điểm dữ liệu cá nhân của bạn có thể bị thu thập.',
        '\n2.2. Chúng tôi có thể thu thập thông tin của bạn từ bạn, các công ty liên kết, các bên thứ ba và từ các nguồn khác, bao gồm nhưng không giới hạn ở đối tác kinh doanh (ví dụ như đơn vị cung ứng dịch vụ vận chuyển, thanh toán), cơ quan đánh giá tín dụng, các đơn vị, đối tác cung cấp dịch vụ marketing, giới thiệu, các chương trình khách hàng thân thiết, những người dùng khác sử dụng Các Dịch Vụ của chúng tôi hoặc các nguồn dữ liệu công khai có sẵn hay các nguồn dữ liệu của nhà nước.',
        '\n2.3. Trong một số trường hợp, bạn có thể cung cấp dữ liệu cá nhân của các cá nhân khác cho chúng tôi (ví dụ như thành viên gia đình, bạn bè hoặc những người trong danh sách liên hệ của bạn). Nếu bạn cung cấp cho chúng tôi dữ liệu cá nhân của họ, bạn tuyên bố và đảm bảo rằng bạn đã nhận được sự đồng ý của họ để xử lý dữ liệu cá nhân của họ theo Chính sách này.',
      ],
    },
    {
      'title':
          '\n3. FRS có tiết lộ thông tin thu thập từ người truy cập hay không?',
      'content': [
        '3.1. Trong quá trình thực hiện hoạt động kinh doanh, chúng tôi sẽ/có thể cần phải sử dụng, xử lý, tiết lộ và/hoặc chuyển giao dữ liệu cá nhân của bạn cho các nhà cung cấp dịch vụ bên thứ ba, đại lý và/hoặc các công ty liên kết hoặc công ty liên quan của chúng tôi, và/hoặc các bên thứ ba khác có thể ở Việt Nam hoặc bên ngoài Việt Nam, vì một hay nhiều Mục Đích nói trên, và việc tiết lộ này sẽ được thực hiện theo đúng trình tự và quy định của pháp luật hiện hành. Các nhà cung cấp dịch vụ bên thứ ba, đại lý và/hoặc các công ty liên kết hoặc công ty liên quan và/hoặc các bên thứ ba khác như thế sẽ xử lý dữ liệu cá nhân của bạn hoặc thay mặt chúng tôi hoặc ngược lại, vì một hoặc nhiều Mục Đích nói trên. Chúng tôi cố gắng đảm bảo rằng các bên thứ ba và các công ty liên kết của chúng tôi giữ an toàn cho dữ liệu cá nhân của bạn khỏi bị truy cập, thu thập, sử dụng, tiết lộ, xử lý trái phép hoặc các rủi ro tương tự và chỉ lưu giữ dữ liệu cá nhân của bạn miễn là dữ liệu cá nhân của bạn vẫn còn cần thiết cho những việc nêu trên Mục đích Các bên thứ ba như thế bao gồm:\n- người bán hoặc người mua mà bạn đã thực hiện giao dịch hoặc tương tác trên Nền tảng hoặc liên quan đến việc bạn sử dụng Dịch vụ cho các Mục đích đã nêu ở trên;\n- những người sử dụng khác của Nền tảng của chúng tôi cho một hoặc nhiều các Mục đích đã nêu ở trên;\n- nhà thầu, đại lý, nhà cung cấp dịch vụ và các bên thứ ba khác mà chúng tôi thuê để hỗ trợ hoặc bổ sung cho hoạt động kinh doanh của chúng tôi. Những bên này bao gồm, nhưng không giới hạn ở những bên cung cấp các dịch vụ quản trị hoặc các dịch vụ khác cho chúng tôi chẳng hạn như công ty bưu chính, công ty viễn thông, đối tác quảng cáo và truyền thông, công ty công nghệ thông tin, các tổ chức hoạt động thương mại điện tử, và trung tâm dữ liệu;\n- các cơ quan chính phủ hoặc cơ quan quản lý có thẩm quyền đối với FRS hoặc nếu được cho phép',
        '\n3.2. Chúng tôi có thể chia sẻ thông tin bao gồm thông tin thống kê và nhân khẩu học về Người Dùng cũng như thông tin về việc sử dụng Các Dịch Vụ của người dùng với đối tác cung cấp dịch vụ quảng cáo và lập trình. Chúng tôi cũng sẽ chia sẻ thông tin thống kê và thông tin nhân khẩu học về người dùng của chúng tôi và việc họ sử dụng Các Dịch Vụ với các đối tác quảng cáo và bên thứ ba cung cấp dịch vụ quảng cáo, tái quảng cáo, và/hoặc lập trình.',
        '\n3.3. Để tránh nghi ngờ, trong trường hợp các quy định của pháp luật về bảo vệ bí mật thông tin cá nhân hoặc các điều luật hiện hành khác cho phép một tổ chức chẳng hạn như chúng tôi thu thập, sử dụng hoặc tiết lộ dữ liệu cá nhân của bạn mà không cần sự đồng ý của bạn, sự cho phép như thế của pháp luật sẽ tiếp tục áp dụng. Phù hợp với các quy định nêu trên và theo các quy định của pháp luật hiện hành, chúng tôi có thể sử dụng dữ liệu cá nhân của bạn cho các cơ sở pháp lý đã được công nhận, bao gồm tuân thủ các nghĩa vụ pháp lý của chúng tôi, để thực hiện hợp đồng của chúng tôi với bạn, để đạt được lợi ích hợp pháp và lý do của chúng tôi để sử dụng dữ liệu đó cao hơn bất kỳ phương hại nào đến quyền bảo vệ dữ liệu của bạn hoặc khi cần thiết liên quan với một yêu cầu pháp lý.',
        '\n3.4. Các bên thứ ba có thể chặn hoặc truy cập trái phép dữ liệu cá nhân được gửi đến hoặc có trên trang web, các công nghệ có thể hoạt động không chính xác hoặc không hoạt động như dự kiến, hoặc có người có thể truy cập, lạm dụng hoặc sử dụng sai trái thông tin mà không phải lỗi của chúng tôi. Tuy nhiên chúng tôi sẽ triển khai các biện pháp bảo mật hợp lý để bảo vệ dữ liệu cá nhân của bạn theo quy định của các quy định của pháp luật về bảo vệ bí mật thông tin cá nhân; tuy nhiên không thể đảm bảo sự bảo mật tuyệt đối chẳng hạn như trường hợp tiết lộ trái phép phát sinh từ hoạt động tin tặc vì ý đồ xấu hoặc hành vi tấn cung tinh vi bưởi kẻ xấu mà không phải lỗi của chúng tôi.',
      ],
    }
  ];

  Widget _buildItemIntroScreen3() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: sections2.length,
        itemBuilder: (context, index) {
          return section2(
              sections2[index]['title'], sections2[index]['content']);
        },
      ),
    );
  }

  Widget section2(String title, List<String> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyles.h5.bold),
        Divider(
          thickness: 0.5,
          color: ColorPalette.primaryColor,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content
              .map((text) => ExpandableText(
                    text,
                    expandText: 'Xem thêm',
                    linkColor: Colors.blue,
                    collapseText: 'Thu gọn',
                    maxLines: 5,
                  ))
              .toList(),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> sections2 = [
    {
      'title': '1. Giới thiệu',
      'content': [
        '1.1. Chào mừng bạn đến với sàn giao dịch thương mại điện tử FRS qua giao diện website hoặc ứng dụng di động (“Trang FRS”). Trước khi sử dụng Trang FRS hoặc tạo tài khoản FRS (“Tài Khoản”), vui lòng đọc kỹ các Điều Khoản Dịch Vụ dưới đây và Quy Chế Hoạt Động Sàn Giao Dịch Thương Mại Điện Tử FRS để hiểu rõ quyền lợi và nghĩa vụ hợp pháp của mình đối với Công ty TNHH FRS và các công ty liên kết và công ty con của FRS (sau đây được gọi riêng là “FRS”, gọi chung là “chúng tôi”, “của chúng tôi”). “Dịch Vụ” chúng tôi cung cấp hoặc sẵn có bao gồm (a) Trang FRS, (b) các dịch vụ được cung cấp bởi Trang FRS và bởi phần mềm dành cho khách hàng của FRS có sẵn trên Trang FRS, và (c) tất cả các thông tin, đường dẫn, tính năng, dữ liệu, văn bản, hình ảnh, biểu đồ, âm nhạc, âm thanh, video (bao gồm cả các đoạn video được đăng tải trực tiếp theo thời gian thực (livestream)), tin nhắn, tags, nội dung, chương trình, phần mềm, ứng dụng dịch vụ (bao gồm bất kỳ ứng dụng dịch vụ di động nào) hoặc các tài liệu khác có sẵn trên Trang FRS hoặc các dịch vụ liên quan đến Trang FRS (“Nội Dung”). Bất kỳ tính năng mới nào được bổ sung hoặc mở rộng đối với Dịch Vụ đều thuộc phạm vi điều chỉnh của Điều Khoản Dịch Vụ này. Điều Khoản Dịch Vụ này điều chỉnh việc bạn sử dụng Dịch Vụ cung cấp bởi FRS.',
        '\n1.2. Dịch Vụ bao gồm dịch vụ sàn giao dịch trực tuyến kết nối người tiêu dùng với nhau nhằm mang đến cơ hội kinh doanh giữa người mua (“Người Mua”) và người bán (“Người Bán”) (gọi chung là “bạn”, “Người Sử Dụng” hoặc “Các Bên”). Hợp đồng mua bán thật sự là trực tiếp giữa Người Mua và Người Bán. Các Bên liên quan đến giao dịch đó sẽ chịu trách nhiệm đối với hợp đồng mua bán giữa họ, việc đăng bán hàng hóa, bảo hành sản phẩm và tương tự. FRS không can thiệp vào giao dịch giữa các Người Sử Dụng. FRS có thể hoặc không sàng lọc trước Người Sử Dụng hoặc Nội Dung hoặc thông tin cung cấp bởi Người Sử Dụng. FRS bảo lưu quyền loại bỏ bất cứ Nội Dung hoặc thông tin nào trên Trang FRS theo Mục 6.4 bên dưới. FRS không bảo đảm cho việc các Người Sử Dụng sẽ thực tế hoàn thành giao dịch. Lưu ý, FRS sẽ là bên trung gian quản lý tình trạng hàng hóa và mua bán giữa Người Mua và Người Bán và quản lý vấn đề chuyển phát, trừ khi Người Mua và Người Bán thể hiện mong muốn tự giao dịch với nhau một cách rõ ràng.',
        '\n1.3. Trước khi trở thành Người Sử Dụng của Trang FRS, bạn cần đọc và chấp nhận mọi điều khoản và điều kiện được quy định trong, và dẫn chiếu đến, Điều Khoản Dịch Vụ này và Chính Sách Bảo Mật được dẫn chiếu theo đây.',
        '\n1.4. FRS bảo lưu quyền thay đổi, chỉnh sửa, tạm ngưng hoặc chấm dứt tất cả hoặc bất kỳ phần nào của Trang FRS hoặc Dịch Vụ vào bất cứ thời điểm nào theo quy định pháp luật. Phiên Bản thử nghiệm của Dịch Vụ hoặc tính năng của Dịch Vụ có thể không hoàn toàn giống với phiên bản cuối cùng.',
      ],
    },
    {
      'title': '\n2. Quyền riêng tư',
      'content': [
        '2.1. FRS coi trọng việc bảo mật thông tin của bạn. Để bảo vệ quyền lợi người dùng, FRS cung cấp Chính Sách Bảo Mật tại FRS.vn để giải thích chi tiết các hoạt động bảo mật của FRS. Vui lòng tham khảo Chính Sách Bảo Mật để biết cách thức FRS thu thập và sử dụng thông tin liên quan đến Tài Khoản và/hoặc việc sử dụng Dịch Vụ của Người Sử Dụng (“Thông Tin Người Sử Dụng”). Điều Khoản Dịch Vụ này có liên quan mật thiết với Chính Sách Bảo Mật. Bằng cách sử dụng Dịch Vụ hoặc cung cấp thông tin trên Trang FRS, Người Sử Dụng:\na. cho phép FRS thu thập, sử dụng, công bố và/hoặc xử lý các Nội Dung, dữ liệu cá nhân của bạn và Thông Tin Người Sử Dụng như được quy định trong Chính Sách Bảo Mật;\nb. đồng ý và công nhận rằng các thông tin được cung cấp trên Trang FRS sẽ thuộc sở hữu chung của bạn và FRS; và\nc. sẽ không, dù là trực tiếp hay gián tiếp, tiết lộ các Thông Tin Người Sử Dụng cho bất kỳ bên thứ ba nào, hoặc bằng bất kỳ phương thức nào cho phép bất kỳ bên thứ ba nào được truy cập hoặc sử dụng Thông Tin Người Dùng của bạn.',
        '\n2.2. Trường hợp Người Sử Dụng sở hữu dữ liệu cá nhân của Người Sử Dụng khác thông qua việc sử dụng Dịch Vụ (“Bên Nhận Thông Tin”) theo đây đồng ý rằng, mình sẽ (i) tuân thủ mọi quy định pháp luật về bảo vệ an toàn thông tin cá nhân liên quan đến những thông tin đó; (ii) cho phép Người Sử Dụng là chủ sở hữu của các thông tin cá nhân mà Bên Nhận Thông Tin thu thập được (“Bên Tiết Lộ Thông Tin”) được phép xóa bỏ thông tin của mình được thu thập từ cơ sở dữ liệu của Bên Nhận Thông Tin; và (iii) cho phép Bên Tiết Lộ Thông Tin rà soát những thông tin đã được thu thập về họ bởi Bên Nhận Thông Tin, phù hợp với hoặc theo yêu cầu của các quy định pháp luật hiện hành.',
      ],
    },
    {
      'title': '\n3. Giới hạn trách nhiệm',
      'content': [
        '3.1. FRS trao cho Người Sử Dụng quyền phù hợp để truy cập và sử dụng các Dịch Vụ theo các điều khoản và điều kiện được quy định trong Điều Khoản Dịch Vụ này. Tất cả các Nội Dung, thương hiệu, nhãn hiệu dịch vụ, tên thương mại, biểu tượng và tài sản sở hữu trí tuệ khác độc quyền (“Tài Sản Sở Hữu Trí Tuệ”) hiển thị trên Trang FRS đều thuộc sở hữu của FRS và bên sở hữu thứ ba, nếu có. Không một bên nào truy cập vào Trang FRS được cấp quyền hoặc cấp phép trực tiếp hoặc gián tiếp để sử dụng hoặc sao chép bất kỳ Tài Sản Sở Hữu Trí Tuệ nào, cũng như không một bên nào truy cập vào Trang FRS được phép truy đòi bất kỳ quyền, quyền sở hữu hoặc lợi ích nào liên quan đến Tài Sản Sở Hữu Trí Tuệ. Bằng cách sử dụng hoặc truy cập Dịch Vụ, bạn đồng ý tuân thủ các quy định pháp luật liên quan đến bản quyền, thương hiệu, nhãn hiệu dịch vụ hoặc bất cứ quy định pháp luật nào khác bảo vệ Dịch Vụ, Trang FRS và Nội Dung của Trang FRS. Bạn đồng ý không được phép sao chép, phát tán, tái bản, chuyển giao, công bố công khai, thực hiện công khai, sửa đổi, phỏng tác, cho thuê, bán, hoặc tạo ra các sản phẩm phái sinh của bất cứ phần nào thuộc Dịch Vụ, Trang FRS và Nội Dung của Trang FRS. Bạn không được nhân bản hoặc chỉnh sửa bất kỳ phần nào hoặc toàn bộ nội dung của Trang FRS trên bất kỳ máy chủ hoặc như là một phần của bất kỳ website nào khác mà chưa nhận được sự chấp thuận bằng văn bản của FRS. Ngoài ra, bạn đồng ý rằng bạn sẽ không sử dụng bất kỳ robot, chương trình do thám (spider) hay bất kỳ thiết bị tự động hoặc phương thức thủ công nào để theo dõi hoặc sao chép Nội Dung của FRS khi chưa có sự đồng ý trước bằng văn bản của FRS (sự chấp thuận này được xem như áp dụng cho các công cụ tìm kiếm cơ bản trên các website tìm kiếm trên mạng kết nối người dùng trực tiếp đến website đó).',
        '\n3.2. FRS cho phép kết nối từ website Người Sử Dụng đến Trang FRS, với điều kiện website của Người Sử Dụng không được hiểu là bất kỳ việc xác nhận hoặc liên quan nào đến FRS.',
      ],
    },
    {
      'title': '\n4. Phần mềm',
      'content': [
        'Bất kỳ phần mềm nào được cung cấp bởi FRS tới Người Sử Dụng đều thuộc phạm vi điều chỉnh của các Điều Khoản Dịch Vụ này. FRS bảo lưu tất cả các quyền liên quan đến phần mềm không được cấp một các rõ ràng bởi FRS theo đây. Bất kỳ tập lệnh hoặc mã code, liên kết đến hoặc dẫn chiếu từ Dịch Vụ, đều được cấp phép cho bạn bởi các bên thứ ba là chủ sở hữu của tập lệnh hoặc mã code đó chứ không phải bởi FRS.',
      ],
    },
    {
      'title': '\n5. Tài khoản bảo mật',
      'content': [
        '5.1. Một vài tính năng của Dịch Vụ chúng tôi yêu cầu phải đăng ký một Tài Khoản bằng cách lựa chọn một tên người sử dụng không trùng lặp (“Tên Đăng Nhập”) và mật khẩu đồng thời cung cấp một số thông tin cá nhân nhất định. Bạn có thể sử dụng Tài Khoản của mình để truy cập vào các sản phẩm, website hoặc dịch vụ khác mà FRS cho phép, có mối liên hệ hoặc đang hợp tác. FRS không kiểm tra và không chịu trách nhiệm đối với bất kỳ nội dung, tính năng năng, bảo mật, dịch vụ, chính sách riêng tư, hoặc cách thực hiện khác của các sản phẩm, website hay dịch vụ đó. Trường hợp bạn sử dụng Tài Khoản của mình để truy cập vào các sản phẩm, website hoặc dịch vụ khác mà FRS cho phép, có mối liên hệ hoặc đang hợp tác, các điều khoản dịch vụ của những sản phẩm, website hoặc dịch vụ đó, bao gồm các chính sách bảo mật tương ứng vẫn được áp dụng khi bạn sử dụng các sản phẩm, website hoặc dịch vụ đó ngay cả khi những điều khoản dịch vụ này khác với Điều Khoản Dịch Vụ và/hoặc Chính Sách Bảo Mật của FRS.',
        '\n5.2. Bạn đồng ý (a) giữ bí mật mật khẩu và chỉ sử dụng Tên Đăng Nhập và mật khẩu khi đăng nhập, (b) đảm bảo bạn sẽ đăng xuất khỏi tài khoản của mình sau mỗi phiên đăng nhập trên Trang FRS, và (c) thông báo ngay lập tức với FRS nếu phát hiện bất kỳ việc sử dụng trái phép nào đối với Tài Khoản, Tên Đăng Nhập và/hoặc mật khẩu của bạn. Bạn phải chịu trách nhiệm với hoạt động dưới Tên Đăng Nhập và Tài Khoản của mình, bao gồm tổn thất hoặc thiệt hại phát sinh từ việc sử dụng trái phép liên quan đến mật khẩu hoặc từ việc không tuân thủ Điều Khoản này của Người Sử Dụng.',
        '\n5.3. Bạn đồng ý rằng FRS có toàn quyền xóa Tài Khoản và Tên Đăng Nhập của Người Sử Dụng ngay lập tức, gỡ bỏ hoặc hủy từ Trang FRS bất kỳ Nội Dung nào liên quan đến Tài Khoản và Tên Đăng Nhập của Người Sử Dụng với bất kỳ lý do nào mà có hoặc không cần thông báo hay chịu trách nhiệm với Người Sử Dụng hay bên thứ ba nào khác. Căn cứ để thực hiện các hành động này có thể bao gồm (a) Tài Khoản và Tên Đăng Nhập không hoạt động trong thời gian dài, (b) vi phạm điều khoản hoặc tinh thần của các Điều Khoản Dịch Vụ này, (c) có hành vi bất hợp pháp, lừa đảo, quấy rối, xâm phạm, đe dọa hoặc lạm dụng, (d) có nhiều tài khoản người dùng khác nhau, (e) mua sản phẩm trên Trang FRS với mục đích kinh doanh, (f) mua hàng số lượng lớn từ một Người Bán hoặc một nhóm Người Bán có liên quan, (g) lạm dụng mã giảm giá hoặc tài trợ hoặc quyền lợi khuyến mại (bao gồm việc bán mã giảm giá cho các bên thứ ba cũng như lạm dụng mã giảm giá ở Trang FRS), (h) có hành vi gây hại tới những Người Sử Dụng khác, các bên thứ ba hoặc các lợi ích kinh tế của FRS. Việc sử dụng Tài Khoản cho các mục đích bất hợp pháp, lừa đảo, quấy rối, xâm phạm, đe dọa hoặc lạm dụng có thể được gửi cho cơ quan nhà nước có thẩm quyền theo quy định pháp luật.',
      ],
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              _buildItemIntroScreen1(),
              _buildItemIntroScreen2(),
              _buildItemIntroScreen3(),
            ],
          ),
          Positioned(
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                        dotWidth: kMinPadding5,
                        dotHeight: kMinPadding5,
                        activeDotColor: Colors.black),
                  ),
                ),
                StreamBuilder<int>(
                  initialData: 0,
                  stream: _pageStreamController.stream,
                  builder: (context, snapshot) {
                    return Expanded(
                      flex: 4,
                      child: ButtonWidget(
                        onTap: () {
                          if (_pageController.page != 2) {
                            _pageController.nextPage(
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          } else {
                            Navigator.of(context).pushNamed(MainApp.routeName);
                          }
                        },
                        height: 40,
                        title: snapshot.data != 2 ? 'Next' : ' Get started',
                        size: 18,
                      ),
                    );
                  },
                )
              ],
            ),
            left: kMediumPadding24,
            right: kMediumPadding24,
            bottom: kMediumPadding24 * 3,
          )
        ],
      ),
    );
  }
}
