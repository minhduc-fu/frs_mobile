import 'package:flutter/cupertino.dart';

class ProductOwnerMainScreen extends StatefulWidget {
  const ProductOwnerMainScreen({super.key});
  static const String routeName = '/productowner_main_screen';
  @override
  State<ProductOwnerMainScreen> createState() => _ProductOwnerMainScreenState();
}

class _ProductOwnerMainScreenState extends State<ProductOwnerMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('ProductOwner'),
    );
  }
}
