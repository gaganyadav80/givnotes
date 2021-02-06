// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttericon/entypo_icons.dart';
// import 'package:givnotes/bloc/authentication_bloc/authentication_bloc.dart';
// import 'package:givnotes/database/database.dart';
// import 'package:givnotes/services/services.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:uuid/uuid.dart';

// import 'Details.dart';
// // import 'DummyData.dart';
// import 'objects/ColorChoice.dart';

// class TodoHome extends StatefulWidget {
//   TodoHome({Key key}) : super(key: key);

//   @override
//   _TodoHomeState createState() => _TodoHomeState();
// }

// class _TodoHomeState extends State<TodoHome> with TickerProviderStateMixin {
//   ScrollController scrollController;
//   Color backgroundColor;
//   LinearGradient backgroundGradient;
//   Tween<Color> colorTween;
//   int currentPage = 0;
//   Color constBackColor;
//   final HiveDBServices _hiveDBServices = HiveDBServices();

//   @override
//   void initState() {
//     super.initState();
//     // colorTween = ColorTween(begin: todos[0].color, end: todos[0].color);
//     // backgroundColor = todos[0].color;
//     // backgroundGradient = todos[0].gradient;
//     scrollController = ScrollController();
// //     scrollController.addListener(() {
// //       ScrollPosition position = scrollController.position;
// //       ScrollDirection direction = position.userScrollDirection;
// //       int page = position.pixels ~/ (position.maxScrollExtent / (todos.length.toDouble() - 1));
// //       double pageDo = (position.pixels / (position.maxScrollExtent / (todos.length.toDouble() - 1)));
// //       double percent = pageDo - page;
// //       if (todos.length - 1 < page + 1) {
// //         return;
// //       }
// //       colorTween.begin = todos[page].color;
// //       colorTween.end = todos[page + 1].color;
// //       setState(() {
// //         backgroundColor = colorTween.transform(percent);
// //         backgroundGradient = todos[page].gradient.lerpTo(todos[page + 1].gradient, percent);
// //       });
// //     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     scrollController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double _width = MediaQuery.of(context).size.width;
//     final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         child: Icon(CupertinoIcons.add, color: Colors.white),
//         onPressed: () async {
//           await _hiveDBServices.insertTodo(
//             TodoModel()
//               ..category = 'Custom'
//               ..uuid = Uuid().v1()
//               ..color = ColorChoices.choices[0].value
//               ..icon = Icons.alarm.codePoint
//               ..tasks = [
//                 TaskObject("Meet Clients", DateTime(2021, 1, 12)),
//                 TaskObject("Design Sprint", DateTime(2021, 1, 12)),
//                 TaskObject("Icon Set Design for Mobile", DateTime(2021, 1, 12)),
//                 TaskObject("HTML/CSS Study", DateTime(2021, 1, 12)),
//                 TaskObject("Meet Clients", DateTime(2019, 5, 4)),
//                 TaskObject("Design Sprint", DateTime(2019, 5, 4)),
//                 TaskObject("Icon Set Design for Mobile", DateTime(2019, 5, 4)),
//                 TaskObject("HTML/CSS Study", DateTime(2019, 5, 4)),
//               ],
//           );
//         },
//       ),
//       backgroundColor: Colors.white,
//       body: ValueListenableBuilder(
//         valueListenable: Hive.box<TodoModel>('givtodos').listenable(),
//         builder: (BuildContext context, Box<TodoModel> todoBox, Widget child) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(left: 30.0, top: 10.0),
//                 child: RichText(
//                   text: TextSpan(
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 20.0,
//                     ),
//                     children: <TextSpan>[
//                       TextSpan(text: "Hello, "),
//                       TextSpan(
//                         text: "${user?.name ?? ''}.",
//                         style: TextStyle(
//                           fontSize: 25.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Spacer(),
//               Padding(
//                 padding: EdgeInsets.only(left: 40.0),
//                 child: Text(
//                   "You have ${todoBox.values.toList().length.toInt()} tasks to do today.",
//                   style: TextStyle(color: Colors.black.withOpacity(0.8)),
//                 ),
//               ),
//               Spacer(),
//               Padding(
//                 padding: EdgeInsets.only(
//                   left: 50.0,
//                 ),
//                 child: RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "TODAY : ",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       TextSpan(
//                         text: DateFormat.yMMMMd().format(DateTime.now()),
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Spacer(),
//               Expanded(
//                 flex: 20,
//                 child: ListView.builder(
//                   itemBuilder: (context, index) {
//                     // TodoObject todoObject = todos[index];
//                     TodoModel todoObject = todoBox.values.toList().elementAt(index);
//                     double percentComplete = todoObject.percentComplete();

