import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/global/material_colors.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/widgets.dart';

import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'bloc/todo_state.dart';
import 'src/todo_model.dart';
import 'todo_widgets.dart';

class CreateTodoBloc extends StatefulWidget {
  const CreateTodoBloc({
    Key key,
    this.isEditing = false,
    this.id,
    this.todo,
  })  : assert(isEditing ? id != null : true),
        assert(isEditing ? todo != null : true),
        super(key: key);

  final bool isEditing;
  final String id;
  final TodoModel todo;

  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodoBloc> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _subtaskController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final RxString _priority = "".obs;
  final RxList<dynamic> _subTasks = [].obs;
  final RxInt _selectCategoryColors = 0.obs;
  final RxBool _categoryAdded = false.obs;
  final Rx<DateTime> _dueDate = DateTime.now().obs;

  @override
  void initState() {
    super.initState();
    _selectCategoryColors.value = materialColorValues[0];

    if (widget.isEditing) {
      _categoryAdded.value = widget.todo.category.isNotEmpty;

      _titleController.text = widget.todo.title.decrypt;
      _detailsController.text = widget.todo.description.decrypt;

      if (_categoryAdded.value) _categoryController.text = widget.todo.category.decrypt;
      if (_categoryAdded.value) _selectCategoryColors.value = widget.todo.categoryColor;

      _priority.value = widget.todo.priority.decrypt;
      _subTasks
        ..clear()
        ..addAll(widget.todo.subTask);

      _dueDate.value = widget.todo.dueDate.toDate();
    }
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _detailsController?.dispose();
    _subtaskController?.dispose();
    _categoryController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool val = true;
        FocusScope.of(context).unfocus();

        if (widget.isEditing && _titleController.text != widget.todo.title.decrypt) {
          await showDialog(
            context: context,
            builder: (context) => GivnotesDialog(
              title: "Unsaved Changes",
              message: "Confirm exit?",
              mainButtonText: "Exit",
              showCancel: true,
            ),
          ).then((value) => val = value);
        } else if (!widget.isEditing && _titleController.text.isNotEmpty) {
          await showDialog(
            context: context,
            builder: (context) => GivnotesDialog(
              title: "Unsaved Changes",
              message: "Confirm exit?",
              mainButtonText: "Exit",
              showCancel: true,
            ),
          ).then((value) => val = value);
        } else if (_titleController.text.isEmpty) {
          Fluttertoast.showToast(msg: "Please add a title");
        }

        return val;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: CreateTodoAppBar(
          controller: _titleController,
          prevTitle: widget.isEditing ? widget.todo.title.decrypt : "",
          editTodo: widget.isEditing,
          id: widget.todo?.id ?? null,
        ),
        floatingActionButton: _buildFab(),
        body: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: ListView(
            children: [
              Container(child: "REQUIRED".text.coolGray400.size(10.w).make()),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.text_insert, color: Colors.black),
                  SizedBox(width: 10.w),
                  Expanded(child: _titleTextField()),
                ],
              ),
              SizedBox(height: 5.w),
              _detailsTextField(),
              SizedBox(height: 10.w),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: _categoryAdded.value ? Color(_selectCategoryColors.value).withOpacity(0.15) : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: _categoryAdded.value
                        ? Border.all(color: Color(_selectCategoryColors.value).withOpacity(0.2))
                        : null,
                  ),
                  child: ListTile(
                    tileColor: Colors.transparent,
                    leading: Icon(
                      CupertinoIcons.tag_solid,
                      size: 24.w,
                      color: _categoryAdded.value ? Colors.black.withOpacity(0.7) : null,
                    ),
                    trailing: _categoryAdded.value
                        ? GestureDetector(
                            onTap: () {
                              _categoryController.clear();
                              _selectCategoryColors.value = materialColorValues[0];
                              _categoryAdded.value = false;
                            },
                            child: Icon(
                              CupertinoIcons.clear_thick_circled,
                              color: _categoryAdded.value ? Colors.black.withOpacity(0.7) : null,
                            ))
                        : SizedBox.shrink(),
                    title: Text(
                      _categoryAdded.value ? _categoryController.text : "Category",
                      style: TextStyle(
                        fontSize: 18.w,
                        fontWeight: FontWeight.w500,
                        color: _categoryAdded.value ? Colors.black : Colors.black,
                      ),
                    ),
                    horizontalTitleGap: 0.0,
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => SelectCategory(
                          controller: _categoryController,
                          selectCategoryColors: _selectCategoryColors,
                        ),
                      ),
                    ).then((value) {
                      if (value == null) value = false;
                      if (value && value != null) _categoryAdded.value = value;
                    }),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.calendar, size: 26.0.w),
                title: Row(
                  children: [
                    GFButton(
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: _dueDate.value,
                          lastDate: DateTime(DateTime.now().year + 1),
                          firstDate: DateTime(DateTime.now().year - 1),
                        ).then((value) {
                          if (value != null)
                            _dueDate.value = DateTime(
                                value.year, value.month, value.day, _dueDate.value.hour, _dueDate.value.minute);
                        });
                      },
                      color: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      shape: GFButtonShape.pills,
                      size: GFSize.SMALL,
                      type: GFButtonType.outline2x,
                      child: Obx(() => Text(
                            DateFormat("EEE, dd MMM").format(_dueDate.value),
                            style: TextStyle(fontSize: 16.0),
                          )),
                    ),
                    SizedBox(width: 10.0.w),
                    GFButton(
                      onPressed: () async {
                        await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                              child: child,
                            );
                          },
                        ).then((value) {
                          if (value != null)
                            _dueDate.value = DateTime(_dueDate.value.year, _dueDate.value.month, _dueDate.value.day,
                                value.hour, value.minute);
                        });
                      },
                      color: Colors.black,
                      shape: GFButtonShape.pills,
                      size: GFSize.SMALL,
                      type: GFButtonType.outline2x,
                      child: Obx(() => Text(
                            DateFormat("HH:mm").format(_dueDate.value),
                            style: TextStyle(fontSize: 16.0.w),
                          )),
                    ),
                  ],
                ),
                horizontalTitleGap: 0.0,
              ),
              ListTile(
                horizontalTitleGap: 0.0,
                leading: Icon(CupertinoIcons.bell_solid, size: 26.0.w),
                title: Row(
                  children: [
                    GFButton(
                      onPressed: () => showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ),
                      shape: GFButtonShape.pills,
                      color: Colors.black,
                      size: GFSize.SMALL,
                      type: GFButtonType.outline2x,
                      child: Text(TimeOfDay.now().format(context), style: TextStyle(fontSize: 16.0.w)),
                    ),
                  ],
                ),
              ),
              ListTile(
                horizontalTitleGap: 0.0,
                leading: Icon(CupertinoIcons.exclamationmark_circle_fill, size: 26.0.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                title: Obx(() => Text(
                      _priority.value.isEmpty ? "Set priority" : "Priority - ${_priority.value}",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                onTap: () {
                  FocusScope.of(context).unfocus();

                  Future.delayed(
                    Duration(milliseconds: 150),
                    () => showModalBottomSheet(
                      context: context,
                      backgroundColor: Color(0xff171C26),
                      isDismissible: true,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.r))),
                      builder: (context) => _buildPriorityModal(context),
                    ),
                  );
                },
              ),
              ListTile(
                horizontalTitleGap: 0.0,
                leading: Icon(CupertinoIcons.list_bullet, size: 26.0.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
                title: Text("Add subtask", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.r))),
                    builder: (BuildContext context) => _buildSubTaskModal(),
                  );
                },
              ),
              Container(
                height: 300.0.h,
                child: Obx(() => ListView.builder(
                      itemCount: _subTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: BlocBuilder<TodosBloc, TodosState>(
                            builder: (context, state) {
                              return CustomCircularCheckBox(
                                onChanged: (_) async {
                                  var subTask = widget.todo.subTask;
                                  subTask[index][subTask[index].keys.first] = !subTask[index].values.first;

                                  BlocProvider.of<TodosBloc>(context).add(
                                    UpdateTodo(widget.todo.copyWith(subTask: subTask)),
                                  );
                                },
                                value: _subTasks[index].values.first,
                                // inactiveColor: Colors.blue,
                                activeColor: Colors.blue,
                                // radius: 14.0.r,
                                width: 20.0.w,
                              );
                            },
                          ),
                          title: Text(_subTasks[index].keys.first.decrypt),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const List<String> _priorityName = <String>["Urgent", "High", "Medium", "Low", "No priority"];
  static const List<String> _priorityImoji = <String>["\u{1F525}", "\u{1F9E8}", "\u{1F383}", "\u{2744}", "\u{26C4}"];

  SingleChildScrollView _buildPriorityModal(BuildContext context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Build the small bar on top
              Container(
                margin: EdgeInsets.only(top: 10.h, bottom: 30.h),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(15.0.r),
                ),
                height: 5.0.h,
                width: 50.0.w,
              ).centered(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: Text(
                  "Select a priority",
                  style: TextStyle(
                    color: Colors.grey[350],
                    fontSize: 22.0.w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => ListTile(
                    leading: Text(_priorityImoji[index], style: TextStyle(fontSize: 24.0.w)),
                    title:
                        Text(_priorityName[index], style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                    horizontalTitleGap: 10.0.w,
                    onTap: () {
                      if (index == 4)
                        _priority.value = "";
                      else
                        _priority.value = _priorityName[index];
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  CupertinoTextField _titleTextField() {
    return CupertinoTextField.borderless(
      autocorrect: false,
      controller: _titleController,
      cursorColor: Colors.black,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(
        fontSize: 26.0.w,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      placeholder: "Task title",
      placeholderStyle: TextStyle(
        fontSize: 26.0.w,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
    );
  }

  Widget _detailsTextField() {
    return CupertinoTextField.borderless(
      autocorrect: false,
      cursorColor: Colors.black,
      controller: _detailsController,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(fontSize: 16.0.w, color: Colors.black, fontFamily: 'Poppins'),
      maxLines: 3,
      minLines: 1,
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      placeholder: "Would you like to add more details?",
      placeholderStyle: TextStyle(fontSize: 16.0.w, color: Colors.grey, fontFamily: 'Poppins'),
    );
  }

  Padding _buildFab() => Padding(
        padding: EdgeInsets.only(bottom: 20.0.h),
        child: Container(
          height: 65.w,
          width: 65.w,
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            child: Icon(CupertinoIcons.floppy_disk, color: Colors.white),
            onPressed: () {
              if (_titleController.text.isNotEmpty && !widget.isEditing) {
                BlocProvider.of<TodosBloc>(context).add(
                  AddTodo(TodoModel(
                    title: _titleController.text.encrypt,
                    description: _detailsController.text.encrypt,
                    priority: _priority.value.encrypt,
                    category: _categoryController.text.encrypt,
                    subTask: _subTasks,
                    //
                    completed: false,
                    dueDate: Timestamp.fromDate(_dueDate.value),
                    categoryColor: _selectCategoryColors.value,
                  )),
                );

                Navigator.pop(context);
              } else if (widget.isEditing) {
                BlocProvider.of<TodosBloc>(context).add(
                  UpdateTodo(widget.todo.copyWith(
                    title: _titleController.text.encrypt,
                    description: _detailsController.text.encrypt,
                    priority: _priority.value.encrypt,
                    category: _categoryController.text.encrypt,
                    subTask: _subTasks,
                    //
                    dueDate: Timestamp.fromDate(_dueDate.value),
                    categoryColor: _selectCategoryColors.value,
                  )),
                );

                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(msg: "Please enter a task title.");
              }
            },
          ),
        ),
      );

  Widget _buildSubTaskModal() => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create new subtask',
              style: TextStyle(
                fontSize: 18.w,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10.w),
            Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    controller: _subtaskController,
                    autofocus: true,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 20.w),
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
                    onSubmitted: (_) {
                      if (_subtaskController.text.isNotEmpty) {
                        _subTasks.add({_subtaskController.text.encrypt: false});
                        _subtaskController.clear();
                      } else {
                        Fluttertoast.showToast(msg: "Please enter subtask");
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.add),
                  color: Colors.blue,
                  iconSize: 28.0.w,
                  onPressed: () {
                    if (_subtaskController.text.isNotEmpty) {
                      _subTasks.add({_subtaskController.text.encrypt: false});
                      _subtaskController.clear();
                    } else {
                      Fluttertoast.showToast(msg: "Please enter subtask");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      );
}
