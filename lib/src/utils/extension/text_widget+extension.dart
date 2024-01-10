import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lxk_flutter_boilerplate/src/app.dart';
import 'package:lxk_flutter_boilerplate/src/config/color_constants.dart';
import 'package:lxk_flutter_boilerplate/src/utils/app_state_notifier.dart';
import 'package:provider/provider.dart';

extension TextExentension on Text {
  Text withStyle(TextStyle? style) {
    return Text(
      data!,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor
    );
  }

  Text color(Color color) {
    final newStyle = style?.copyWith(color: color);
    return withStyle(newStyle);
  }

  Text get onColorSurface {
    if (Provider.of<AppStateNotifier>(globalContext).isDarkMode) {
      return color(ColorConstants.onColorSurfaceDarkColor);
    }

    return color(ColorConstants.onColorSurfaceColor);
  }
}
