import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

class GlassmorphicScaffold extends StatelessWidget {
  final Widget child;
  final bool extendBody;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const GlassmorphicScaffold({
    super.key,
    required this.child,
    this.extendBody = false,
    this.bottomNavigationBar,
    this.appBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppTheme.lightGrey,
      extendBody: extendBody,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: AppTheme.getBackgroundGradient(context),
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double? opacity;
  final double blur;
  final Border? border;
  final bool useBlur;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.opacity,
    this.blur = 10.0,
    this.border,
    this.useBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : Colors.black;
    final defaultOpacity = isDark ? 0.1 : 0.05;
    
    final container = Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: (backgroundColor ?? defaultColor).withOpacity(opacity ?? defaultOpacity),
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.borderRadius),
        border: border ?? Border.all(
          color: isDark ? AppTheme.borderColor : AppTheme.borderColorLight,
          width: 1,
        ),
      ),
      child: child,
    );

    if (!useBlur) {
      return Container(
        margin: margin,
        child: container,
      );
    }

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
          ),
          child: container,
        ),
      ),
    );
  }
}

class GlassmorphicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const GlassmorphicButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(8.0),
      width: width,
      height: height,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor ?? AppTheme.primaryGrey,
      opacity: 1.0,
      useBlur: false,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.borderRadius),
          child: child,
        ),
      ),
    );
  }
}

class GlassmorphicTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle? style;
  final ValueChanged<String>? onSubmitted;

  const GlassmorphicTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.style,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassmorphicContainer(
      useBlur: false,
      opacity: isDark ? 0.15 : 0.08,
      backgroundColor: isDark ? Colors.white : Colors.black,
      border: Border.all(
        color: isDark ? AppTheme.borderColor : AppTheme.borderColorLight,
        width: 1,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: style ?? (isDark ? AppTheme.bodyStyle : AppTheme.bodyStyleLight),
        onSubmitted: onSubmitted,
        decoration: (isDark ? AppTheme.glassmorphicInputDecoration : AppTheme.glassmorphicInputDecorationLight).copyWith(
          hintText: hintText,
        ),
      ),
    );
  }
} 