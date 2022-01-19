import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/models/teacher.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/teacher/configurations.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';

class TeacherBloc extends AppPageStatefulBloc<TeacherBlocState> {
  final int teacherId;
  Teacher? _teacher;
  RequestStatus _requestStatus = RequestStatus.notTried;
  int? _selectedSubjectId;
  List<ProductSubject>? _subjects;

  final _teacherByIdBloc = ModelByIdBloc<int, Teacher>(
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Teacher, TeacherRepository>(),
  );
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  final initialState = TeacherBlocState(
    teacher: null,
    selectedSubjectId: null,
    subjects: [],
    selectedSubject: null,
    selectedTeacherSubject: null,
    requestStatus: RequestStatus.notTried,
  );

  TeacherBloc({
    required this.teacherId,
    required int? selectedSubjectId,
  }) {
    _teacherByIdBloc.setCurrentId(teacherId);
    _selectedSubjectId = selectedSubjectId;

    _teacherByIdBloc.outState.listen(_onTeacherChanged);
    _productSubjectsByIdsBloc.outState.listen(_onProductSubjectsChanged);
  }

  void _onTeacherChanged(ModelByIdState<int, Teacher> state) {
    _teacher = state.object;
    _requestStatus = state.requestStatus;

    if (_teacher != null) {
      _productSubjectsByIdsBloc.setCurrentIds(_teacher!.subjectIds);
      _fixSelectedSubjectId();
    }

    emitState();
  }

  void _onProductSubjectsChanged(ModelListByIdsState<int, ProductSubject> state) {
    _subjects = state.objects;
    emitState();
  }

  void _fixSelectedSubjectId() {
    if (_teacher == null) return;

    if (_selectedSubjectId == null || !_teacher!.subjectIds.contains(_selectedSubjectId)) {
      _selectedSubjectId = _teacher!.subjectIds.isEmpty ? null : _teacher!.subjectIds[0];
    }
  }

  @override
  TeacherBlocState createState() {
    return TeacherBlocState(
      teacher: _teacher,
      selectedSubjectId: _selectedSubjectId,
      subjects: _subjects ?? [],
      selectedSubject: WithId.getById(_subjects ?? [], _selectedSubjectId),
      selectedTeacherSubject: _selectedSubjectId == null ? null : _teacher?.getTeacherSubjectById(_selectedSubjectId!),
      requestStatus: _requestStatus,
    );
  }

  @override
  MyPageConfiguration? getConfiguration() => TeacherConfiguration(teacherId: teacherId);

  void setSubjectId(int id) {
    _selectedSubjectId = id;
    _fixSelectedSubjectId();
    emitState();
  }

  @override
  void dispose() {
    _teacherByIdBloc.dispose();
    _productSubjectsByIdsBloc.dispose();
    super.dispose();
  }
}

class TeacherBlocState {
  final Teacher? teacher;
  final int? selectedSubjectId;
  final List<ProductSubject> subjects;
  final ProductSubject? selectedSubject;
  final TeacherSubject? selectedTeacherSubject;
  final RequestStatus requestStatus;

  TeacherBlocState({
    required this.teacher,
    required this.selectedSubjectId,
    required this.subjects,
    required this.selectedSubject,
    required this.selectedTeacherSubject,
    required this.requestStatus,
  });
}
