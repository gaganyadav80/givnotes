import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

class TodoTimeline extends StatefulWidget {
  TodoTimeline({Key key}) : super(key: key);

  @override
  _TodoTimelineState createState() => _TodoTimelineState();
}

class _TodoTimelineState extends State<TodoTimeline> {
  bool someBooleanValue = false;
  final Color _blueColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          splashRadius: 25.0,
          icon: Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => print("move date backward"),
        ),
        centerTitle: true,
        title: Text(
          DateFormat('dd-MMM-yyyy - EEEE').format(DateTime.now()),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            color: const Color(0xff32343D),
          ),
        ),
        actions: [
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 56.0),
            child: IconButton(
              splashRadius: 25.0,
              icon: Icon(CupertinoIcons.forward, color: Colors.black),
              onPressed: () => print("move date forward"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Timeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            indicatorTheme: IndicatorThemeData(position: 0, size: 28.0),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: 10,
            contentsBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(left: 15.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Create Task",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                      ),
                    ),
                    Row(
                      children: [
                        Text("\u{1F525} Priority"),
                        SizedBox(width: 10.0),
                        Icon(Icons.check_circle_outline_outlined, size: 16.0),
                        SizedBox(width: 5.0),
                        Text("1/2"),
                        SizedBox(width: 10.0),
                        Icon(Icons.access_time_outlined, size: 16.0),
                        SizedBox(width: 5.0),
                        Text("10:49"),
                      ],
                    ),
                    Container(
                      width: 50.0,
                      margin: EdgeInsets.fromLTRB(0, 8, 5, 0),
                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    FixedTimeline.tileBuilder(
                      theme: TimelineThemeData(nodePosition: 0),
                      builder: TimelineTileBuilder.connected(
                        itemCount: 2,
                        contentsBuilder: (_, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Sub Task ${index + 1}",
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, fontFamily: 'Roboto'),
                                ),
                              ],
                            ),
                          );
                        },
                        indicatorBuilder: (_, index) => DotIndicator(
                          size: 20.0,
                          color: Colors.transparent,
                          child: CircularCheckBox(
                            value: someBooleanValue,
                            radius: 10.0,
                            width: 12.0,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: _blueColor,
                            inactiveColor: _blueColor,
                            onChanged: (bool x) {
                              setState(() => someBooleanValue = !someBooleanValue);
                            },
                          ),
                        ),
                        connectorBuilder: (_, index, ___) => SolidLineConnector(endIndent: 8.0),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              return DotIndicator(
                size: 30.0,
                color: Colors.transparent,
                child: CircularCheckBox(
                  value: someBooleanValue,
                  radius: 13.0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: _blueColor,
                  inactiveColor: _blueColor,
                  onChanged: (bool x) {
                    setState(() {
                      someBooleanValue = !someBooleanValue;
                    });
                  },
                ),
              );
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(indent: 5.0, endIndent: 5.0),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        color: Colors.lightBlue,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.calendar),
            SizedBox(width: 20.0),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 30,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 16.0),
                    child: Text("${index + 1}"),
                  );
                },
              ),
            ),
            SizedBox(width: 20.0),
            Icon(CupertinoIcons.up_arrow),
          ],
        ),
      ),
    );
  }
}
