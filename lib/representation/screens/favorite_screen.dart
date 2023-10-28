import 'package:flutter/material.dart';
import '../../utils/asset_helper.dart';
import '../../utils/image_helper.dart';
import '../widgets/app_bar_main.dart';

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
