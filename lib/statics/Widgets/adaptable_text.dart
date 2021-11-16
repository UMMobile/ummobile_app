import 'package:flutter/material.dart';

/// A widget wich wraps the [text] inside him
///
/// Scales the text font to fit inside the size given
class AdaptableText extends StatelessWidget {
  /// The content string to be display inside the widget
  final String? text;

  /// The style of the [text]
  final TextStyle? style;

  /// The [text] alignment inside the widget
  ///
  /// Defaults to TextAlign.left
  final TextAlign textAlign;

  /// The [text] read direction
  ///
  /// Defaults to left to right
  final TextDirection textDirection;

  /// The minimum value in which the text will stop scaling
  ///
  /// Defaults to 0.5
  final double minimumFontScale;

  /// The [text] behaviour when overflowing
  ///
  /// Defaults to TextOverflow.ellipsis
  final TextOverflow textOverflow;

  const AdaptableText(this.text,
      {this.style,
      this.textAlign = TextAlign.left,
      this.textDirection = TextDirection.ltr,
      this.minimumFontScale = 0.5,
      this.textOverflow = TextOverflow.ellipsis,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextPainter _painter = TextPainter(
        text: TextSpan(text: this.text, style: this.style),
        textAlign: this.textAlign,
        textScaleFactor: 1,
        maxLines: 100,
        textDirection: this.textDirection);

    return LayoutBuilder(
      builder: (context, constraints) {
        _painter.layout(maxWidth: constraints.maxWidth);
        double textScaleFactor = 1;

        if (_painter.height > constraints.maxHeight) {
          //
          //print('${_painter.size}');
          _painter.textScaleFactor = minimumFontScale;
          _painter.layout(maxWidth: constraints.maxWidth);
          //print('${_painter.size}');

          if (_painter.height > constraints.maxHeight) {
            //
            //even minimum does not fit render it with minimum size
            //print("Using minimum set font");
            textScaleFactor = minimumFontScale;
          } else if (minimumFontScale < 1) {
            //binary search for valid Scale factor
            int h = 100;
            int l = (minimumFontScale * 100).toInt();
            while (h > l) {
              int mid = (l + (h - l) / 2).toInt();
              double newScale = mid.toDouble() / 100.0;
              _painter.textScaleFactor = newScale;
              _painter.layout(maxWidth: constraints.maxWidth);

              if (_painter.height > constraints.maxHeight) {
                //
                h = mid - 1;
              } else {
                l = mid + 1;
              }
              if (h <= l) {
                //print('${_painter.size}');
                textScaleFactor = newScale - 0.01;
                _painter.textScaleFactor = newScale;
                _painter.layout(maxWidth: constraints.maxWidth);
                break;
              }
            }
          }
        }

        return Text(
          this.text!,
          style: this.style,
          textAlign: this.textAlign,
          textDirection: this.textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: 100,
          overflow: textOverflow,
        );
      },
    );
  }
}
