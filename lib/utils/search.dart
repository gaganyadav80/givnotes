import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 49 * hm,
        // width: double.infinity,
        width: 94.9 * wm,
        child: Lottie.asset('assets/animations/search-2.json'),
      ),
    );
  }
}
