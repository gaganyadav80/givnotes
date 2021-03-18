import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/global/material_colors.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/global/variables.dart';

class TodoAlert extends StatelessWidget {
  const TodoAlert({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      content: Text("Unsaved changes. Sure exit?"),
      actions: [
        TextButton(
          child: Text("No"),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text("Yes"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}

class CreateTodoAppBar extends StatelessWidget with PreferredSizeWidget {
  const CreateTodoAppBar({Key key, this.controller, this.prevTitle, this.editTodo}) : super(key: key);

  final TextEditingController controller;
  final String prevTitle;
  final bool editTodo;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              builder: (context) => TodoAlert(),
            ).then((value) => val = value);

            if (val == true) Navigator.pop(context);
          }
        },
        child: Icon(CupertinoIcons.arrow_left, color: Colors.black),
      ),
    );
  }
}

class SelectCategory extends StatefulWidget {
  SelectCategory({Key key, this.controller, this.selectCategoryColors}) : super(key: key);

  final TextEditingController controller;
  final List<int> selectCategoryColors;

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter category and color',
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
                  controller: widget.controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              IconButton(
                icon: Icon(CupertinoIcons.add),
                color: Colors.blue,
                iconSize: 28.0,
                onPressed: () {
                  if (widget.controller.text.isEmpty)
                    showFlashToast(context, "Please enter category name");
                  else if (widget.selectCategoryColors.length == 1)
                    Navigator.pop(context, true);
                  else
                    showFlashToast(context, "Please select a color");
                },
              ),
            ],
          ),
          SizedBox(height: 0.032894737 * screenSize.height),
          Container(
            height: 0.092105263 * screenSize.height,
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectCategoryColors.length,
              itemBuilder: (context, index) {
                Color color = Color(widget.selectCategoryColors[index]);

                return Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.selectCategoryColors.length == 1) {
                        setState(() {
                          widget.selectCategoryColors
                            ..clear()
                            ..addAll(materialColorValues);
                        });
                      } else {
                        setState(() {
                          widget.selectCategoryColors
                            ..clear()
                            ..add(color.value);
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 45 / 2,
                      backgroundColor: color,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
