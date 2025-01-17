import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../foundation.dart';
import 'material_master_detail_page_route.dart';

/// A scaffold for implementing the master-detail flow
class MasterDetailScaffold extends StatefulWidget {
  const MasterDetailScaffold(
      {required this.masterPaneBuilder,
      required this.masterPaneWidth,
      this.detailsAppBar,
      required this.detailsPaneBuilder,
      required this.appBar,
      required this.initialRoute,
      required this.detailsRoute,
      this.onDetailsPaneRouteChanged,
      this.initialDetailsPaneBuilder,
      this.twoPanesWidthBreakpoint,
      this.pageRouteBuilder,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.persistentFooterButtons,
      this.drawer,
      this.endDrawer,
      this.bottomNavigationBar,
      this.bottomSheet,
      this.backgroundColor,
      this.resizeToAvoidBottomInset,
      this.primary = true,
      this.drawerDragStartBehavior = DragStartBehavior.start,
      this.extendBody = false,
      this.extendBodyBehindAppBar = false,
      this.drawerScrimColor,
      this.drawerEdgeDragWidth,
      Key? key})
      : assert(twoPanesWidthBreakpoint != null && twoPanesWidthBreakpoint > 0),
        super(key: key);

  /// The app bar to show when the both the master and details pane are visible.
  /// If only one pane is visible, this the app bar that is shown when it's the master pane that is visible i.e. when on the [initialRoute] as the user has selected an item yet
  final PreferredSizeWidget appBar;

  /// The app bar to shown when only the details pane is visible i.e. when on the [detailsRoute] after the user has selected an item.
  final PreferredSizeWidget? detailsAppBar;

  /// The name of the initial route. When the instance of the [Navigator] associated with the [MasterDetails]
  final String initialRoute;

  /// The name of the details route. When trying to show specific content in the details pane, navigation must be
  /// done used named routes and be done in a manner similar to Uri-based navigation. For example, if
  /// `detailsRoute` is set to be `item`, navigation can be done as follows
  ///
  /// ```
  /// MasterDetailScaffold.of(context).detailsPaneNavigator.pushNamed(context, 'item?id=1');
  /// ```
  ///
  /// The route and query string parameters will be passed to the [onDetailsPaneRouteChanged] callback.
  final String detailsRoute;

  /// Creates the content to show in the master pane
  final WidgetBuilder masterPaneBuilder;

  /// Creates the content to show in the details pane
  final WidgetBuilder detailsPaneBuilder;

  /// The width of the master pane. The details pane will occur the remaining space
  final double masterPaneWidth;

  /// The minimum width at which both the master and details pane will be shown
  final double? twoPanesWidthBreakpoint;

  /// Creates the widget to show when both the master and details pane are visible but there aren't any details to show.
  /// If null, then defaults to showing a [Container].
  final WidgetBuilder? initialDetailsPaneBuilder;

  /// The button to display above the details pane and will only be shown when the [detailsPaneBuilder] is visible
  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  final bool extendBody;

  final bool extendBodyBehindAppBar;

  final List<Widget>? persistentFooterButtons;

  /// See [Scaffold.drawer]. Only shown when both panes are displayed or if only one pane is visible, it's the master pane that is shown
  final Widget? drawer;

  /// See [Scaffold.endDrawer]. Only shown when both panes are displayed or if only one pane is visible, it's the master pane that is shown
  final Widget? endDrawer;

  final Color? drawerScrimColor;

  final Color? backgroundColor;

  final Widget? bottomNavigationBar;

  final Widget? bottomSheet;

  final bool? resizeToAvoidBottomInset;

  final bool primary;

  final DragStartBehavior drawerDragStartBehavior;

  final double? drawerEdgeDragWidth;

  /// Callback that is involved when the details that need to be displayed change.
  /// The callback is triggered in the following conditions:
  ///
  /// - when the [initialRoute] is displayed
  /// - When the [detailsRoute] is displayed
  ///
  /// The route and query string parameters will be through the callback can then be used to update the state of the application.
  /// The information can be used to determine what content should be shown in the details pane.
  final DetailsPaneRouteChangedCallback? onDetailsPaneRouteChanged;

  /// Function that creates a modal route that can be used determine what the transition should be when navigation occurs.
  /// If left as null, then the [MaterialMasterDetailPageRoute] is used as a default
  final MasterDetailPageRouteBuilder? pageRouteBuilder;

  /// The state of the nearest instance of the [MasterDetailScaffold] widget.
  static MasterDetailScaffoldState? of(BuildContext context,
      {bool nullOk = false}) {
    final MasterDetailScaffoldState? result =
        context.findAncestorStateOfType<MasterDetailScaffoldState>();
    if (nullOk || result != null) return result;
    throw FlutterError(
        'MasterDetailScaffold.of() called with a context that does not contain a MasterDetailScaffold.');
  }

