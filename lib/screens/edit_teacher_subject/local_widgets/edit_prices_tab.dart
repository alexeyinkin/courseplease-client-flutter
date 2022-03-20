import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/product_variant_format_with_price.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/screens/edit_teacher_subject/bloc.dart';
import 'package:courseplease/screens/edit_teacher_subject/local_widgets/edit_format_price.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EditPricesTabWidget extends StatelessWidget {
  final TeacherSubject teacherSubjectClone;
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  EditPricesTabWidget({
    required this.teacherSubjectClone,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticationState>(
      stream: _authenticationCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _authenticationCubit.initialState),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    if (state.data == null) return Container();

    return ListView(
      children: _createChildren(state.data!),
    );
  }

  List<Widget> _createChildren(MeResponseData meResponseData) {
    final children = <Widget>[];
    final formats = Map<String, ProductVariantFormatWithPrice>();

    for (final format in teacherSubjectClone.productVariantFormats) {
      formats[format.intName] = format;
    }

    for (final formatIntName in EditTeacherSubjectBloc.formatIntNames) {
      children.add(
        EditFormatPriceWidget(
          // Not checking for null because all possible formats are here,
          // filled by [EditTeacherSubjectCubit._ensureHaveAllFormats]
          productVariantFormatWithPrice: formats[formatIntName]!,
          curs: meResponseData.allowedCurs,
        ),
      );
    }

    return alternateWidgetListWith(children, SmallPadding());
  }
}
