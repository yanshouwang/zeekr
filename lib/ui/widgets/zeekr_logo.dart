import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Possible ways to draw Zeekr's logo.
enum ZeekrLogoStyle {
  /// Show only Zeekr's logo, not the "Zeekr" label.
  ///
  /// This is the default behavior for [ZeekrLogoDecoration] objects.
  markOnly,

  /// Show Zeekr's logo on the left, and the "Zeekr" label to its right.
  horizontal,

  /// Show Zeekr's logo above the "Zeekr" label.
  stacked,
}

/// The Zeekr logo, in widget form. This widget respects the [IconTheme].
///
/// See also:
///
///  * [IconTheme], which provides ambient configuration for icons.
///  * [Icon], for showing icons the Material design icon library.
///  * [ImageIcon], for showing icons from [AssetImage]s or other [ImageProvider]s.
class ZeekrLogo extends StatelessWidget {
  /// The size of the logo in logical pixels.
  ///
  /// The logo will be fit into a square this size.
  ///
  /// Defaults to the current [IconTheme] size, if any. If there is no
  /// [IconTheme], or it does not specify an explicit size, then it defaults to
  /// 24.0.
  final double? size;

  /// The color used to paint the logo.
  final Color color;

  /// The color used to paint the "Zeekr" text on the logo, if [style] is
  /// [ZeekrLogoStyle.horizontal] or [ZeekrLogoStyle.stacked].
  ///
  /// If possible, the default (a medium grey) should be used against a white
  /// background.
  final Color textColor;

  /// Whether and where to draw the "Zeekr" text. By default, only the logo
  /// itself is drawn.
  final ZeekrLogoStyle style;

  /// The length of time for the animation if the [style], [color] or
  /// [textColor] properties are changed.
  final Duration duration;

  /// The curve for the logo animation if the [style], [color] or [textColor]
  /// change.
  final Curve curve;

  /// Creates a widget that paints the Zeekr logo.
  ///
  /// The [size] defaults to the value given by the current [IconTheme].
  ///
  /// The [color], [textColor], [style], [duration], and [curve] arguments must not be
  /// null.
  const ZeekrLogo({
    super.key,
    this.size,
    this.color = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFFFFFFFF),
    this.style = ZeekrLogoStyle.markOnly,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.fastOutSlowIn,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final iconSize = size ?? iconTheme.size;
    return AnimatedContainer(
      width: iconSize,
      height: iconSize,
      duration: duration,
      curve: curve,
      decoration: ZeekrLogoDecoration(
        color: color,
        textColor: textColor,
        style: style,
      ),
    );
  }
}

/// An immutable description of how to paint Zeekr's logo.
class ZeekrLogoDecoration extends Decoration {
  /// Linearly interpolate between two Zeekr logo descriptions.
  ///
  /// Interpolates both the color and the style in a continuous fashion.
  ///
  /// If both values are null, this returns null. Otherwise, it returns a
  /// non-null value. If one of the values is null, then the result is obtained
  /// by scaling the other value's opacity and [margin].
  ///
  /// {@macro dart.ui.shadow.lerp}
  ///
  /// See also:
  ///
  ///  * [Decoration.lerp], which interpolates between arbitrary decorations.
  static ZeekrLogoDecoration? lerp(
    ZeekrLogoDecoration? a,
    ZeekrLogoDecoration? b,
    double t,
  ) {
    assert(a == null || a.debugAssertIsValid());
    assert(b == null || b.debugAssertIsValid());
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return ZeekrLogoDecoration._(
        b!.color,
        b.textColor,
        b.style,
        b.margin * t,
        b._position,
        b._opacity * ui.clampDouble(t, 0.0, 1.0),
      );
    }
    if (b == null) {
      return ZeekrLogoDecoration._(
        a.color,
        a.textColor,
        a.style,
        a.margin * t,
        a._position,
        a._opacity * ui.clampDouble(1.0 - t, 0.0, 1.0),
      );
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return ZeekrLogoDecoration._(
      Color.lerp(a.color, b.color, t)!,
      Color.lerp(a.textColor, b.textColor, t)!,
      t < 0.5 ? a.style : b.style,
      EdgeInsets.lerp(a.margin, b.margin, t)!,
      a._position + (b._position - a._position) * t,
      ui.clampDouble(a._opacity + (b._opacity - a._opacity) * t, 0.0, 1.0),
    );
  }

