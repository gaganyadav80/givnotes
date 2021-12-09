import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:givnotes/widgets/circular_loading.dart';
import 'package:givnotes/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/routes.dart';
import 'package:givnotes/services/services.dart';

import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'bloc/todo_state.dart';
import 'src/todo_model.dart';

class TodoDateController extends GetxController {
  final Rx<DateTime> _appBarDate = DateTime.now().obs;
  final DateTime _today = DateTime.now();

  DateTime get date => _appBarDate.value;
  set date(DateTime value) => _appBarDate.value = value;

  Rx<DateTime> get appBarDate => _appBarDate;

  bool get isToday => (date.day == _today.day && date.month == _today.month);
}

class TodoTimelineBloc extends StatefulWidget {
  const TodoTimelineBloc({Key key}) : super(key: key);

  @override
  _TodoTimelineBlocState createState() => _TodoTimelineBlocState();
}

class _TodoTimelineBlocState extends State<TodoTimelineBloc> {
  final TodoDateController _dateController = Get.find<TodoDateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        toolbarHeight: 56.h,
        titleSpacing: 0.0,
        leading: IconButton(
          splashRadius: 25.0,
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () {
            _dateController.date =
                _dateController.date.subtract(const Duration(days: 1));
          },
        ),
        title: Obx(() => Text(
              DateFormat('dd-MMM-yyyy - EEEE')
                  .format(_dateController.appBarDate.value),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 16.0.w,
                color: _dateController.isToday
                    ? const Color(0xff32343D)
                    : _dateController.date.isAfter(DateTime.now())
                        ? Colors.green
                        : Colors.red,
              ),
            )),
        centerTitle: true,
        actions: [
          IconButton(
            splashRadius: 25.0,
            icon: const Icon(CupertinoIcons.forward, color: Colors.black),
            onPressed: () {
              _dateController.date =
                  _dateController.date.add(const Duration(days: 1));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoading) {
              return Center(
                child: CircularLoading(size: 50.w),
              );
            } else if (state is TodosLoaded) {
              return Obx(
                () {
                  for (var element in state.todos) {
                    if (element.dueDate.toDate().difference(DateTime.now()) >
                        const Duration(days: 5)) {
                      if (element.completed) {
                        BlocProvider.of<TodosBloc>(context)
                            .add(DeleteTodo(element.id));
                      }
                    }
                  }

                  final List<TodoModel> _todosBox = state.todos
                      .where((element) =>
                          element.dueDate.toDate().day ==
                          _dateController.date.day)
                      .toList();
                  final int pending = state.todos
                      .where((element) =>
                          element.dueDate.toDate().day < DateTime.now().day)
                      .length;
                  final int upcoming = state.todos
                      .where((element) =>
                          element.dueDate.toDate().day > DateTime.now().day)
                      .length;

                  _todosBox.sort((a, b) => b.dueDate.compareTo(a.dueDate));

                  return Column(
                    children: [
                      _dateController.date.day == DateTime.now().day &&
                              _dateController.date.month == DateTime.now().month
                          ? Hero(
                              tag: "today-view",
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: 5.0.w, bottom: 10.0.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildTodayView(pending, "Pending"),
                                    _buildTodayView(_todosBox.length, "Today"),
                                    _buildTodayView(upcoming, "Upcoming"),
                                  ],
                                ),
                              ),
                            )
                          : const Hero(
                              tag: "today-view", child: SizedBox.shrink()),
                      SizedBox(height: 10.w),
                      _todosBox.isEmpty
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
                                  indicatorTheme: IndicatorThemeData(
                                      position: 0, size: 28.0.w),
                                ),
                                builder: TimelineTileBuilder.connected(
                                  connectionDirection:
                                      ConnectionDirection.before,
                                  itemCount: _todosBox.length,
                                  contentsBuilder: (_, int index) {
                                    final TodoModel todo = _todosBox[index];

                                    int taskCompleted = 0;
                                    for (var element in todo.subTask) {
                                      if (element.containsValue(true)) {
                                        taskCompleted++;
                                      }
                                    }

                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 5.0.w, bottom: 20.0.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0.r),
                                        color: todo.completed
                                            ? Colors.grey[300]
                                            : Colors.transparent,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                RouterName.createTodoRoute,
                                                arguments: [
                                                  true,
                                                  todo.id,
                                                  todo
                                                ],
                                              );
                                            },
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.0.w,
                                                  top: 5.0.w,
                                                  right: 10.0.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    todo.title.decrypt,
                                                    style: TextStyle(
                                                      fontSize: 22.0.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Roboto",
                                                      decoration: todo.completed
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        todo.priority.decrypt
                                                                .isNotEmpty
                                                            ? "\u{1F525} ${todo.priority.decrypt}"
                                                            : "\u{1F525} None",
                                                      ),
                                                      SizedBox(width: 10.0.w),
                                                      Icon(
                                                          Icons
                                                              .check_circle_outline_outlined,
                                                          size: 16.0.w),
                                                      SizedBox(width: 5.0.w),
                                                      Text(
                                                          "$taskCompleted/${todo.subTask.length}"),
                                                      SizedBox(width: 10.0.w),
                                                      Icon(
                                                          Icons
                                                              .access_time_outlined,
                                                          size: 16.0.w),
                                                      SizedBox(width: 5.0.w),
                                                      Text(DateFormat("HH:mm")
                                                          .format(todo.dueDate
                                                              .toDate())),
                                                    ],
                                                  ),
                                                  todo.category.isNotEmpty
                                                      ? Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(0, 8.w,
                                                                  5.w, 0),
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  5.w,
                                                                  2.w,
                                                                  5.w,
                                                                  2.w),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: todo
                                                                    .completed
                                                                ? Color(todo
                                                                        .categoryColor)
                                                                    .withOpacity(
                                                                        0.4)
                                                                : Color(todo
                                                                        .categoryColor)
                                                                    .withOpacity(
                                                                        0.6),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              todo.category
                                                                  .decrypt,
                                                              style: TextStyle(
                                                                color: todo
                                                                        .completed
                                                                    ? Colors
                                                                        .black87
                                                                    : Colors
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12.w,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  SizedBox(height: 10.0.w),
                                                  if (todo.description.decrypt
                                                      .isNotBlank)
                                                    Text(
                                                      todo.description.decrypt,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (todo.subTask.isNotEmpty)
                                            SizedBox(height: 5.0.w),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0.w, right: 10.0.w),
                                            child: _buildSubTaskTimeline(todo),
                                          ),
                                          SizedBox(height: 10.0.w),
                                          // TilesDivider().pSymmetric(h: 10.w),
                                        ],
                                      ),
                                    );
                                  },
                                  indicatorBuilder: (_, index) {
                                    TodoModel checkTodo = _todosBox[index];

                                    return DotIndicator(
                                      size: 35.0.w,
                                      color: Colors.transparent,
                                      child: CustomCheckbox(
                                        value: checkTodo.completed,
                                        onChanged: (_) {
                                          BlocProvider.of<TodosBloc>(context)
                                              .add(
                                            UpdateTodo(checkTodo.copyWith(
                                                completed:
                                                    !(checkTodo.completed))),
                                          );
                                        },
                                        activeColor: Colors.blue,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24.r)),
                                        width: 32.w,
                                        strokeWidth: 3.0,
                                      ),
                                    );
                                  },
                                  connectorBuilder: (_, index, ___) =>
                                      SolidLineConnector(
                                          indent: 5.0.w, endIndent: 5.0.w),
                                  lastConnectorBuilder: (context) =>
                                      SolidLineConnector(
                                          indent: 5.0.w, endIndent: 10.0.w),
                                ),
                              ),
                            ),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Error Loading your Todos."),
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
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15.0.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "$number".text.size(22.0.w).bold.make(),
              title.text.semiBold.make()
            ],
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
                    decoration: _todo.subTask[subtaskIndex].values.first
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          );
        },
        indicatorBuilder: (_, int subCheckIndex) => DotIndicator(
          size: 20.0.w,
          color: Colors.transparent,
          child: CustomCheckbox(
            value: _todo.subTask[subCheckIndex].values.first,
            onChanged: (_) async {
              var subTask = _todo.subTask;
              subTask[subCheckIndex][subTask[subCheckIndex].keys.first] =
                  !subTask[subCheckIndex].values.first;

              BlocProvider.of<TodosBloc>(context).add(
                UpdateTodo(_todo.copyWith(subTask: subTask)),
              );
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r)),
            width: 26.w,
          ),
        ),
        connectorBuilder: (_, index, ___) =>
            SolidLineConnector(endIndent: 8.0.w),
      ),
    );
  }
}