//                     return Padding(
//                       padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.of(context).push(
//                             PageRouteBuilder(
//                               pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => DetailPage(todoObject: todoObject),
//                               transitionDuration: Duration(milliseconds: 1000),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0),
//                             boxShadow: [BoxShadow(color: Color(todoObject.color).withAlpha(70), offset: Offset(3.0, 10.0), blurRadius: 15.0)],
//                             border: Border.all(color: Color(todoObject.color).withOpacity(0.4)),
//                           ),
//                           height: 250.0,
//                           child: Stack(
//                             children: <Widget>[
//                               Hero(
//                                 tag: todoObject.uuid + "_background",
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10.0),
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                       colors: [
//                                         Color(todoObject.color).withAlpha(50),
//                                         Color(todoObject.color).withAlpha(150),
//                                         Color(todoObject.color).withAlpha(10),
//                                         Color(todoObject.color).withAlpha(0),
//                                         // Color(todoObject.color).withOpacity(0.0),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(16.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Expanded(
//                                       flex: 10,
//                                       child: Row(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Stack(
//                                             children: <Widget>[
//                                               Hero(
//                                                 tag: todoObject.uuid + "_backIcon",
//                                                 child: Material(
//                                                   type: MaterialType.transparency,
//                                                   child: Container(
//                                                     height: 0,
//                                                     width: 0,
//                                                     child: IconButton(
//                                                       icon: Icon(Icons.arrow_back),
//                                                       onPressed: null,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Hero(
//                                                 tag: todoObject.uuid + "_icon",
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     shape: BoxShape.circle,
//                                                     border: Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
//                                                   ),
//                                                   child: Padding(
//                                                     padding: EdgeInsets.all(8.0),
//                                                     child: Icon(IconData(todoObject.icon, fontFamily: 'MaterialIcons'), color: Color(todoObject.color)),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Spacer(),
//                                           Hero(
//                                             tag: todoObject.uuid + "_more_vert",
//                                             child: Material(
//                                               color: Colors.transparent,
//                                               type: MaterialType.transparency,
//                                               child: PopupMenuButton(
//                                                 icon: Icon(
//                                                   Icons.more_vert,
//                                                   color: Colors.grey,
//                                                 ),
//                                                 itemBuilder: (context) => <PopupMenuEntry<TodoCardSettings>>[
//                                                   PopupMenuItem(
//                                                     child: Text("Edit Color"),
//                                                     value: TodoCardSettings.edit_color,
//                                                   ),
//                                                   PopupMenuItem(
//                                                     child: Text("Delete"),
//                                                     value: TodoCardSettings.delete,
//                                                   ),
//                                                 ],
//                                                 onSelected: (setting) {
//                                                   if (setting == TodoCardSettings.edit_color) {
//                                                     setState(() {
//                                                       todoObject.color = ColorChoices.choices[Random().nextInt(6)].value;
//                                                       todoObject.save();
//                                                     });
//                                                   } else {
//                                                     print('delete clicked');
//                                                     _hiveDBServices.deleteTodo(todoObject.key);
//                                                   }
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Hero(
//                                       tag: todoObject.uuid + "_number_of_tasks",
//                                       child: Material(
//                                           color: Colors.transparent,
//                                           child: Text(
//                                             todoObject.taskAmount().toString() + " Tasks",
//                                             style: TextStyle(),
//                                             softWrap: false,
//                                           )),
//                                     ),
//                                     Spacer(),
//                                     Hero(
//                                       tag: todoObject.uuid + "_title",
//                                       child: Material(
//                                         color: Colors.transparent,
//                                         child: Text(
//                                           todoObject.category,
//                                           style: TextStyle(fontSize: 30.0),
//                                           softWrap: false,
//                                         ),
//                                       ),
//                                     ),
//                                     Spacer(),
//                                     Hero(
//                                       tag: todoObject.uuid + "_progress_bar",
//                                       child: Material(
//                                         color: Colors.transparent,
//                                         child: Row(
//                                           children: <Widget>[
//                                             Expanded(
//                                               child: LinearProgressIndicator(
//                                                 value: percentComplete,
//                                                 backgroundColor: Colors.grey.withAlpha(50),
//                                                 valueColor: AlwaysStoppedAnimation<Color>(Color(todoObject.color)),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: EdgeInsets.only(left: 5.0),
//                                               child: Text((percentComplete * 100).round().toString() + "%"),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   padding: EdgeInsets.only(left: 40.0, right: 40.0),
//                   scrollDirection: Axis.horizontal,
//                   physics: _CustomScrollPhysics(todoBox),
//                   controller: scrollController,
//                   itemExtent: _width - 80,
//                   itemCount: todoBox.values.length,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30.0, right: 50.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: RichText(
//                     text: TextSpan(
//                       style: TextStyle(
//                         color: Colors.black.withOpacity(0.8),
//                         fontWeight: FontWeight.w300,
//                         fontSize: 16.0,
//                       ),
//                       children: [
//                         WidgetSpan(
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 10.0, right: 5.0),
//                             child: Transform.rotate(
//                               angle: 3.14159,
//                               child: Icon(
//                                 Entypo.quote,
//                                 color: Colors.black54,
//                                 size: 10.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                         TextSpan(text: quotesProvider.content),
//                         WidgetSpan(
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 5.0, right: 50.0),
//                             child: Icon(
//                               Entypo.quote,
//                               color: Colors.black54,
//                               size: 10.0,
//                             ),
//                           ),
//                         ),
//                         WidgetSpan(
//                           child: Align(
//                             alignment: Alignment.topRight,
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 50.0),
//                               child: Text(
//                                 "\n- ${quotesProvider.author}",
//                                 style: TextStyle(
//                                   height: 0.5,
//                                   color: Colors.black.withOpacity(0.8),
//                                   fontWeight: FontWeight.w300,
//                                   fontSize: 12.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Spacer(flex: 2),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class _CustomScrollPhysics extends ScrollPhysics {
//   _CustomScrollPhysics(
//     this.box, {
//     ScrollPhysics parent,
//   }) : super(parent: parent);

//   final Box<TodoModel> box;

//   @override
//   _CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
//     return _CustomScrollPhysics(this.box, parent: buildParent(ancestor));
//   }

//   double _getPage(ScrollPosition position) {
//     return position.pixels / (position.maxScrollExtent / (box.values.length.toDouble() - 1));
//     // return position.pixels / position.viewportDimension;
//   }

//   double _getPixels(ScrollPosition position, double page) {
//     // return page * position.viewportDimension;
//     return page * (position.maxScrollExtent / (box.values.length.toDouble() - 1));
//   }

//   double _getTargetPixels(ScrollPosition position, Tolerance tolerance, double velocity) {
//     double page = _getPage(position);
//     if (velocity < -tolerance.velocity)
//       page -= 0.5;
//     else if (velocity > tolerance.velocity) page += 0.5;
//     return _getPixels(position, page.roundToDouble());
//   }

//   @override
//   Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
//     if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) || (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
//       return super.createBallisticSimulation(position, velocity);
//     final Tolerance tolerance = this.tolerance;
//     final double target = _getTargetPixels(position, tolerance, velocity);
//     if (target != position.pixels) return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
//     return null;
//   }
// }
