import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/api/firebase_api.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
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

    markNotificationsAsRead();
  }

  Future<void> markNotificationsAsRead() async {
    int? accountID = AuthProvider.userModel?.accountID;

    try {
      await FirebaseApi.readNotification(accountID!);
      print('Notifications marked as read successfully');
    } catch (e) {
      print('Error marking notifications as read: $e');
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
            return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${notification['title'].toString()}',
                            style: TextStyles.defaultStyle.bold,
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${notification['message'].toString()}',
                            style: TextStyles.defaultStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                });

            // SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       for (var notification in notifications)
            //         Container(
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(kDefaultCircle14),
            //               color: Colors.white),
            //           child: ListTile(
            //             title: Text(notification['title'].toString()),
            //             subtitle: Text(notification['message'].toString()),
            //             // Add other components based on the structure of the notification
            //           ),
            //         ),
            //     ],
            //   ),
            // );
          }
        },
      ),
    );
  }
}
