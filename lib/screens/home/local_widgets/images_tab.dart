import 'package:courseplease/blocs/current_product_subject.dart';
import 'package:flutter/material.dart';
import '../../../widgets/image_grid.dart';
import '../../../models/filters/image.dart';
import 'package:provider/provider.dart';

class ImagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CurrentProductSubjectBloc>();

    return Center(
      child: StreamBuilder<int>(
        stream: bloc.outCurrentId,
        builder: (context, snapshot) {
          final filter = ViewImageFilter(subjectId: snapshot.data);
          return _buildWithFilter(filter);
        }
      ),
    );
  }

  Widget _buildWithFilter(ViewImageFilter filter) {
    return ViewImageGrid(
      filter: filter,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
    );
  }
}
