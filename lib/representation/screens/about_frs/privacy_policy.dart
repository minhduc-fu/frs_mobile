import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});
  static const String routeName = '/privacy_policy';

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
        centerTitle: true,
        title: Text(
          'Chính sách bảo mật',
          style: TextStyles.h5.bold.setTextSize(19),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            return section(
                sections[index]['title'], sections[index]['content']);
          },
        ),
      ),
    );
  }
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
