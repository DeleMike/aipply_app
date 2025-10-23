import 'package:flutter/material.dart';

class OutlinedInputBorder extends InputBorder {
  final BorderRadius borderRadius;

  const OutlinedInputBorder({
    super.borderSide = const BorderSide(),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
  });

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(borderSide.width);
  }

  @override
  int get hashCode => Object.hash(borderSide, borderRadius);

  @override
  bool get isOutline => false;

  @override
  bool get preferPaintInterior => true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is OutlinedInputBorder &&
        other.borderSide == borderSide &&
        other.borderRadius == borderRadius;
  }

  @override
  OutlinedInputBorder copyWith({BorderSide? borderSide, BorderRadius? borderRadius}) {
    return OutlinedInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(
      borderRadius.resolve(textDirection).toRRect(rect).deflate(borderSide.width),
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is OutlinedInputBorder) {
      final OutlinedInputBorder outline = a;
      return OutlinedInputBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t)!,
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is OutlinedInputBorder) {
      final OutlinedInputBorder outline = b;
      return OutlinedInputBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.toRRect(rect);
    final RRect center = outer.deflate(borderSide.width / 2.0);
    canvas.drawRRect(center, paint);
  }

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), paint);
  }

  @override
  OutlinedInputBorder scale(double t) {
    return OutlinedInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
    );
  }
}
