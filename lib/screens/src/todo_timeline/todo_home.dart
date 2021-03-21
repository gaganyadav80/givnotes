import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'package:givnotes/screens/src/todo_timeline/create_todo.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/database/database.dart';
import 'package:timelines/timelines.dart';

class TodoTimeline extends StatefulWidget {
  TodoTimeline({Key key}) : super(key: key);

  @override
  _TodoTimelineState createState() => _TodoTimelineState();
}

class _TodoTimelineState extends State<TodoTimeline> {
  final HiveDBServices _dbServices = HiveDBServices();
  DateTime appBarDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
        //TODO don't use valueListenable... use hydratedBloc
        child: ValueListenableBuilder(
          valueListenable: Hive.box<TodoModel>('givtodos').listenable(),
          builder: (BuildContext context, Box<TodoModel> box, Widget child) {
            final List<TodoModel> _todosBox = box.values.where((element) => element.dueDate.day == appBarDate.day).toList();
            final int pending = box.values.where((element) => element.dueDate.day < DateTime.now().day).length;
            final int upcoming = box.values.where((element) => element.dueDate.day > DateTime.now().day).length;

            return Column(
              children: [
                appBarDate.day == DateTime.now().day
                    ? Hero(
                        tag: "today-view",
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildTodayView(pending, "Pending"),
                              _buildTodayView(_todosBox.length, "Today"),
                              _buildTodayView(upcoming, "Upcoming"),
                            ],
                          ),
                        ),
                      )
                    : Hero(tag: "today-view", child: SizedBox.shrink()),
                _todosBox.length == 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: Image.network(
                            "https://image.freepik.com/free-vector/list-concept-illustration_114360-1208.jpg",
                            height: 300.0,
                            width: 300.0,
                          ).rotate(5.0),
                        ),
                      )
                    : Expanded(
                        child: Timeline.tileBuilder(
                          theme: TimelineThemeData(
                            nodePosition: 0,
                            indicatorTheme: IndicatorThemeData(position: 0, size: 28.0),
                          ),
                          builder: TimelineTileBuilder.connected(
                            connectionDirection: ConnectionDirection.before,
                            itemCount: _todosBox.length,
                            contentsBuilder: (_, int index) {
                              int taskCompleted = 0;
                              _todosBox[index].subTask.forEach((element) {
                                if (element.completed) taskCompleted++;
                              });

                              return Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CreateTodo(
                                          editTodo: true,
                                          category: _todosBox[index].category,
                                          completed: _todosBox[index].completed,
                                          description: _todosBox[index].description,
                                          dueDate: _todosBox[index].dueDate,
                                          index: _todosBox[index].key,
                                          priority: _todosBox[index].priority,
                                          subTask: _todosBox[index].subTask,
                                          title: _todosBox[index].title,
                                          uuid: _todosBox[index].uuid,
                                        ).materialRoute());
                                  },
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _todosBox[index].title,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text("\u{1F525} ${_todosBox[index].priority ?? "None"}"),
                                            SizedBox(width: 10.0),
                                            Icon(Icons.check_circle_outline_outlined, size: 16.0),
                                            SizedBox(width: 5.0),
                                            Text("$taskCompleted/${_todosBox[index].subTask.length}"),
                                            SizedBox(width: 10.0),
                                            Icon(Icons.access_time_outlined, size: 16.0),
                                            SizedBox(width: 5.0),
                                            Text(DateFormat("HH:mm").format(_todosBox[index].dueDate)),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 8, 5, 0),
                                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                          decoration: BoxDecoration(
                                            color: _todosBox[index].category.values.first == null ? Colors.pink : Color(_todosBox[index].category.values.first),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _todosBox[index].category.keys.first ?? "",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          _todosBox[index].description,
                                        ),
                                        SizedBox(height: 10.0),
                                        _buildSubTaskTimeline(_todosBox[index]),
                                        SizedBox(height: 20.0),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            indicatorBuilder: (_, index) {
                              return DotIndicator(
                                size: 30.0,
                                color: Colors.transparent,
                                child: GFCheckbox(
                                  size: GFSize.SMALL,
                                  activeBgColor: GFColors.DANGER,
                                  type: GFCheckboxType.circle,
                                  onChanged: (_) {
                                    _todosBox[index].completed = !_todosBox[index].completed;
                                    _dbServices.updateTodo(_todosBox[index].key, _todosBox[index]);
                                  },
                                  value: _todosBox[index].completed,
                                  inactiveIcon: null,
                                ),
                                // child: CircularCheckBox(
                                //   value: _todosBox[index].completed,
                                //   radius: 13.0,
                                //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                //   activeColor: Colors.blue,
                                //   inactiveColor: Colors.blue,
                                //   onChanged: (bool x) {
                                //     _todosBox[index].completed = !_todosBox[index].completed;
                                //     _dbServices.updateTodo(_todosBox[index].key, _todosBox[index]);
                                //   },
                                // ),
                              );
                            },
                            connectorBuilder: (_, index, ___) => SolidLineConnector(indent: 5.0, endIndent: 5.0),
                            lastConnectorBuilder: (context) => SolidLineConnector(indent: 5.0, endIndent: 10.0),
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Material _buildTodayView(int number, String title) => Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          height: 110.0,
          width: 100.0,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: ["$number".text.size(22.0).bold.make(), title.text.semiBold.make()],
          ),
        ),
      );

  Widget _buildSubTaskTimeline(TodoModel _todo) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(nodePosition: 0),
      builder: TimelineTileBuilder.connected(
        itemCount: _todo.subTask.length,
        contentsBuilder: (_, int subtaskIndex) {
          return Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _todo.subTask[subtaskIndex].subTask,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, fontFamily: 'Roboto'),
                ),
              ],
            ),
          );
        },
        indicatorBuilder: (_, int subCheckIndex) => DotIndicator(
          size: 20.0,
          color: Colors.transparent,
          child: GFCheckbox(
            size: GFSize.SMALL,
            activeBgColor: GFColors.DANGER,
            type: GFCheckboxType.circle,
            onChanged: (_) {
              _todo.subTask[subCheckIndex].setComplete(!_todo.subTask[subCheckIndex].completed);
              _dbServices.updateTodo(_todo.key, _todo);
            },
            value: _todo.subTask[subCheckIndex].completed,
            inactiveIcon: null,
          ),
          // child: CircularCheckBox(
          //   value: _todo.subTask[subCheckIndex].completed,
          //   radius: 10.0,
          //   width: 12.0,
          //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //   activeColor: Colors.blue,
          //   inactiveColor: Colors.blue,
          //   onChanged: (bool x) {
          //     _todo.subTask[subCheckIndex].setComplete(!_todo.subTask[subCheckIndex].completed);
          //     _dbServices.updateTodo(_todo.key, _todo);
          //   },
          // ),
        ),
        connectorBuilder: (_, index, ___) => SolidLineConnector(endIndent: 8.0),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              splashRadius: 25.0,
              icon: Icon(CupertinoIcons.back, color: Colors.black),
              onPressed: () {
                //TODO flag
                setState(() => appBarDate = appBarDate.subtract(Duration(days: 1)));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                DateFormat('dd-MMM-yyyy - EEEE').format(appBarDate),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                  color: appBarDate.day == DateTime.now().day
                      ? const Color(0xff32343D)
                      : appBarDate.day > DateTime.now().day
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ),
            IconButton(
              splashRadius: 25.0,
              icon: Icon(CupertinoIcons.forward, color: Colors.black),
              onPressed: () {
                //TODO flag
                setState(() => appBarDate = appBarDate.add(Duration(days: 1)));
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            iconSize: 18.0,
            splashRadius: 25.0,
            icon: Icon(Icons.view_agenda_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      );
}
