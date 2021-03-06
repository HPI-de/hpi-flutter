import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hpi_flutter/core/core.dart' hide Image;
import 'package:hpi_flutter/feedback/feedback.dart';

class HpiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HpiAppBar({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions = const [],
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shape,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.overflowActions = const [],
    this.overflowActionHandler,
  })  : assert(automaticallyImplyLeading != null),
        assert(actions != null),
        assert(elevation == null || elevation >= 0.0),
        assert(primary != null),
        assert(titleSpacing != null),
        assert(toolbarOpacity != null),
        assert(bottomOpacity != null),
        assert(overflowActions != null),
        // ignore: prefer_is_empty
        assert(overflowActions.length == 0 || overflowActionHandler != null),
        super(key: key);

  final Widget leading;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final Widget flexibleSpace;
  final PreferredSizeWidget bottom;
  final double elevation;
  final ShapeBorder shape;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final bool primary;
  final bool centerTitle;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final List<PopupMenuEntry<String>> overflowActions;
  final OverflowActionHandler overflowActionHandler;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: [
        ...actions,
        _OverflowAction(
          actions: overflowActions,
          actionHandler: overflowActionHandler,
        )
      ],
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      shape: shape,
      backgroundColor: backgroundColor,
      brightness: brightness,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      textTheme: textTheme,
      primary: primary,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
    );
  }
}

class HpiSliverAppBar extends StatelessWidget {
  const HpiSliverAppBar({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions = const [],
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.forceElevated = false,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.expandedHeight,
    this.floating = false,
    this.pinned = false,
    this.shape,
    this.snap = false,
    this.overflowActions = const [],
    this.overflowActionHandler,
  })  : assert(automaticallyImplyLeading != null),
        assert(actions != null),
        assert(forceElevated != null),
        assert(primary != null),
        assert(titleSpacing != null),
        assert(floating != null),
        assert(pinned != null),
        assert(snap != null),
        assert(floating || !snap,
            'The "snap" argument only makes sense for floating app bars.'),
        assert(overflowActions != null),
        // ignore: prefer_is_empty
        assert(overflowActions.length == 0 || overflowActionHandler != null),
        super(key: key);

  final Widget leading;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final Widget flexibleSpace;
  final PreferredSizeWidget bottom;
  final double elevation;
  final bool forceElevated;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final bool primary;
  final bool centerTitle;
  final double titleSpacing;
  final double expandedHeight;
  final bool floating;
  final bool pinned;
  final ShapeBorder shape;
  final bool snap;
  final List<PopupMenuEntry<String>> overflowActions;
  final OverflowActionHandler overflowActionHandler;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: [
        ...actions,
        _OverflowAction(
          actions: overflowActions,
          actionHandler: overflowActionHandler,
        )
      ],
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      forceElevated: forceElevated,
      backgroundColor: backgroundColor,
      brightness: brightness,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      textTheme: textTheme,
      primary: primary,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      shape: shape,
      snap: snap,
    );
  }
}

/// The part of a material design [AppBar] that expands and collapses.
///
/// Most commonly used in in the [SliverAppBar.flexibleSpace] field, a flexible
/// space bar expands and contracts as the app scrolls so that the [AppBar]
/// reaches from the top of the app to the top of the scrolling contents of the
/// app.
///
/// The widget that sizes the [AppBar] must wrap it in the widget returned by
/// [FlexibleSpaceBar.createSettings], to convey sizing information down to the
/// [HpiFlexibleSpaceBar].
///
/// See also:
///
///  * [SliverAppBar], which implements the expanding and contracting.
///  * [AppBar], which is used by [SliverAppBar].
///  * <https://material.io/design/components/app-bars-top.html#behavior>
///
/// Source: [FlexibleSpaceBar]
class HpiFlexibleSpaceBar extends StatefulWidget {
  /// Creates a flexible space bar.
  ///
  /// Most commonly used in the [AppBar.flexibleSpace] field.
  const HpiFlexibleSpaceBar({
    Key key,
    this.title,
    this.background,
    this.centerTitle,
    this.titlePadding,
    this.collapseMode = CollapseMode.parallax,
  })  : assert(collapseMode != null),
        super(key: key);

  /// The primary contents of the flexible space bar when expanded.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Shown behind the [title] when expanded.
  ///
  /// Typically an [Image] widget with [Image.fit] set to [BoxFit.cover].
  final Widget background;

  /// Whether the title should be centered.
  ///
  /// By default this property is true if the current target platform
  /// is [TargetPlatform.iOS], false otherwise.
  final bool centerTitle;

  /// Collapse effect while scrolling.
  ///
  /// Defaults to [CollapseMode.parallax].
  final CollapseMode collapseMode;

  /// Defines how far the [title] is inset from either the widget's
  /// bottom-left or its center.
  ///
  /// Typically this property is used to adjust how far the title is
  /// is inset from the bottom-left and it is specified along with
  /// [centerTitle] false.
  ///
  /// By default the value of this property is
  /// `EdgeInsetsDirectional.only(start: 72, bottom: 16)` if the title is
  /// not centered, `EdgeInsetsDirectional.only(start 0, bottom: 16)` otherwise.
  final EdgeInsetsGeometry titlePadding;

