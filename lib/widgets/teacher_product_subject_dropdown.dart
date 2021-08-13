import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/product_subject_dropdown.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class TeacherProductSubjectDropdown extends StatelessWidget {
  final int? selectedId;
  final ValueChanged<int> onChanged;
  final String? hintText;
  final bool allowingImagePortfolio;

  TeacherProductSubjectDropdown({
    required this.selectedId,
    required this.onChanged,
    this.hintText,
    this.allowingImagePortfolio = false,
  });

  @override
  Widget build(BuildContext context) {
    final authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
    return StreamBuilder<AuthenticationState>(
      stream: authenticationCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? authenticationCubit.initialState),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    final meResponseData = state.data;
    if (meResponseData == null) return Container();

    final subjectIds = _getSubjectIds(meResponseData);
    return ProductSubjectDropdown(
      selectedId: selectedId,
      showIds: subjectIds,
      onChanged: onChanged,
      allowingImagePortfolio: allowingImagePortfolio,
    );
  }

  List<int> _getSubjectIds(MeResponseData data) {
    final result = <int>[];

    for (final ts in data.teacherSubjects) {
      if (!ts.enabled) continue;
      result.add(ts.subjectId);
    }

    if (selectedId != null && !result.contains(selectedId)) {
      result.add(selectedId!);
    }

    return result;
  }
}