  /// The color used to paint the logo.
  final Color color;

  /// The color used to paint the "Zeekr" text on the logo, if [style] is
  /// [ZeekrLogoStyle.horizontal] or [ZeekrLogoStyle.stacked].
  ///
  /// If possible, the default (a medium grey) should be used against a white
  /// background.
  final Color textColor;

  /// Whether and where to draw the "Zeekr" text. By default, only the logo
  /// itself is drawn.
  // This property isn't actually used when painting. It's only really used to
  // set the internal _position property.
  final ZeekrLogoStyle style;

  /// How far to inset the logo from the edge of the container.
  final EdgeInsets margin;

  // The following are set when lerping, to represent states that can't be
  // represented by the constructor.
  final double
  _position; // -1.0 for stacked, 1.0 for horizontal, 0.0 for no logo
  final double _opacity; // 0.0 .. 1.0

  /// Creates a decoration that knows how to paint Zeekr's logo.
  ///
  /// The [color] controls the color of the logo, the [style] controls whether
  /// and where to draw the "Zeekr" label. If one
  /// is shown, the [textColor] controls the color of the label.
  const ZeekrLogoDecoration({
    this.color = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFFFFFFFF),
    this.style = ZeekrLogoStyle.markOnly,
    this.margin = EdgeInsets.zero,
  }) : _position =
           identical(style, ZeekrLogoStyle.markOnly)
               ? 0.0
               : identical(style, ZeekrLogoStyle.horizontal)
               ? 1.0
               : -1.0,
       _opacity = 1.0;

  const ZeekrLogoDecoration._(
    this.color,
    this.textColor,
    this.style,
    this.margin,
    this._position,
    this._opacity,
  );

  bool get _inTransition =>
      _opacity != 1.0 ||
      (_position != -1.0 && _position != 0.0 && _position != 1.0);

  @override
  bool get isComplex => !_inTransition;

  @override
  bool debugAssertIsValid() {
    assert(_position.isFinite && _opacity >= 0.0 && _opacity <= 1.0);
    return true;
  }

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    assert(debugAssertIsValid());
    if (a is ZeekrLogoDecoration?) {
      assert(a?.debugAssertIsValid() ?? true);
      return ZeekrLogoDecoration.lerp(a, this, t);
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    assert(debugAssertIsValid());
    if (b is ZeekrLogoDecoration?) {
      assert(b?.debugAssertIsValid() ?? true);
      return ZeekrLogoDecoration.lerp(this, b, t);
    }
    return super.lerpTo(b, t);
  }

  @override
  // TODO(ianh): better hit testing
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) =>
      true;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    assert(debugAssertIsValid());
    return _ZeekrLogoPainter(this);
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(rect);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('textColor', textColor));
    properties.add(EnumProperty<ZeekrLogoStyle>('style', style));
    if (_inTransition) {
      properties.add(
        DiagnosticsNode.message(
          'transition ${debugFormatDouble(_position)}:${debugFormatDouble(_opacity)}',
        ),
      );
    }
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return Object.hash(color, textColor, _position, _opacity);
  }

  @override
  bool operator ==(Object other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) {
      return true;
    }
    return other is ZeekrLogoDecoration &&
        other.color == color &&
        other.textColor == textColor &&
        other._position == _position &&
        other._opacity == _opacity;
  }
}

/// An object that paints a [BoxDecoration] into a canvas.
class _ZeekrLogoPainter extends BoxPainter {
  final ZeekrLogoDecoration _config;

