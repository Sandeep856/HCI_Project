import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Fit extends StatefulWidget {
  const Fit({Key? key}) : super(key: key);

  @override
  State<Fit> createState() => _FitState();
}

class _FitState extends State<Fit> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}