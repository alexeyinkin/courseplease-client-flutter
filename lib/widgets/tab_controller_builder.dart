import 'package:flutter/material.dart';

class TabControllerBuilder extends StatefulWidget {
  final IndexedWidgetBuilder builder;
  final TabController? controller;

  TabControllerBuilder({
    required this.builder,
    this.controller,
  });

  @override
  _TabControllerBuilderState createState() => _TabControllerBuilderState();
}

class _TabControllerBuilderState extends State<TabControllerBuilder> {
  TabController? _controller;

  // From TabBarView.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
  }

  // From TabBarView.
  @override
  void didUpdateWidget(TabControllerBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onChanged);
    super.dispose();
  }

  // From TabBarView.
  void _updateTabController() {
    final TabController? newController = widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'TabController using the "controller" property, or you must ensure that there '
          'is a DefaultTabController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller)
      return;

    _controller?.removeListener(_onChanged);
    _controller = newController;
    _controller!.addListener(_onChanged);
  }

  void _onChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller!.index);
  }
}
