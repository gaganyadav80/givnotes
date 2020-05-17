// *** main.dart
// _write(String text) async {
//   final Directory directory = await getApplicationDocumentsDirectory();
//   final File file = File('${directory.path}/isSkipped.txt');
//   await file.writeAsString(text);
// }

// Future<String> _read() async {
//   String text;
//   try {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final File file = File('${directory.path}/my_file.txt');
//     text = await file.readAsString();
//   } catch (e) {
//     print("Couldn't read file");
//   }
//   return text;
// }

// *** homePageItems.dart
// ! Floating AppBar
// Widget floatingAppBar(String title) {
//   return Container(
//     margin: EdgeInsets.only(top: 10),
//     child: FloatingSearchBar.builder(
//       pinned: true,
//       title: Text(
//         title,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontFamily: 'SourceSansPro',
//           letterSpacing: 2,
//         ),
//       ),
//       itemCount: 100,
//       itemBuilder: (BuildContext context, int index) {
//         return ListTile(
//           leading: Text(index.toString()),
//         );
//       },
//       drawer: DrawerItems(),
//       onChanged: (String value) {},
//       onTap: () {},
//       // decoration: InputDecoration.collapsed(
//       //   hintText: "Search ...",
//       // ),
//     ),
//   );
// }

// ! This is for the custom AppBar
// class CustomAppBar extends StatefulWidget {
//   final String title;
//   CustomAppBar(this.title);

//   @override
//   _CustomAppBarState createState() => _CustomAppBarState();
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(2),
//       height: 80,
//       width: double.infinity,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(13),
//         ),
//         elevation: 50,
//         color: Colors.black,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             IconButton(
//               padding: EdgeInsets.only(left: 10),
//               icon: Icon(
//                 Icons.menu,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             ),
//             Text(
//               widget.title, // title
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontFamily: 'SourceSansPro-Light',
//                 letterSpacing: 3,
//               ),
//             ),
//             IconButton(
//               padding: EdgeInsets.only(right: 10),
//               icon: Icon(
//                 Icons.more_vert,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// *** profile.dart
// : MaterialButton(
//     color: Colors.black,
//     child: Text(
//       'Sign In',
//       style: TextStyle(
//         fontFamily: 'Montserrat',
//         fontSize: 20,
//         color: Colors.white,
//       ),
//     ),
//     onPressed: () {
//       signInWithGoogle().then((FirebaseUser currentUser) {
//         print('Sign in User Current : ${currentUser.displayName}');
//         setUserDetails();
//         setSkip(skip: false);
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => MyProfile()));
//       }).catchError((e) => print(e));
//     },
//   ),

//  MaterialButton(
//     color: Colors.white,
//     elevation: 10,
//     child: Text(
//       'Sign Out',
//       style: TextStyle(
//         fontSize: 20,
//         fontFamily: 'Montserrat',
//         color: Colors.black,
//       ),
//     ),
//     onPressed: () {
//       _signOutAlert(context);
//     },
//   )

// *** notesEdit.dart
// TODO: check why this does not work
// Widget confirmDelete(BuildContext context, int _id) {
//   return Scaffold(
//     body: GFFloatingWidget(
//       child: GFAlert(
//         title: 'Confirm Delete?',
//         content: 'Are you sure you permanently want to delete your note?',
//         type: GFAlertType.rounded,
//         bottombar: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             MaterialButton(
//               color: Colors.red,
//               child: Text(
//                 'CANCLE',
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             SizedBox(width: 10),
//             MaterialButton(
//               color: Colors.red,
//               child: Text(
//                 'DELETE',
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () async {
//                 await NotesDB.deleteNote(_id);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
