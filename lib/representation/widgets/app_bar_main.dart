import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/api/firebase_api.dart';
import 'package:frs_mobile/representation/screens/notification_screen.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/constants/color_constants.dart';
import '../../core/constants/textstyle_constants.dart';

class AppBarMain extends StatefulWidget {
  const AppBarMain({
    super.key,
    required this.child,
    this.titleAppbar,
    required this.leading,
  });
  final Widget child;
  final String? titleAppbar;
  final Widget leading;

  @override
  State<AppBarMain> createState() => _AppBarMainState();
}

class _AppBarMainState extends State<AppBarMain> {
  @override
  void initState() {
    super.initState();
    fetchNotifications();
    FirebaseMessaging.onMessage.listen(handleForegroundNotification);
  }

  Future<void> updateNotifications() async {
    int? accountID = AuthProvider.userModel?.accountID;
    final notifications = await FirebaseApi.getNotifications(accountID!);
    updateUnreadNotificationCount(notifications);
  }

  void handleForegroundNotification(RemoteMessage message) {
    if (mounted) {
      setState(() {
        unreadNotificationCount += 1;
      });
    }
  }

  int unreadNotificationCount = 0;
  void updateUnreadNotificationCount(List<dynamic> notifications) {
    setState(() {
      unreadNotificationCount = notifications.where((n) => !n['read']).length;
    });
  }

  Future<void> fetchNotifications() async {
    try {
      int? accountID = AuthProvider.userModel?.accountID;
      final notifications = await FirebaseApi.getNotifications(accountID!);
      updateUnreadNotificationCount(notifications);
      // print('Notifications: $notifications');
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 56,
          child: AppBar(
            leading: widget.leading,
            title: Text(
              widget.titleAppbar ?? '',
              style: TextStyles.h5.bold.setTextSize(19),
            ),
            backgroundColor: ColorPalette.backgroundScaffoldColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () async {
                    // fetchNotifications();
                    await Navigator.pushNamed(
                        context, NotificationScreen.routeName);
                    await updateNotifications();
                  },
                  // child: badges.Badge(
                  //   position: badges.BadgePosition.topEnd(top: -10, end: -12),
                  //   showBadge: true,
                  //   ignorePointer: false,
                  //   onTap: () {},
                  //   badgeContent:
                  //       Icon(Icons.check, color: Colors.white, size: 10),
                  //   badgeAnimation: badges.BadgeAnimation.rotation(
                  //     animationDuration: Duration(seconds: 1),
                  //     colorChangeAnimationDuration: Duration(seconds: 1),
                  //     loopAnimation: false,
                  //     curve: Curves.fastOutSlowIn,
                  //     colorChangeAnimationCurve: Curves.easeInCubic,
                  //   ),
                  //   badgeStyle: badges.BadgeStyle(
                  //     shape: badges.BadgeShape.square,
                  //     badgeColor: Colors.blue,
                  //     padding: EdgeInsets.all(5),
                  //     borderRadius: BorderRadius.circular(4),
                  //     borderSide: BorderSide(color: Colors.white, width: 2),
                  //     borderGradient: badges.BadgeGradient.linear(
                  //         colors: [Colors.red, Colors.black]),
                  //     badgeGradient: badges.BadgeGradient.linear(
                  //       colors: [Colors.blue, Colors.yellow],
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //     ),
                  //     elevation: 0,
                  //   ),
                  //   child: Text('Badge'),
                  // )
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: 0, end: 3),
                    badgeContent: Text(
                      unreadNotificationCount.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(
                      FontAwesomeIcons.bell,
                      size: 20,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 56),
          child: widget.child,
        ),
      ],
    );
  }
}
