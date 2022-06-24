import 'package:flutter/cupertino.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key}) : super(key: key);

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text("Material"),
      ),
    );
  }
}