  // these are configured assuming a font size of 100.0.
  late TextPainter _textPainter;
  late Rect _textBoundingRect;

  _ZeekrLogoPainter(this._config) : assert(_config.debugAssertIsValid()) {
    _prepareText();
  }

  @override
  void paint(
    ui.Canvas canvas,
    ui.Offset offset,
    ImageConfiguration configuration,
  ) {
    offset += _config.margin.topLeft;
    final canvasSize = _config.margin.deflateSize(configuration.size!);
    if (canvasSize.isEmpty) {
      return;
    }
    final logoSize = switch (_config._position) {
      > 0.0 => const Size(446.0, 112.0), // horizontal style
      < 0.0 => const Size(290.0, 192.0), // stacked style
      _ => const Size(112.0, 112.0), // only the mark
    };
    final fittedSize = applyBoxFit(BoxFit.contain, logoSize, canvasSize);
    assert(fittedSize.source == logoSize);
    final rect = Alignment.center.inscribe(
      fittedSize.destination,
      offset & canvasSize,
    );
    final centerSquareHeight = canvasSize.shortestSide;
    final centerSquare = Rect.fromLTWH(
      offset.dx + (canvasSize.width - centerSquareHeight) / 2.0,
      offset.dy + (canvasSize.height - centerSquareHeight) / 2.0,
      centerSquareHeight,
      centerSquareHeight,
    );

    final Rect logoTargetSquare;
    if (_config._position > 0.0) {
      // horizontal style
      logoTargetSquare = Rect.fromLTWH(
        rect.left,
        rect.top,
        rect.height,
        rect.height,
      );
    } else if (_config._position < 0.0) {
      // stacked style
      final logoHeight = rect.height * 112.0 / 192.0;
      logoTargetSquare = Rect.fromLTWH(
        rect.left + (rect.width - logoHeight) / 2.0,
        rect.top,
        logoHeight,
        logoHeight,
      );
    } else {
      // only the mark
      logoTargetSquare = centerSquare;
    }
    final logoSquare =
        Rect.lerp(centerSquare, logoTargetSquare, _config._position.abs())!;

    if (_config._opacity < 1.0) {
      canvas.saveLayer(
        offset & canvasSize,
        Paint()
          ..colorFilter = ColorFilter.mode(
            const Color(0xFFFFFFFF).withValues(alpha: _config._opacity),
            BlendMode.modulate,
          ),
      );
    }
    if (_config._position != 0.0) {
      if (_config._position > 0.0) {
        // horizontal style
        final fontSize = 36.0 / 112.0 * logoTargetSquare.height;
        final scale = fontSize / 100.0;
        final finalLeftTextPosition = // position of text in rest position
            (155.0 / 446.0) *
            rect.width; // 155.0 is the distance from the left edge to the left of the F when the whole logo is 446.0 wide
        final initialLeftTextPosition = // position of text when just starting the animation
            rect.width / 2.0 - _textBoundingRect.width * scale;
        final textOffset = Offset(
          rect.left +
              ui.lerpDouble(
                initialLeftTextPosition,
                finalLeftTextPosition,
                _config._position,
              )!,
          rect.top + (rect.height - _textBoundingRect.height * scale) / 2.0,
        );
        canvas.save();
        if (_config._position <= 1.0) {
          final center = logoSquare.center;
          final path =
              Path()
                ..moveTo(center.dx, center.dy)
                ..lineTo(center.dx + rect.width, center.dy - rect.width)
                ..lineTo(center.dx + rect.width, center.dy + rect.width)
                ..close();
          canvas.clipPath(path);
        }
        // Fat label with double scale x.
        canvas.translate(textOffset.dx, textOffset.dy);
        canvas.scale(scale * 2.0, scale);
        _textPainter.paint(canvas, Offset.zero);
        canvas.restore();
      } else if (_config._position < 0.0) {
        // stacked style
        final fontSize = 36.0 / 112.0 * logoTargetSquare.height;
        final scale = fontSize / 100.0;
        if (_config._position > -1.0) {
          // This limits what the drawRect call below is going to blend with.
          canvas.saveLayer(_textBoundingRect, Paint());
        } else {
          canvas.save();
        }
        // Fat label with double scale x.
        canvas.translate(
          logoTargetSquare.center.dx - (_textBoundingRect.width * scale),
          rect.bottom - _textBoundingRect.height * scale,
        );
        canvas.scale(scale * 2.0, scale);
        _textPainter.paint(canvas, Offset.zero);
        if (_config._position > -1.0) {
          canvas.drawRect(
            _textBoundingRect.inflate(_textBoundingRect.width * 0.5),
            Paint()
              ..blendMode = BlendMode.modulate
              ..shader = ui.Gradient.linear(
                Offset(_textBoundingRect.width * -0.5, 0.0),
                Offset(_textBoundingRect.width * 1.5, 0.0),
                <Color>[
                  const Color(0xFFFFFFFF),
                  const Color(0xFFFFFFFF),
                  const Color(0x00FFFFFF),
                  const Color(0x00FFFFFF),
                ],
                <double>[
                  0.0,
                  math.max(0.0, _config._position.abs() - 0.1),
                  math.min(_config._position.abs() + 0.1, 1.0),
                  1.0,
                ],
              ),
          );
        }
        canvas.restore();
      }
    }
    _paintLogo(canvas, logoSquare);
    if (_config._opacity < 1.0) {
      canvas.restore();
    }
  }

