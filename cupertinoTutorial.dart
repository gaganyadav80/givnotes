import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(GoplinHomePage());

class GoplinHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: true,
      tabBar: CupertinoTabBar(
        currentIndex: 0,
        backgroundColor: Color.fromARGB(500, 26, 26, 26),
        iconSize: 25,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.bookmark,
              color: CupertinoColors.white,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.search,
              color: CupertinoColors.white,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.add_circled_solid,
              color: Color.fromARGB(500, 0, 168, 47),
              size: 45,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.collections,
              color: CupertinoColors.white,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.settings,
              color: CupertinoColors.white,
              size: 33,
            ),
          ),
        ],
      ),
      tabBuilder: (context, i) {
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(i == 0 ? 'All Notes' : 'New Note'),
              ),
              child: Center(
                child: CupertinoButton(
                  child: Text(
                    'This is tab, $i',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(fontSize: 32),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) {
                          return DetailScreen(
                              i == 0 ? 'All Notes' : 'New Note');
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen(this.topic);
  final String topic;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Details'),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'A switch',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  CupertinoSwitch(
                    value: switchValue,
                    onChanged: (value) {
                      setState(() {
                        switchValue = value;
                      });
                    },
                  ),
                ],
              ),
              CupertinoButton(
                child: Text('Action Sheet'),
                onPressed: () {
                  showCupertinoModalPopup<int>(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        title: Text('Some Choices'),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Text('One !'),
                            onPressed: () {
                              Navigator.pop(context, 1);
                            },
                            isDefaultAction: true,
                          ),
                          CupertinoActionSheetAction(
                            child: Text('Two !'),
                            onPressed: () {
                              Navigator.pop(context, 2);
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text('Three !'),
                            onPressed: () {
                              Navigator.pop(context, 3);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// *** EXtra items

// *** Custom AppBar using the Scaffold appbar widget
//class CustomAppBar2 extends StatelessWidget with PreferredSizeWidget {
//  String _title;
//  CustomAppBar2(this._title);
//
//  @override
//  Size get preferredSize => Size.fromHeight(80);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(13),
//        color: Colors.black,
//      ),
//      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
//      height: 80,
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          AppBar(
//            elevation: 40,
//            title: Text(
//              _title,
//              style: TextStyle(
//                color: Colors.white,
//                fontSize: 20,
//                fontFamily: 'SourceSansPro-Light',
//                letterSpacing: 3,
//              ),
//            ),
//            backgroundColor: Colors.black,
//          ),
//        ],
//      ),
//    );
//  }
//}