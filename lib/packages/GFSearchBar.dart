import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/card/gf_card.dart';

typedef QueryListItemBuilder<T> = Widget Function(T item);
typedef OnItemSelected<T> = void Function(T item);
typedef QueryBuilder<T> = List<T> Function(
  String query,
  List<T> list,
);

class GFSearchBar<T> extends StatefulWidget {
  /// search bar with variuos customization option
  const GFSearchBar({
    @required this.searchList,
    @required this.overlaySearchListItemBuilder,
    @required this.searchQueryBuilder,
    Key key,
    this.controller,
    this.onItemSelected,
    this.hideSearchBoxWhenItemSelected = false,
    this.overlaySearchListHeight,
    this.noItemsFoundWidget,
    this.searchBoxInputDecoration,
  }) : super(key: key);

  /// List of text or [Widget] reference for users
  final List<T> searchList;

  /// defines how the [searchList] items look like in overlayContainer
  final QueryListItemBuilder<T> overlaySearchListItemBuilder;

  /// if true, it will hide the searchBox
  final bool hideSearchBoxWhenItemSelected;

  /// defines the height of [searchList] overlay container
  final double overlaySearchListHeight;

  /// can search and filter the [searchList]
  final QueryBuilder<T> searchQueryBuilder;

  /// displays the [Widget] when the search item failed
  final Widget noItemsFoundWidget;

  /// defines what to do with onSelect SearchList item
  final OnItemSelected<T> onItemSelected;

  /// defines the input decoration of searchBox
  final InputDecoration searchBoxInputDecoration;

  /// defines the input controller of searchBox
  final TextEditingController controller;

  @override
  MySingleChoiceSearchState<T> createState() => MySingleChoiceSearchState<T>();
}

class MySingleChoiceSearchState<T> extends State<GFSearchBar<T>> {
  List<T> _list;
  List<T> _searchList;
  bool isFocused;
  FocusNode _focusNode;
  ValueNotifier<T> notifier;
  bool isRequiredCheckFailed;
  Widget searchBox;
  OverlayEntry overlaySearchList;
  bool showTextBox = false;
  double overlaySearchListHeight;
  final LayerLink _layerLink = LayerLink();
  final double textBoxHeight = 48;
  TextEditingController textController = TextEditingController();
  bool isSearchBoxSelected = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  String storeTextbeforeClear = '';

  void init() {
    _searchList = <T>[];
    textController = widget.controller ?? textController;
    notifier = ValueNotifier(null);
    _focusNode = FocusNode();
    isFocused = false;
    _list = List<T>.from(widget.searchList);
    _searchList.addAll(_list);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // TODO comment
        storeTextbeforeClear = textController.text;
        textController.clear();
        //
        if (overlaySearchList != null) {
          overlaySearchList.remove();
        }
        overlaySearchList = null;
      } else {
        // _searchList
        //   ..clear()
        //   ..addAll(_list);
        textController.text = storeTextbeforeClear;
        if (overlaySearchList == null) {
          onTextFieldFocus();
        } else {
          overlaySearchList.markNeedsBuild();
        }
      }
    });
    textController.addListener(() {
      final text = textController.text;
      if (text.trim().isNotEmpty) {
        _searchList.clear();
        final filterList = widget.searchQueryBuilder(text, widget.searchList);
        if (filterList == null) {
          throw Exception('List cannot be null');
        }
        _searchList.addAll(filterList);
        if (overlaySearchList == null) {
          onTextFieldFocus();
        } else {
          overlaySearchList.markNeedsBuild();
        }
      } else {
        // _searchList
        //   ..clear()
        //   ..addAll(_list);
        if (overlaySearchList == null) {
          onTextFieldFocus();
        } else {
          overlaySearchList.markNeedsBuild();
        }
      }
    });
  }

  @override
  void didUpdateWidget(GFSearchBar oldWidget) {
    if (oldWidget.searchList != widget.searchList) {
      init();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    overlaySearchListHeight = widget.overlaySearchListHeight ?? MediaQuery.of(context).size.height / 1.55;

    searchBox = Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: textController,
        focusNode: _focusNode,
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        onEditingComplete: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        decoration: widget.searchBoxInputDecoration == null
            ? InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    // color: Theme.of(context).primaryColor,
                    color: Colors.black,
                  ),
                ),
                suffixIcon: isSearchBoxSelected
                    ? InkWell(
                        child: Icon(Icons.close, size: 22, color: Colors.black),
                        onTap: onCloseOverlaySearchList,
                      )
                    : Icon(Icons.search, color: Colors.black),
                border: InputBorder.none,
                hintText: 'Search your ass off',
                hintStyle: TextStyle(
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
                contentPadding: const EdgeInsets.only(
                  left: 16,
                  right: 20,
                  top: 14,
                  bottom: 14,
                ),
              )
            : widget.searchBoxInputDecoration,
      ),
    );

    final searchBoxBody = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.hideSearchBoxWhenItemSelected && notifier.value != null)
          const SizedBox(height: 0)
        else
          CompositedTransformTarget(
            link: _layerLink,
            child: searchBox,
          ),
      ],
    );
    return searchBoxBody;
  }

  void onCloseOverlaySearchList() {
    // onSearchListItemSelected(null);
    if (overlaySearchList != null) {
      overlaySearchList.remove();
    }
    overlaySearchList = null;
    textController.clear();
    _focusNode.unfocus();
    setState(() {
      isSearchBoxSelected = false;
    });
  }

  void onSearchListItemSelected(T item) {
    if (overlaySearchList != null) {
      overlaySearchList.remove();
    }
    overlaySearchList = null;

    // TODO commment
    // _focusNode.unfocus();
    // textController.clear();
    //
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    setState(() {
      notifier.value = item;
      isFocused = false;
      isRequiredCheckFailed = false;
      // isSearchBoxSelected = false;
    });
    if (widget.onItemSelected != null) {
      widget.onItemSelected(item);
    }
  }

  void onTextFieldFocus() {
    setState(() {
      isSearchBoxSelected = true;
    });
    final RenderBox searchBoxRenderBox = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final width = searchBoxRenderBox.size.width;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        searchBoxRenderBox.localToGlobal(
          searchBoxRenderBox.size.topLeft(Offset.zero),
          ancestor: overlay,
        ),
        searchBoxRenderBox.localToGlobal(
          searchBoxRenderBox.size.topRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    overlaySearchList = OverlayEntry(
      builder: (context) => Positioned(
        left: position.left,
        width: width,
        child: CompositedTransformFollower(
          offset: const Offset(
            0,
            56,
          ),
          showWhenUnlinked: false,
          link: _layerLink,
          child: GFCard(
            padding: EdgeInsets.zero,
            color: Colors.transparent,
            elevation: 0,
            content: _searchList.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        // color: Colors.transparent,
                        height: overlaySearchListHeight,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemBuilder: (context, index) => Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () => onSearchListItemSelected(_searchList[index]),
                              child: textController.text.isNotEmpty
                                  ? widget.overlaySearchListItemBuilder(
                                      _searchList.elementAt(index),
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ),
                          itemCount: _searchList.length,
                        ),
                      ),
                    ],
                  )
                : widget.noItemsFoundWidget != null
                    ? Center(
                        child: widget.noItemsFoundWidget,
                      )
                    : Container(
                        child: const Text('no items found'),
                      ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlaySearchList);
  }
}