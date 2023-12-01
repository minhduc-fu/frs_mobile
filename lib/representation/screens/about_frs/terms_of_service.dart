import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});
  static const String routeName = '/terns_of_service';

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
          'Điều khoản dịch vụ',
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
