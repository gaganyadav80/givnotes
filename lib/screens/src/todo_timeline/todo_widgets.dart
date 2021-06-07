import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/widgets.dart';

import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';


class CreateTodoAppBar extends StatelessWidget with PreferredSizeWidget {
  const CreateTodoAppBar({
    Key key,
    this.controller,
    this.prevTitle,
    this.editTodo,
    this.id,
  }) : super(key: key);

  final TextEditingController controller;
  final String prevTitle;
  final bool editTodo;
  final String id;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () async {
          bool val;
          FocusScope.of(context).unfocus();

          if (editTodo && controller.text == prevTitle) {
            Navigator.pop(context);
          } else if (controller.text.isEmpty && !editTodo) {
            Navigator.pop(context);
          } else {
            await showDialog(
              context: context,
              builder: (context) => GivnotesDialog(
                title: "Unsaved Changes",
                message: "Confirm exit?",
                mainButtonText: "Exit",
                showCancel: true,
              ),
            ).then((value) => val = value);

            if (val == true) Navigator.pop(context);
          }
        },
        child: Icon(CupertinoIcons.arrow_left, color: Colors.black),
      ),
      actions: [
        editTodo
            ? IconButton(
                icon: Icon(CupertinoIcons.delete),
                color: Colors.black,
                splashRadius: 25.0,
                onPressed: () {
                  BlocProvider.of<TodosBloc>(context).add(DeleteTodo(id));
                  Navigator.pop(context);
                },
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class SelectCategory extends StatefulWidget {
  SelectCategory({Key key, this.controller, this.selectCategoryColors}) : super(key: key);

  final TextEditingController controller;
  final RxInt selectCategoryColors;

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final CupertinoDynamicColor _kClearButtonColor = CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  );

  final FocusNode _focusNode = FocusNode();
  final MaterialColors _colors = MaterialColors();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          if (widget.controller.text.isEmpty)
            Navigator.pop<bool>(context, false);
          else
            Navigator.pop<bool>(context, true);

          return false;
        },
        child: CupertinoPageScaffold(
          backgroundColor: Color(0xffF7F6F2),
          navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            middle: Text("Category"),
            trailing: TextButton(
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (widget.controller.text.isEmpty)
                  Navigator.pop<bool>(context, false);
                else
                  Navigator.pop<bool>(context, true);
              },
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30.w),
                  Container(
                    height: 45.w,
                    color: Colors.white,
                    child: Center(
                      child: CupertinoTextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        cursorColor: Colors.black,
                        placeholder: "Add category",
                        padding: const EdgeInsets.fromLTRB(15.0, 6.0, 6.0, 6.0),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                        suffixMode: OverlayVisibilityMode.editing,
                        suffix: GestureDetector(
                          onTap: () => widget.controller.clear(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              CupertinoIcons.clear_thick_circled,
                              size: 18.0,
                              color: CupertinoDynamicColor.resolve(_kClearButtonColor, context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.w),
                  GestureDetector(
                    onTap: () {
                      widget.controller.clear();
                      widget.selectCategoryColors.value = _colors.materialColorValues[0];
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 15.0),
                      height: 45.w,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            widget.controller.text.isEmpty ? CupertinoIcons.clear : CupertinoIcons.delete,
                            color: Colors.black,
                            size: 21.0,
                          ),
                          SizedBox(width: 10.w),
                          "${widget.controller.text.isEmpty ? "Cancel" : "Delete"}".text.size(16.w).make(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 20.w,
                      child: "COLORS".text.coolGray400.size(10.w).make(),
                    ).pSymmetric(h: 15.0),
                  ),
                  Container(
                    color: Colors.white,
                    child: Obx(() => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            10,
                            (index) => GestureDetector(
                              onTap: () {
                                widget.selectCategoryColors.value = _colors.materialColorValues[index];
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 15.0),
                                height: 45.w,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 25.w,
                                          width: 25.w,
                                          decoration: BoxDecoration(
                                            color: Color(_colors.materialColorValues[index]).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(3.r),
                                            border:
                                                Border.all(color: Color(_colors.materialColorValues[index]).withOpacity(0.2)),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        _colors.materialColorNames[index].text.size(16.w).make(),
                                      ],
                                    ),
                                    if (widget.selectCategoryColors.value == _colors.materialColorValues[index])
                                      Icon(CupertinoIcons.checkmark_alt, color: Colors.black).pOnly(right: 15.w),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