  @override
  MasterDetailScaffoldState createState() => MasterDetailScaffoldState();
}

class MasterDetailScaffoldState extends State<MasterDetailScaffold> {
  /// Whether both the master and detail panes are both being displayed
  bool get isDisplayingBothPanes =>
      LayoutHelper.showBothPanes(context, widget.twoPanesWidthBreakpoint!);

  /// The navigator widget that encloses the details pane.
  /// Use this change the route that determines that details of the item that needs to be shown
  NavigatorState? get detailsPaneNavigator => _navigatorKey.currentState;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final Navigator masterDetailNavigator = Navigator(
      key: _navigatorKey,
      initialRoute: widget.initialRoute,
      observers: [
        MasterDetailRouteObserver(
            initialRoute: widget.initialRoute,
            detailsRoute: widget.detailsRoute,
            onDetailsPaneRouteChanged: widget.onDetailsPaneRouteChanged)
      ],
      onGenerateRoute: (settings) {
        WidgetBuilder? builder;
        final Uri uri = Uri.parse(settings.name!);
        if (settings.name!.toLowerCase() == widget.initialRoute.toLowerCase()) {
          builder = (BuildContext context) => !LayoutHelper.showBothPanes(
                  context, widget.twoPanesWidthBreakpoint!)
              ? Scaffold(
                  appBar: null,
                  body: Builder(builder: widget.masterPaneBuilder),
                  persistentFooterButtons: widget.persistentFooterButtons,
                  drawer: widget.drawer,
                  endDrawer: widget.endDrawer,
                  bottomNavigationBar: widget.bottomNavigationBar,
                  bottomSheet: widget.bottomSheet,
                  backgroundColor: widget.backgroundColor,
                  resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                  primary: widget.primary,
                  drawerDragStartBehavior: widget.drawerDragStartBehavior,
                  extendBody: widget.extendBody,
                  drawerScrimColor: widget.drawerScrimColor,
                  drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
                )
              : widget.initialDetailsPaneBuilder == null
                  ? Container()
                  : Builder(builder: widget.initialDetailsPaneBuilder!);
        } else if (uri.path.toLowerCase() ==
            widget.detailsRoute.toLowerCase()) {
          final Builder detailsPane =
              Builder(builder: widget.detailsPaneBuilder);
          builder = (BuildContext context) => !LayoutHelper.showBothPanes(
                  context, widget.twoPanesWidthBreakpoint!)
              ? Scaffold(
                  appBar: widget.detailsAppBar,
                  body: detailsPane,
                  floatingActionButton: widget.floatingActionButton,
                  floatingActionButtonAnimator:
                      widget.floatingActionButtonAnimator,
                  floatingActionButtonLocation:
                      widget.floatingActionButtonLocation,
                  bottomNavigationBar: widget.bottomNavigationBar,
                  bottomSheet: widget.bottomSheet,
                  backgroundColor: widget.backgroundColor,
                  resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                  primary: widget.primary,
                  extendBody: widget.extendBody,
                )
              : detailsPane;
        }
        if (widget.pageRouteBuilder == null) {
          return MaterialMasterDetailPageRoute(
            builder: builder!,
            settings: settings,
          );
        }
        final pageRoute = widget.pageRouteBuilder!(builder, settings);
        return pageRoute;
      },
    );
    final Widget content = LayoutHelper.showBothPanes(
            context, widget.twoPanesWidthBreakpoint!)
        ? Scaffold(
            appBar: widget.appBar,
            body: Row(
              children: [
                Container(
                  child: Builder(
                    builder: widget.masterPaneBuilder,
                  ),
                  width: widget.masterPaneWidth,
                ),
                Expanded(
                  child: masterDetailNavigator,
                ),
              ],
            ),
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            persistentFooterButtons: widget.persistentFooterButtons,
            drawer: widget.drawer,
            endDrawer: widget.endDrawer,
            bottomNavigationBar: widget.bottomNavigationBar,
            bottomSheet: widget.bottomSheet,
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            primary: widget.primary,
            drawerDragStartBehavior: widget.drawerDragStartBehavior,
            extendBody: widget.extendBody,
            drawerScrimColor: widget.drawerScrimColor,
            drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
          )
        : masterDetailNavigator;

    return WillPopScope(
      child: content,
      onWillPop: () async {
        // currently needed for better handling of the back navigation on the web as it's otherwise not possible
        if (await _navigatorKey.currentState!.maybePop()) {
          return false;
        }
        return true;
      },
    );
  }
}
