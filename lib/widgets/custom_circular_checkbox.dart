// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomCircularCheckBox extends StatefulWidget {
  const CustomCircularCheckBox({
    Key key,
    @required this.value,
    this.tristate = false,
    @required this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    ///! edited value
    @required this.width,
  })  : assert(tristate != null),
        assert(tristate || value != null),
        assert(autofocus != null),
        super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;
  final MouseCursor mouseCursor;
  final Color activeColor;
  final MaterialStateProperty<Color> fillColor;
  final Color checkColor;
  final bool tristate;
  final MaterialTapTargetSize materialTapTargetSize;
  final VisualDensity visualDensity;
  final Color focusColor;
  final Color hoverColor;
  final MaterialStateProperty<Color> overlayColor;
  final double splashRadius;
  final FocusNode focusNode;
  final bool autofocus;

  /// {@template flutter.material.checkbox.shape}
  /// The shape of the checkbox's [Material].
  /// {@endtemplate}
  ///
  /// If this property is null then [CheckboxThemeData.shape] of [ThemeData.checkboxTheme]
  /// is used. If that's null then the shape will be a [RoundedRectangleBorder]
  /// with a circular corner radius of 1.0.
  final OutlinedBorder shape;

  /// {@template flutter.material.checkbox.side}
  /// The side of the checkbox's border.
  /// {@endtemplate}
  ///
  /// If this property is null then [CheckboxThemeData.side] of [ThemeData.checkboxTheme]
  /// is used. If that's null then the side will be width 2.
  final BorderSide side;

  /// The width of a checkbox widget.
  /// static const double width = 18.0;
  final double width;

  @override
  _CustomCircularCheckBoxState createState() => _CustomCircularCheckBoxState();
}

class _CustomCircularCheckBoxState extends State<CustomCircularCheckBox> with TickerProviderStateMixin, ToggleableStateMixin {
  _CustomCheckboxPainter _painter;
  bool _previousValue;

