import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/models/shop/line_item.dart';
import 'package:courseplease/widgets/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LineItemWidget extends StatefulWidget {
  final LineItem lineItem;

  LineItemWidget({
    required this.lineItem,
  });

  @override
  _LineItemWidgetState createState() => _LineItemWidgetState();
}

class _LineItemWidgetState extends State<LineItemWidget> {
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  @override
  void initState() {
    super.initState();
    _productSubjectsByIdsBloc.setCurrentIds([widget.lineItem.productSubjectId]);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: UserpicAndNameWidget(user: widget.lineItem.user)),
          Container(width: 30),
          Text(widget.lineItem.format.maxPrice.toString()),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getSubjectLine(),
          _getFormatLine(),
        ],
      ),
    );
  }

  Widget _getSubjectLine() {
    return StreamBuilder<ModelListByIdsState<int, ProductSubject>>(
      stream: _productSubjectsByIdsBloc.outState,
      builder: (context, snapshot) => _buildSubjectLineWithState(snapshot.data),
    );
  }

  Widget _buildSubjectLineWithState(ModelListByIdsState<int, ProductSubject>? state) {
    if (state == null || state.objects.isEmpty) return Container();
    final ps = state.objects.first;

    return Text(
      tr('OrderScreen.oneHourLessonIn', namedArgs: {'subject': ps.title}),
    );
  }

  Widget _getFormatLine() {
    return Text(widget.lineItem.format.title);
  }
}
