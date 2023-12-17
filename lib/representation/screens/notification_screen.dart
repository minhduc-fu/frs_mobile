import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/api/firebase_api.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/services/authprovider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const String routeName = '/notification_screen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<dynamic>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    notificationsFuture =
        FirebaseApi.getNotifications(AuthProvider.userModel!.accountID);
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
        centerTitle: true,
        title: Text(
          'Thông báo',
          style: TextStyles.h5.bold.setTextSize(19),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<dynamic> notifications = snapshot.data ?? [];
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (var notification in notifications)
                    ListTile(
                      title: Text(notification['title'].toString()),
                      subtitle: Text(notification['message'].toString()),
                      // Add other components based on the structure of the notification
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