  @override
  void initState() {
    super.initState();
    // _kEdgeSize = widget.width;
    _painter = _CustomCheckboxPainter(widget.width);
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(CustomCircularCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool> get onChanged => widget.onChanged;

  @override
  bool get tristate => widget.tristate;

  @override
  bool get value => widget.value;

  MaterialStateProperty<Color> get _widgetFillColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return widget.activeColor;
      }
      return null;
    });
  }

  MaterialStateProperty<Color> get _defaultFillColor {
    final ThemeData themeData = Theme.of(context);
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return themeData.disabledColor;
      }
      if (states.contains(MaterialState.selected)) {
        return themeData.toggleableActiveColor;
      }
      return themeData.unselectedWidgetColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialTapTargetSize effectiveMaterialTapTargetSize = widget.materialTapTargetSize ?? themeData.checkboxTheme.materialTapTargetSize ?? themeData.materialTapTargetSize;
    final VisualDensity effectiveVisualDensity = widget.visualDensity ?? themeData.checkboxTheme.visualDensity ?? themeData.visualDensity;
    Size size;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
        break;
    }
    size += effectiveVisualDensity.baseSizeAdjustment;

    final MaterialStateProperty<MouseCursor> effectiveMouseCursor = MaterialStateProperty.resolveWith<MouseCursor>((Set<MaterialState> states) {
      return MaterialStateProperty.resolveAs<MouseCursor>(widget.mouseCursor, states) ?? themeData.checkboxTheme.mouseCursor?.resolve(states) ?? MaterialStateMouseCursor.clickable.resolve(states);
    });

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> activeStates = states..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = states..remove(MaterialState.selected);
    final Color effectiveActiveColor =
        widget.fillColor?.resolve(activeStates) ?? _widgetFillColor.resolve(activeStates) ?? themeData.checkboxTheme.fillColor?.resolve(activeStates) ?? _defaultFillColor.resolve(activeStates);
    final Color effectiveInactiveColor = widget.fillColor?.resolve(inactiveStates) ??
        _widgetFillColor.resolve(inactiveStates) ??
        themeData.checkboxTheme.fillColor?.resolve(inactiveStates) ??
        _defaultFillColor.resolve(inactiveStates);

    final Set<MaterialState> focusedStates = states..add(MaterialState.focused);
    final Color effectiveFocusOverlayColor = widget.overlayColor?.resolve(focusedStates) ?? widget.focusColor ?? themeData.checkboxTheme.overlayColor?.resolve(focusedStates) ?? themeData.focusColor;

    final Set<MaterialState> hoveredStates = states..add(MaterialState.hovered);
    final Color effectiveHoverOverlayColor = widget.overlayColor?.resolve(hoveredStates) ?? widget.hoverColor ?? themeData.checkboxTheme.overlayColor?.resolve(hoveredStates) ?? themeData.hoverColor;

    final Set<MaterialState> activePressedStates = activeStates..add(MaterialState.pressed);
    final Color effectiveActivePressedOverlayColor =
        widget.overlayColor?.resolve(activePressedStates) ?? themeData.checkboxTheme.overlayColor?.resolve(activePressedStates) ?? effectiveActiveColor.withAlpha(kRadialReactionAlpha);

    final Set<MaterialState> inactivePressedStates = inactiveStates..add(MaterialState.pressed);
    final Color effectiveInactivePressedOverlayColor =
        widget.overlayColor?.resolve(inactivePressedStates) ?? themeData.checkboxTheme.overlayColor?.resolve(inactivePressedStates) ?? effectiveActiveColor.withAlpha(kRadialReactionAlpha);

    final Color effectiveCheckColor = widget.checkColor ?? themeData.checkboxTheme.checkColor?.resolve(states) ?? const Color(0xFFFFFFFF);

    return Semantics(
      checked: widget.value == true,
      child: buildToggleable(
        mouseCursor: effectiveMouseCursor,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        size: size,
        painter: _painter
          ..position = position
          ..reaction = reaction
          ..reactionFocusFade = reactionFocusFade
          ..reactionHoverFade = reactionHoverFade
          ..inactiveReactionColor = effectiveInactivePressedOverlayColor
          ..reactionColor = effectiveActivePressedOverlayColor
          ..hoverColor = effectiveHoverOverlayColor
          ..focusColor = effectiveFocusOverlayColor
          ..splashRadius = widget.splashRadius ?? themeData.checkboxTheme.splashRadius ?? kRadialReactionRadius
          ..downPosition = downPosition
          ..isFocused = states.contains(MaterialState.focused)
          ..isHovered = states.contains(MaterialState.hovered)
          ..activeColor = effectiveActiveColor
          ..inactiveColor = effectiveInactiveColor
          ..checkColor = effectiveCheckColor
          ..value = value
          ..previousValue = _previousValue
          ..shape = widget.shape ?? themeData.checkboxTheme.shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.0)))
          ..side = widget.side ?? themeData.checkboxTheme.side,
      ),
    );
  }
}

///! edited value
/// const double _kEdgeSize = CustomCheckbox.width;
/// double _kEdgeSize = 0.0;
const double _kStrokeWidth = 2.0;

class _CustomCheckboxPainter extends ToggleablePainter {
  _CustomCheckboxPainter(this._kEdgeSize);

  final double _kEdgeSize;

  Color get checkColor => _checkColor;
  Color _checkColor;
  set checkColor(Color value) {
    if (_checkColor == value) {
      return;
    }
    _checkColor = value;
    notifyListeners();
  }

