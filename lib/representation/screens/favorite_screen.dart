import 'package:demo_frs_app/representation/widgets/app_bar_container.dart';
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
    return AppBarContainer(
      child: Scaffold(),
    );
  }
}