  void _prepareText() {
    const kLabel = 'ZEEKR';
    _textPainter = TextPainter(
      text: TextSpan(
        text: kLabel,
        style: TextStyle(
          color: _config.textColor,
          fontFamily: 'LynkcoType',
          fontSize:
              100.0 *
              350.0 /
              247.0, // 247 is the height of the F when the fontSize is 350, assuming device pixel ratio 1.0
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPainter.layout();
    final textSize =
        _textPainter
            .getBoxesForSelection(
              const TextSelection(baseOffset: 0, extentOffset: kLabel.length),
            )
            .single;
    _textBoundingRect = Rect.fromLTRB(
      textSize.left,
      textSize.top,
      textSize.right,
      textSize.bottom,
    );
  }

  // This class contains a lot of magic numbers. They were derived from the
  // values in the SVG files exported from the original artwork source.
  void _paintLogo(Canvas canvas, Rect rect) {
    // Our points are in a coordinate space that's 112 pixels wide and 112 pixels high.
    // First, transform the rectangle so that our coordinate space is a square 112 pixels
    // to a side, with the top left at the origin.
    canvas.save();
    canvas.translate(rect.left, rect.top);
    canvas.scale(rect.width / 112.0, rect.height / 112.0);
    // Set up the styles.
    final paint = Paint()..color = _config.color;
    // Draw the shape.
    final Path topBeam =
        Path()
          ..moveTo(0.0, 0.0)
          ..lineTo(112.0, 0.0)
          ..lineTo(112.0, 112.0)
          ..lineTo(0.0, 112.0)
          ..moveTo(10.0, 10.0)
          ..lineTo(10.0, 102.0)
          ..lineTo(65.0, 102.0)
          ..lineTo(65.0, 72.0)
          ..lineTo(37.0, 44.0)
          ..lineTo(37.0, 10.0)
          ..moveTo(102.0, 102.0)
          ..lineTo(102.0, 10.0)
          ..lineTo(47.0, 10.0)
          ..lineTo(47.0, 40.0)
          ..lineTo(75.0, 68.0)
          ..lineTo(75.0, 102.0);
    canvas.drawPath(topBeam, paint);
    canvas.restore();
  }

  @override
  void dispose() {
    _textPainter.dispose();
    super.dispose();
  }
}
