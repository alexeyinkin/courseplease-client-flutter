import 'package:courseplease/blocs/current_product_subject.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/models/product_subject_with_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';

class ProductSubjectsBreadcrumbs extends StatelessWidget {
  // final List<ProductSubject> topLevelSubjects;
  // final ProductSubject selectedSubject;
  // final ValueChanged<int> onTap;
  //
  // ProductSubjectsBreadcrumbs({
  //   Key key,
  //   @required this.topLevelSubjects,
  //   @required this.selectedSubject,
  //   @required this.onTap,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final bloc = BlocProvider.of<CurrentProductSubjectBloc>(context);
    final bloc = context.watch<CurrentProductSubjectBloc>();

    return StreamBuilder<List<ProductSubjectWithStatus>>(
      stream: bloc.outBreadcrumbs,
      initialData: [],
      builder: (context, snapshot) {
        return Align(
          alignment: Alignment.topLeft,
          child: BreadCrumb(
            items: _getBreadcrumbArray(snapshot.data, bloc),
            divider: Icon(Icons.chevron_right, size: 36),
          ),
        );
      }
    );
    // if (widget.topLevelSubjects.isEmpty) {
    //   return Text('Loading...');
    // }
    //
    // if (widget.selectedSubject != null) {
    //   return Align(
    //     child: BreadCrumb(
    //       items: _getBreadcrumbArray(),
    //       divider: Icon(Icons.chevron_right, size: 36),
    //     ),
    //     alignment: Alignment.topLeft,
    //   );
    // }
    //
    // return Text('Loaded.');
  }

  // List<BreadCrumbItem> _getBreadcrumbArray() {
  //   final result = <BreadCrumbItem>[];
  //   var subject = widget.selectedSubject;


  List<BreadCrumbItem> _getBreadcrumbArray(List<ProductSubjectWithStatus> items, CurrentProductSubjectBloc bloc) {
    final result = <BreadCrumbItem>[];

    for (final item in items) {
      result.add(
        BreadCrumbItem(
          content: GestureDetector(
            child: _getBreadcrumbItemContent(item.subject, item.status),
            onTap: () => bloc.inCurrentId.add(item.subject.id),
          ),
        ),
      );
    }

    result.insert(0, BreadCrumbItem(content: Icon(Icons.home, size: 36)));
    return result;
  }

  Widget _getBreadcrumbItemContent(ProductSubject subject, ProductSubjectStatus status) {
    switch (status) {
      case ProductSubjectStatus.ancestor:
        return Text(
          subject.title,
          style: AppStyle.breadcrumbItem,
        );

      case ProductSubjectStatus.current:
        return Text(
          subject.title,
          style: AppStyle.breadcrumbItemActive,
        );

      case ProductSubjectStatus.descendant:
        return Opacity(
          opacity: .1,
          child: Text(
            subject.title,
            style: AppStyle.breadcrumbItem,
          ),
        );
    }
  }
}
