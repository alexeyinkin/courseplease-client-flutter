import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/breadcrumbs.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

class BreadcrumbsWidget<I, O extends WithIdTitleChildrenParent<I, O, O>> extends StatelessWidget {
  final TreePositionBloc<I, O> currentTreePositionBloc;

  BreadcrumbsWidget({
    required this.currentTreePositionBloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Breadcrumbs<O>>(
      stream: currentTreePositionBloc.outBreadcrumbs,
      builder: (context, snapshot) => _buildWithBreadcrumbsOrNull(snapshot.data),
    );
  }

  Widget _buildWithBreadcrumbsOrNull(Breadcrumbs<O>? breadcrumbs) {
    return (breadcrumbs == null)
        ? SmallCircularProgressIndicator(scale: .5)
        : _buildWithBreadcrumbs(breadcrumbs);
  }

  Widget _buildWithBreadcrumbs(Breadcrumbs<O> breadcrumbs) {
    final children = <Widget>[
      Icon(Icons.home, size: 40),
    ];

    for (final breadcrumb in breadcrumbs.list) {
      children.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildItemSeparator(breadcrumb),
            GestureDetector(
              child: _buildItemContent(breadcrumb),
              onTap: () => currentTreePositionBloc.setCurrentId(breadcrumb.item.id),
            ),
          ],
        ),
      );
    }

    return Wrap(
      children: children,
    );
  }

  Widget _buildItemContent(Breadcrumb<O> breadcrumb) {
    switch (breadcrumb.status) {
      case BreadcrumbStatus.ancestor:
        return Text(
          breadcrumb.item.title,
          style: AppStyle.breadcrumbItem,
        );

      case BreadcrumbStatus.current:
        return Text(
          breadcrumb.item.title,
          style: AppStyle.breadcrumbItemActive,
        );

      case BreadcrumbStatus.descendant:
        return Opacity(
          opacity: .1,
          child: Text(
            breadcrumb.item.title,
            style: AppStyle.breadcrumbItem,
          ),
        );
    }

    throw Exception('Unknown BreadcrumbStatus: ' + breadcrumb.status.toString());
  }

  Widget _buildItemSeparator(Breadcrumb<O> breadcrumb) {
    switch (breadcrumb.status) {
      case BreadcrumbStatus.ancestor:
      case BreadcrumbStatus.current:
        return _getRawItemSeparator();

      case BreadcrumbStatus.descendant:
        return Opacity(
          opacity: .1,
          child: _getRawItemSeparator(),
        );
    }

    throw Exception('Unknown BreadcrumbStatus: ' + breadcrumb.status.toString());
  }

  Widget _getRawItemSeparator() {
    return Container(
      child: Icon(
        Icons.chevron_right,
        size: 36,
      ),
    );
  }
}
