import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:givnotes/packages/circular_checkbox.dart';
import 'package:intl/intl.dart';

import 'package:givnotes/global/material_colors.dart';

import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'bloc/todo_state.dart';
import 'src/todo_model.dart';
import 'todo_widgets.dart';

class CreateTodoBloc extends StatefulWidget {
  const CreateTodoBloc({
    Key key,
    this.id,
    this.isEditing = false,
    this.todo,
  })  : assert(isEditing ? id != null : true),
        assert(isEditing ? todo != null : true),
        super(key: key);

  final String id;
  final bool isEditing;
  final Todo todo;

  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodoBloc> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _subtaskController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // final HiveDBServices _dbServices = HiveDBServices();
  String _priority;
  List<dynamic> _subTasks = [];
  List<int> _selectCategoryColors = <int>[];
  bool _categoryAdded = false;
  DateTime _dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _categoryAdded = true;

      _titleController.text = widget.todo.title;
      _detailsController.text = widget.todo.description;
      _categoryController.text = widget.todo.category.keys.first;
      _selectCategoryColors
        ..clear()
        ..add(widget.todo.category.values.first);
      _priority = widget.todo.priority;
      _subTasks
        ..clear()
        ..addAll(widget.todo.subTask);
      _dueDate = widget.todo.dueDate.toDate();
    } else {
      _selectCategoryColors.addAll(materialColorValues);
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
    print(_dueDate);

    return WillPopScope(
      onWillPop: () async {
        bool val = true;
        FocusScope.of(context).unfocus();

        if (widget.isEditing && _titleController.text != widget.todo.title) {
          await showDialog(
            context: context,
            builder: (context) => TodoAlert(),
          ).then((value) => val = value);
        } else if (!widget.isEditing && _titleController.text.isNotEmpty) {
          await showDialog(
            context: context,
            builder: (context) => TodoAlert(),
          ).then((value) => val = value);
        }
        return val;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: CreateTodoAppBar(controller: _titleController, prevTitle: widget.isEditing ? widget.todo.title : "", editTodo: widget.isEditing),
        floatingActionButton: _buildFab(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.text_insert, color: Colors.black),
                  SizedBox(width: 10.0),
                  Expanded(child: _titleTextField()),
                ],
              ),
              _detailsTextField(),
              // SizedBox(height: 20.0),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.tag_solid,
                      size: 24.0,
                      color: _selectCategoryColors.length == 1 && _categoryAdded ? Color(_selectCategoryColors.first) : null,
                    ),
                  ],
                ),
                enabled: !_categoryAdded,
                trailing: _categoryAdded
                    ? GestureDetector(
                        onTap: () {
                          _categoryController.clear();
                          _selectCategoryColors
                            ..clear()
                            ..addAll(materialColorValues);
                          setState(() {
                            _categoryAdded = false;
                          });
                        },
                        child: Icon(CupertinoIcons.xmark_circle))
                    : SizedBox.shrink(),
                title: Text(
                  _categoryController.text.isNotEmpty && _categoryAdded ? _categoryController.text : "Category",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _selectCategoryColors.length == 1 && _categoryAdded ? Color(_selectCategoryColors.first) : Colors.black,
                  ),
                ),
                horizontalTitleGap: 0.0,
                onTap: () => showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                  builder: (BuildContext context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: SelectCategory(
                      controller: _categoryController,
                      selectCategoryColors: _selectCategoryColors,
                    ),
                  ),
                ).then((value) {
                  if (value == null) value = false;
                  if (value && value != null)
                    _categoryAdded = value;
                  else {
                    _categoryAdded = false;
                    _selectCategoryColors
                      ..clear()
                      ..addAll(materialColorValues);
                    _categoryController.clear();
                  }
                }),
              ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(CupertinoIcons.calendar, size: 26.0)],
                ),
                title: Row(
                  children: [
                    GFButton(
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: _dueDate,
                          lastDate: DateTime(DateTime.now().year + 1),
                          firstDate: DateTime(DateTime.now().year - 1),
                        ).then((value) {
                          if (value != null)
                            setState(() {
                              _dueDate = DateTime(value.year, value.month, value.day, _dueDate.hour, _dueDate.minute);
                            });
                        });
                      },
                      color: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      shape: GFButtonShape.pills,
                      size: GFSize.SMALL,
                      type: GFButtonType.outline2x,
                      child: Text(DateFormat("EEE, dd MMM").format(_dueDate), style: TextStyle(fontSize: 16.0)),
                    ),
                    SizedBox(width: 10.0),
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
                            setState(() {
                              _dueDate = DateTime(_dueDate.year, _dueDate.month, _dueDate.day, value.hour, value.minute);
                            });
                        });
                      },
                      color: Colors.black,
                      shape: GFButtonShape.pills,
                      size: GFSize.SMALL,
                      type: GFButtonType.outline2x,
                      child: Text(DateFormat("HH:mm").format(_dueDate), style: TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
                horizontalTitleGap: 0.0,
              ),
              ListTile(
                horizontalTitleGap: 0.0,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(CupertinoIcons.bell_solid, size: 26.0)],
                ),
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
                      child: Text(TimeOfDay.now().format(context), style: TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
              ),
              ListTile(
                horizontalTitleGap: 0.0,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(CupertinoIcons.exclamationmark_circle_fill, size: 26.0)],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                title: Text(_priority == null ? "Set priority" : "Priority - $_priority", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Color(0xff171C26),
                  isDismissible: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                  builder: (context) => setPriorityModal(context),
                ),
              ),
              ListTile(
                horizontalTitleGap: 0.0,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(CupertinoIcons.list_bullet, size: 26.0)],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                title: Text("Add subtask", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                    builder: (BuildContext context) => _buildSubTaskModal(),
                  );
                },
              ),
              Container(
                height: 300.0,
                child: ListView.builder(
                  itemCount: _subTasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: BlocBuilder<TodosBloc, TodosState>(
                        builder: (context, state) {
                          return CircularCheckBox(
                            onChanged: (_) async {
                              //TODO flag
                              // setState(() {
                              //   widget.subTask.setComplete(!widget.subTask.completed);
                              // });

                              var subTask = widget.todo.subTask;
                              subTask[index][subTask[index].keys.first] = !subTask[index].values.first;

                              BlocProvider.of<TodosBloc>(context).add(
                                UpdateTodo(widget.todo.copyWith(subTask: subTask)),
                              );
                            },
                            value: _subTasks[index].values.first,
                            inactiveColor: Colors.blue,
                            activeColor: Colors.blue,
                            radius: 14.0,
                            width: 20.0,
                          );
                        },
                      ),
                      title: Text(_subTasks[index].keys.first),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container setPriorityModal(BuildContext context) => Container(
        height: 400.0,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  height: 5.0,
                  width: 50.0,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Select a priority",
                style: TextStyle(
                  color: Colors.grey[350],
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: Text("\u{1F525}", style: TextStyle(fontSize: 24.0)),
              title: Text("Urgent", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
              horizontalTitleGap: 10.0,
              onTap: () {
                setState(() => _priority = "Urgent");
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            ListTile(
              leading: Text("\u{1F9E8}", style: TextStyle(fontSize: 24.0)),
              title: Text("High", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
              horizontalTitleGap: 10.0,
              onTap: () {
                setState(() => _priority = "High");
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            ListTile(
              leading: Text("\u{1F383}", style: TextStyle(fontSize: 24.0)),
              title: Text("Medium", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
              horizontalTitleGap: 10.0,
              onTap: () {
                setState(() => _priority = "Medium");
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            ListTile(
              leading: Text("\u{2744}", style: TextStyle(fontSize: 24.0)),
              title: Text("Low", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
              horizontalTitleGap: 10.0,
              onTap: () {
                setState(() => _priority = "Low");
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            ListTile(
              leading: Text("\u{26C4}", style: TextStyle(fontSize: 24.0)),
              title: Text("No priority", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
              horizontalTitleGap: 10.0,
              onTap: () {
                setState(() => _priority = "None");
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ],
        ),
      );

  TextField _titleTextField() {
    return TextField(
      autocorrect: false,
      controller: _titleController,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Task title",
        hintStyle: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

  ConstrainedBox _detailsTextField() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100.0),
      child: TextField(
        autocorrect: false,
        controller: _detailsController,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Would you like to add more details?",
          hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      ),
    );
  }

  Padding _buildFab() => Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(CupertinoIcons.floppy_disk, color: Colors.white),
          onPressed: () {
            if (_titleController.text.isNotEmpty && !widget.isEditing) {
              //TODO flag
              // _dbServices.insertTodo(
              //   TodoModel()
              //     ..title = _titleController.text
              //     ..description = _detailsController.text
              //     ..completed = false
              //     ..dueDate = _dueDate
              //     ..subTask = _subTasks
              //     ..category = {_categoryController.text: _selectCategoryColors.first}
              //     ..uuid = Uuid().v1()
              //     ..priority = _priority,
              // );

              BlocProvider.of<TodosBloc>(context).add(
                AddTodo(Todo(
                  title: _titleController.text,
                  completed: false,
                  description: _detailsController.text,
                  dueDate: Timestamp.fromDate(_dueDate),
                  priority: _priority,
                  category: _categoryController.text.isNotEmpty ? {_categoryController.text: _selectCategoryColors.first} : {"": null},
                  subTask: _subTasks,
                )),
              );

              Navigator.pop(context);
            } else if (widget.isEditing) {
              //TODO flag
              // _dbServices.updateTodo(
              //   widget.index,
              //   TodoModel()
              //     ..title = _titleController.text
              //     ..description = _detailsController.text
              //     ..completed = widget.completed
              //     ..dueDate = _dueDate
              //     ..subTask = _subTasks
              //     ..category = {_categoryController.text: _selectCategoryColors.first}
              //     ..uuid = widget.uuid
              //     ..priority = _priority,
              // );

              BlocProvider.of<TodosBloc>(context).add(
                UpdateTodo(widget.todo.copyWith(
                  title: _titleController.text,
                  description: _detailsController.text,
                  dueDate: Timestamp.fromDate(_dueDate),
                  priority: _priority,
                  category: {_categoryController.text: _selectCategoryColors.first},
                  subTask: _subTasks,
                )),
              );

              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a task title.")));
            }
          },
        ),
      );

  Padding _buildSubTaskModal() => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create new subtask',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subtaskController,
                      autofocus: true,
                      onSubmitted: (_) {
                        setState(() {
                          // _subTasks.add(SubTaskModel(_subtaskController.text));
                          _subTasks.add({_subtaskController.text: false});
                        });
                        // Navigator.pop(context);
                        _subtaskController.clear();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(CupertinoIcons.add),
                    color: Colors.blue,
                    iconSize: 28.0,
                    onPressed: () {
                      setState(() {
                        _subTasks.add({_subtaskController.text: false});
                      });
                      // Navigator.pop(context);
                      _subtaskController.clear();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
