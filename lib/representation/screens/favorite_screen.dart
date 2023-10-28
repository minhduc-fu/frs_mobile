import 'package:demo_frs_app/representation/widgets/app_bar_main.dart';
import 'package:demo_frs_app/utils/asset_helper.dart';
import 'package:demo_frs_app/utils/image_helper.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  static const String routeName = '/favorite_screen';
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBarMain(
      leading: ImageHelper.loadFromAsset(AssetHelper.imageLogoFRS),
      child: Scaffold(),
    );
  }
}
