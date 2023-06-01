import 'package:flutter/material.dart';
import 'package:notable/widgets/mydrawer.dart';

class Trash extends StatelessWidget {
  const Trash({super.key});

//trash route name
  static const routeName = '/trash-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Trash'),
      ),
      drawer: const MyDrawer(),
    );
  }
}
