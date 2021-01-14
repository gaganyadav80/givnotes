import 'dart:math';

import 'package:flutter/material.dart';
import 'package:givnotes/database/database.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'models/CustomCheckboxTile.dart';
import 'objects/ColorChoice.dart';

class DetailPage extends StatefulWidget {
  DetailPage({@required this.todoObject, Key key}) : super(key: key);

  final TodoModel todoObject;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  double percentComplete;
  AnimationController animationBar;
  double barPercent = 0.0;
  Tween<double> animT;
  AnimationController scaleAnimation;

  DateTime currentDate;

  @override
  void initState() {
    scaleAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 1000), lowerBound: 0.0, upperBound: 1.0);

    percentComplete = widget.todoObject.percentComplete();
    barPercent = percentComplete;
    animationBar = AnimationController(vsync: this, duration: Duration(milliseconds: 100))
      ..addListener(() {
        setState(() {
          barPercent = animT.transform(animationBar.value);
        });
      });
    animT = Tween<double>(begin: percentComplete, end: percentComplete);
    scaleAnimation.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    animationBar.dispose();
    scaleAnimation.dispose();
    widget.todoObject.save();
  }

  void updateBarPercent() async {
    double newPercentComplete = widget.todoObject.percentComplete();
    if (animationBar.status == AnimationStatus.forward || animationBar.status == AnimationStatus.completed) {
      animT.begin = newPercentComplete;
      await animationBar.reverse();
    } else {
      animT.end = newPercentComplete;
      await animationBar.forward();
    }
    percentComplete = newPercentComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: widget.todoObject.uuid + "_background",
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Hero(
              tag: widget.todoObject.uuid + "_backIcon",
              child: Material(
                color: Colors.transparent,
                type: MaterialType.transparency,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            actions: <Widget>[
              Hero(
                tag: widget.todoObject.uuid + "_more_vert",
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context) => <PopupMenuEntry<TodoCardSettings>>[
                      PopupMenuItem(
                        child: Text("Edit Color"),
                        value: TodoCardSettings.edit_color,
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: TodoCardSettings.delete,
                      ),
                    ],
                    onSelected: (setting) {
                      if (setting == TodoCardSettings.edit_color) {
                        setState(() {
                          widget.todoObject.color = ColorChoices.choices[Random().nextInt(6)].value;
                          widget.todoObject.save();
                        });
                      } else {
                        print('delete clicked');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.uuid + "_icon",
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            IconData(widget.todoObject.icon, fontFamily: 'MaterialIcons'),
                            color: Color(widget.todoObject.color),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 12.0),
                //   child: Align(
                //     alignment: Alignment.bottomLeft,
                //     child:
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Hero(
                          tag: widget.todoObject.uuid + "_title",
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.todoObject.category,
                              style: TextStyle(fontSize: 30.0),
                              softWrap: false,
                            ),
                          ),
                        ),
                        Hero(
                          tag: widget.todoObject.uuid + "_number_of_tasks",
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.todoObject.taskAmount().toString() + " Tasks",
                              style: TextStyle(),
                              softWrap: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.uuid + "_progress_bar",
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: LinearProgressIndicator(
                                value: barPercent,
                                backgroundColor: Colors.grey.withAlpha(50),
                                valueColor: AlwaysStoppedAnimation<Color>(Color(widget.todoObject.color)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text((barPercent * 100).round().toString() + "%"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Hero(
                    tag: widget.todoObject.uuid + "_just_a_test",
                    child: Material(
                      type: MaterialType.transparency,
                      child: FadeTransition(
                        opacity: scaleAnimation,
                        child: ScaleTransition(
                          scale: scaleAnimation,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: widget.todoObject.tasks.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (currentDate != widget.todoObject.tasks[index].date) {
                                currentDate = widget.todoObject.tasks[index].date;
                                DateTime _now = DateTime.now();
                                DateTime today = DateTime(_now.year, _now.month, _now.day);
                                String dateString;
                                if (currentDate.isBefore(today.subtract(Duration(days: 7)))) {
                                  dateString = DateFormat.yMMMMEEEEd().format(currentDate);
                                } else if (currentDate.isBefore(today)) {
                                  dateString = "Previous - " + DateFormat.E().format(currentDate);
                                } else if (currentDate.isAtSameMomentAs(today)) {
                                  dateString = "Today";
                                } else if (currentDate.isAtSameMomentAs(today.add(Duration(days: 1)))) {
                                  dateString = "Tomorrow";
                                } else {
                                  dateString = DateFormat.E().format(currentDate);
                                }
                                List<Widget> tasks = [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(dateString, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                                  )
                                ];
                                widget.todoObject.tasks.forEach((task) {
                                  if (task.date.isAtSameMomentAs(currentDate)) {
                                    tasks.add(CustomCheckboxListTile(
                                      activeColor: Color(widget.todoObject.color),
                                      value: task.isCompleted(),
                                      onChanged: (value) async {
                                        setState(() {
                                          task.setComplete(value);
                                          updateBarPercent();
                                        });
                                      },
                                      title: Text(task.task),
                                      secondary: Icon(Icons.alarm),
                                    ));
                                  }
                                });
                                // widget.todoObject.tasks[currentDate].forEach((task) {
                                //   tasks.add(CustomCheckboxListTile(
                                //     activeColor: widget.todoObject.color,
                                //     value: task.isCompleted(),
                                //     onChanged: (value) {
                                //       setState(() {
                                //         task.setComplete(value);
                                //         updateBarPercent();
                                //       });
                                //     },
                                //     title: Text(task.task),
                                //     secondary: Icon(Icons.alarm),
                                //   ));
                                // });
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: tasks,
                                );
                              } else
                                return SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
