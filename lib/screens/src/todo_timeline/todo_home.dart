import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:givnotes/widgets/circular_loading.dart';
import 'package:givnotes/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/routes.dart';

import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'bloc/todo_state.dart';
import 'todo_widgets.dart';
import 'src/todo_model.dart';

//TODO flag - appBarDate is global
DateTime appBarDate = DateTime.now();
TodoTimelineState todoTimelineState;

class TodoTimelineBloc extends StatefulWidget {
  TodoTimelineBloc({Key key}) : super(key: key);

  @override
  TodoTimelineState createState() => TodoTimelineState();
}

class TodoTimelineState extends State<TodoTimelineBloc> {
  @override
  void initState() {
    super.initState();
    todoTimelineState = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                //TODO flag use getX @Gagan
                setState(() => appBarDate = appBarDate.subtract(Duration(days: 1)));
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Text(
                DateFormat('dd-MMM-yyyy - EEEE').format(appBarDate),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0.w,
                  color: appBarDate.day == DateTime.now().day && appBarDate.month == DateTime.now().month
                      ? const Color(0xff32343D)
                      : appBarDate.isAfter(DateTime.now())
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ),
            IconButton(
              splashRadius: 25.0,
              icon: Icon(CupertinoIcons.forward, color: Colors.black),
              onPressed: () {
                setState(() => appBarDate = appBarDate.add(Duration(days: 1)));
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            iconSize: 18.0.w,
            splashRadius: 25.0,
            icon: Icon(Icons.view_agenda_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoading) {
              return Center(
                child: CircularLoading(),
              );
            } else if (state is TodosLoaded) {
              //TODO maybe remove - delete todo older than 5 days
              state.todos.forEach((element) {
                if (element.dueDate.toDate().difference(DateTime.now()) > Duration(days: 5)) {
                  if (element.completed) {
                    BlocProvider.of<TodosBloc>(context).add(DeleteTodo(element.id));
                  }
                }
              });

              final List<TodoModel> _todosBox =
                  state.todos.where((element) => element.dueDate.toDate().day == appBarDate.day).toList();
              final int pending =
                  state.todos.where((element) => element.dueDate.toDate().day < DateTime.now().day).length;
              final int upcoming =
                  state.todos.where((element) => element.dueDate.toDate().day > DateTime.now().day).length;

              return Column(
                children: [
                  appBarDate.day == DateTime.now().day && appBarDate.month == DateTime.now().month
                      ? Hero(
                          tag: "today-view",
                          child: Padding(
                            padding: EdgeInsets.only(top: 5.0.w, bottom: 10.0.w),
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
                  SizedBox(height: 10.w),
                  _todosBox.length == 0
                      ? Expanded(
                          child: Center(
                            child: Image.asset(
                              "assets/giv_img/empty_todo_light.png",
                              width: 300.0.w,
                            ).pOnly(bottom: 30.h),
                          ),
                        )
                      : Expanded(
                          child: Timeline.tileBuilder(
                            theme: TimelineThemeData(
                              nodePosition: 0,
                              indicatorTheme: IndicatorThemeData(position: 0, size: 28.0.w),
                            ),
                            builder: TimelineTileBuilder.connected(
                              connectionDirection: ConnectionDirection.before,
                              itemCount: _todosBox.length,
                              contentsBuilder: (_, int index) {
                                final TodoModel todo = _todosBox[index];

                                int taskCompleted = 0;
                                todo.subTask.forEach((element) {
                                  if (element.containsValue(true)) taskCompleted++;
                                });

                                return Container(
                                  margin: EdgeInsets.only(left: 5.0.w, bottom: 10.0.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0.r),
                                    color: todo.completed ? Colors.grey[300] : Colors.transparent,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            RouterName.createTodoRoute,
                                            arguments: [true, todo.id, todo],
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5.0.w, top: 5.0.w, right: 10.0.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                todo.title.decrypt,
                                                style: TextStyle(
                                                  fontSize: 22.0.w,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Roboto",
                                                  decoration:
                                                      todo.completed ? TextDecoration.lineThrough : TextDecoration.none,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    todo.priority.decrypt.isNotEmpty
                                                        ? "\u{1F525} ${todo.priority.decrypt}"
                                                        : "\u{1F525} None",
                                                  ),
                                                  SizedBox(width: 10.0.w),
                                                  Icon(Icons.check_circle_outline_outlined, size: 16.0.w),
                                                  SizedBox(width: 5.0.w),
                                                  Text("$taskCompleted/${todo.subTask.length}"),
                                                  SizedBox(width: 10.0.w),
                                                  Icon(Icons.access_time_outlined, size: 16.0.w),
                                                  SizedBox(width: 5.0.w),
                                                  Text(DateFormat("HH:mm").format(todo.dueDate.toDate())),
                                                ],
                                              ),
                                              todo.category.isNotEmpty
                                                  ? Container(
                                                      margin: EdgeInsets.fromLTRB(0, 8.w, 5.w, 0),
                                                      padding: EdgeInsets.fromLTRB(5.w, 2.w, 5.w, 2.w),
                                                      decoration: BoxDecoration(
                                                        color: todo.completed
                                                            ? Color(todo.categoryColor).withOpacity(0.4)
                                                            : Color(todo.categoryColor).withOpacity(0.6),
                                                        borderRadius: BorderRadius.circular(5.r),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          todo.category.decrypt,
                                                          style: TextStyle(
                                                            color: todo.completed ? Colors.black87 : Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12.w,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                              SizedBox(height: 10.0.w),
                                              if (todo.description.decrypt.isNotBlank)
                                                Text(
                                                  todo.description.decrypt,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.subtitle2,
                                                ),
                                              // SizedBox(height: 5.0.w),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (todo.subTask.length != 0) SizedBox(height: 5.0.w),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                                        child: _buildSubTaskTimeline(todo),
                                      ),
                                      if (todo.subTask.length != 0) SizedBox(height: 10.0.w),
                                    ],
                                  ),
                                );
                              },
                              indicatorBuilder: (_, index) {
                                TodoModel checkTodo = _todosBox[index];

                                return DotIndicator(
                                  size: 30.0.w,
                                  color: Colors.transparent,
                                  child: CustomCircularCheckBox(
                                    value: checkTodo.completed,
                                    onChanged: (_) {
                                      BlocProvider.of<TodosBloc>(context).add(
                                        UpdateTodo(checkTodo.copyWith(completed: !(checkTodo.completed))),
                                      );
                                    },
                                    activeColor: Colors.blue,
                                    // inactiveColor: Colors.blue,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    // radius: 14.0.r,
                                    width: 20.0.w,
                                  ),
                                );
                              },
                              connectorBuilder: (_, index, ___) => SolidLineConnector(indent: 5.0.w, endIndent: 5.0.w),
                              lastConnectorBuilder: (context) => SolidLineConnector(indent: 5.0.w, endIndent: 10.0.w),
                            ),
                          ),
                        ),
                ],
              );
            } else {
              return Container(
                child: Center(
                  child: Text("Error Loading your Todos."),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Material _buildTodayView(int number, String title) => Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          height: 110.0.h,
          width: 100.0.w,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.0.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: ["$number".text.size(22.0.w).bold.make(), title.text.semiBold.make()],
          ),
        ),
      );

  Widget _buildSubTaskTimeline(TodoModel _todo) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(nodePosition: 0),
      builder: TimelineTileBuilder.connected(
        itemCount: _todo.subTask.length,
        contentsBuilder: (_, int subtaskIndex) {
          String subTitle = _todo.subTask[subtaskIndex].keys.first;

          return Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subTitle.decrypt,
                  style: TextStyle(
                    fontSize: 20.0.w,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    decoration:
                        _todo.subTask[subtaskIndex].values.first ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ],
            ),
          );
        },
        indicatorBuilder: (_, int subCheckIndex) => DotIndicator(
          size: 20.0.w,
          color: Colors.transparent,
          child: CustomCircularCheckBox(
            value: _todo.subTask[subCheckIndex].values.first,
            onChanged: (_) async {
              var subTask = _todo.subTask;
              subTask[subCheckIndex][subTask[subCheckIndex].keys.first] = !subTask[subCheckIndex].values.first;

              BlocProvider.of<TodosBloc>(context).add(
                UpdateTodo(_todo.copyWith(subTask: subTask)),
              );
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: Colors.blue,
            // inactiveColor: Colors.blue,
            // radius: 12.0.r,
            width: 15.0.w,
          ),
        ),
        connectorBuilder: (_, index, ___) => SolidLineConnector(endIndent: 8.0.w),
      ),
    );
  }
}