  @override
  _HpiFlexibleSpaceBarState createState() => _HpiFlexibleSpaceBarState();
}

class _HpiFlexibleSpaceBarState extends State<HpiFlexibleSpaceBar> {
  bool _getEffectiveCenterTitle(ThemeData theme) {
    if (widget.centerTitle != null) {
      return widget.centerTitle;
    }
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
    // ignore: avoid_returning_null
    return null;
  }

  Alignment _getTitleAlignment(double t, bool effectiveCenterTitle) {
    if (effectiveCenterTitle) {
      return Alignment.bottomCenter;
    }
    final textDirection = context.directionality;
    assert(textDirection != null);
    switch (textDirection) {
      case TextDirection.rtl:
        return Alignment(1, 1 - t);
      case TextDirection.ltr:
        return Alignment(-1, 1 - t);
    }
    return null;
  }

  double _getCollapsePadding(double t, FlexibleSpaceBarSettings settings) {
    switch (widget.collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent);
      case CollapseMode.none:
        return 0;
      case CollapseMode.parallax:
        final deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0, end: deltaExtent / 4.0).transform(t);
    }
    // ignore: avoid_returning_null
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    assert(settings != null,
        'A HpiFlexibleSpaceBar must be wrapped in the widget returned by HpiFlexibleSpaceBar.createSettings().');

    final children = <Widget>[];

    final deltaExtent = settings.maxExtent - settings.minExtent;

    // 0.0 -> Expanded
    // 1.0 -> Collapsed to toolbar
    final t =
        (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
            .clamp(0.0, 1.0)
            .toDouble();

    // background image
    if (widget.background != null) {
      final fadeStart = math.max(0, 1.0 - kToolbarHeight / deltaExtent);
      const fadeEnd = 1.0;
      assert(fadeStart <= fadeEnd);
      final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
      if (opacity > 0.0) {
        children.add(Positioned(
          top: _getCollapsePadding(t, settings),
          left: 0,
          right: 0,
          height: settings.maxExtent,
          child: Opacity(
            opacity: opacity,
            child: widget.background,
          ),
        ));
      }
    }

    if (widget.title != null) {
      final theme = context.theme;

      Widget title;
      switch (theme.platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          title = widget.title;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          title = Semantics(
            namesRoute: true,
            child: widget.title,
          );
      }

      final opacity = settings.toolbarOpacity;
      if (opacity > 0.0) {
        var titleStyle = theme.primaryTextTheme.headline6;
        titleStyle =
            titleStyle.copyWith(color: titleStyle.color.withOpacity(opacity));
        final effectiveCenterTitle = _getEffectiveCenterTitle(theme);
        final padding = widget.titlePadding ??
            EdgeInsetsDirectional.only(
              start: effectiveCenterTitle
                  ? 0.0
                  : Tween<double>(begin: 16, end: 72).transform(t),
              end: 32,
              bottom: Tween<double>(begin: 16, end: 0).transform(t),
            );
        final scaleValue = Tween<double>(begin: 1.5, end: 1).transform(t);
        final scaleTransform = Matrix4.identity()
          ..scale(scaleValue, scaleValue, 1);
        final titleAlignment = _getTitleAlignment(t, effectiveCenterTitle);
        children.add(
          SafeArea(
            child: Container(
              padding: padding,
              child: Transform(
                alignment: titleAlignment,
                transform: scaleTransform,
                child: Align(
                  alignment: titleAlignment,
                  child: FractionallySizedBox(
                    widthFactor:
                        Tween<double>(begin: 1 / 1.5, end: 1).transform(t),
                    child: DefaultTextStyle(
                      style: titleStyle,
                      child: title,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return ClipRect(child: Stack(children: children));
  }
}

typedef OverflowActionHandler = void Function(String key);

class _OverflowAction extends StatelessWidget {
  const _OverflowAction({
    this.actions = const [],
    this.actionHandler,
  })  : assert(actions != null),
        // ignore: prefer_is_empty
        assert(actions.length == 0 || actionHandler != null);

  final List<PopupMenuEntry<String>> actions;
  final OverflowActionHandler actionHandler;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (selected) {
        switch (selected) {
          case 'app.settings':
            context.rootNavigator.pushNamed('/settings');
            break;
          case 'app.feedback':
            FeedbackDialog.show(context);
            break;
          default:
            actionHandler(selected);
        }
      },
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          if (actions.isNotEmpty) ...[
            ...actions,
            PopupMenuDivider(),
          ],
          PopupMenuItem(
            value: 'app.settings',
            child: Text(context.s.settings),
          ),
          PopupMenuItem(
            value: 'app.feedback',
            child: Text(context.s.feedback_action),
          ),
        ];
      },
    );
  }
}