  bool get value => _value;
  bool _value;
  set value(bool value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  bool get previousValue => _previousValue;
  bool _previousValue;
  set previousValue(bool value) {
    if (_previousValue == value) {
      return;
    }
    _previousValue = value;
    notifyListeners();
  }

  OutlinedBorder get shape => _shape;
  OutlinedBorder _shape;
  set shape(OutlinedBorder value) {
    if (_shape == value) {
      return;
    }
    _shape = value;
    notifyListeners();
  }

  BorderSide get side => _side;
  BorderSide _side;
  set side(BorderSide value) {
    if (_side == value) {
      return;
    }
    _side = value;
    notifyListeners();
  }

  // The square outer bounds of the checkbox at t, with the specified origin.
  // At t == 0.0, the outer rect's size is _kEdgeSize (Checkbox.width)
  // At t == 0.5, .. is _kEdgeSize - _kStrokeWidth
  // At t == 1.0, .. is _kEdgeSize
  Rect _outerRectAt(Offset origin, double t) {
    final double inset = 1.0 - (t - 0.5).abs() * 2.0;
    final double size = _kEdgeSize - inset * _kStrokeWidth;
    final Rect rect = Rect.fromLTWH(origin.dx + inset, origin.dy + inset, size, size);
    return rect;
  }

  // The checkbox's border color if value == false, or its fill color when
  // value == true or null.
  Color _colorAt(double t) {
    // As t goes from 0.0 to 0.25, animate from the inactiveColor to activeColor.
    return t >= 0.25 ? activeColor : Color.lerp(inactiveColor, activeColor, t * 4.0);
  }

  // White stroke used to paint the check and dash.
  Paint _createStrokePaint() {
    return Paint()
      ..color = checkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kStrokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  void _drawBorder(Canvas canvas, Rect outer, double t, Paint paint) {
    assert(t >= 0.0 && t <= 0.5);
    OutlinedBorder resolvedShape = shape;
    if (side == null) {
      resolvedShape = resolvedShape.copyWith(side: BorderSide(width: 2, color: paint.color));
    }
    resolvedShape.copyWith(side: side).paint(canvas, outer);
  }

  void _drawCheck(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the two check mark strokes from the
    // short side to the long side.
    final Path path = Path();
    ///! edited value => added 2.0
    final Offset start = Offset(_kEdgeSize * 0.15 + 2.0, _kEdgeSize * 0.45 + 2.0);
    final Offset mid = Offset(_kEdgeSize * 0.4, _kEdgeSize * 0.7);
    final Offset end = Offset(_kEdgeSize * 0.85, _kEdgeSize * 0.25);
    if (t < 0.5) {
      final double strokeT = t * 2.0;
      final Offset drawMid = Offset.lerp(start, mid, strokeT);
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
    } else {
      final double strokeT = (t - 0.5) * 2.0;
      final Offset drawEnd = Offset.lerp(mid, end, strokeT);
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
      path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawDash(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the horizontal line from the
    // mid point outwards.
    final Offset start = Offset(_kEdgeSize * 0.2, _kEdgeSize * 0.5);
    final Offset mid = Offset(_kEdgeSize * 0.5, _kEdgeSize * 0.5);
    final Offset end = Offset(_kEdgeSize * 0.8, _kEdgeSize * 0.5);
    final Offset drawStart = Offset.lerp(start, mid, 1.0 - t);
    final Offset drawEnd = Offset.lerp(mid, end, t);
    canvas.drawLine(origin + drawStart, origin + drawEnd, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final Paint strokePaint = _createStrokePaint();
    final Offset origin = size / 2.0 - Size.square(_kEdgeSize) / 2.0 as Offset;
    final AnimationStatus status = position.status;
    final double tNormalized = status == AnimationStatus.forward || status == AnimationStatus.completed ? position.value : 1.0 - position.value;

    // Four cases: false to null, false to true, null to false, true to false
    if (previousValue == false || value == false) {
      final double t = value == false ? 1.0 - tNormalized : tNormalized;
      final Rect outer = _outerRectAt(origin, t);
      final Path emptyCheckboxPath = shape.copyWith(side: side).getOuterPath(outer);
      final Paint paint = Paint()..color = _colorAt(t);

      if (t <= 0.5) {
        _drawBorder(canvas, outer, t, paint);
      } else {
        canvas.drawPath(emptyCheckboxPath, paint);

        final double tShrink = (t - 0.5) * 2.0;
        if (previousValue == null || value == null)
          _drawDash(canvas, origin, tShrink, strokePaint);
        else
          ///! edited valued => divide 2.0 and multiply 1.8
          _drawCheck(canvas, origin, (tShrink / 2.0) * 1.8, strokePaint);
      }
    } else {
      // Two cases: null to true, true to null
      final Rect outer = _outerRectAt(origin, 1.0);
      final Paint paint = Paint()..color = _colorAt(1.0);
      canvas.drawPath(shape.copyWith(side: side).getOuterPath(outer), paint);

      if (tNormalized <= 0.5) {
        final double tShrink = 1.0 - tNormalized * 2.0;
        if (previousValue == true)
          _drawCheck(canvas, origin, tShrink, strokePaint);
        else
          _drawDash(canvas, origin, tShrink, strokePaint);
      } else {
        final double tExpand = (tNormalized - 0.5) * 2.0;
        if (value == true)
          _drawCheck(canvas, origin, tExpand, strokePaint);
        else
          _drawDash(canvas, origin, tExpand, strokePaint);
      }
    }
  }
}
