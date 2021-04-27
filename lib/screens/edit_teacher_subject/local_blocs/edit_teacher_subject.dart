import 'dart:async';

import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/money.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/models/product_variant_format.dart';
import 'package:courseplease/models/product_variant_format_with_price.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class EditTeacherSubjectCubit extends Bloc {
  final TeacherSubject _teacherSubjectClone;
  ProductSubject? _productSubject;
  bool _closeScreen = false;
  final _bodyTextEditingController = TextEditingController();

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );
  late final StreamSubscription _productSubjectsSubscription;

  final _outStateController = BehaviorSubject<EditTeacherSubjectState>();
  Stream<EditTeacherSubjectState> get outState => _outStateController.stream;

  late final EditTeacherSubjectState initialState;

  EditTeacherSubjectAction? _actionInProgress;

  static const formatIntNames = [
    ProductVariantFormatIntNameEnum.consultingTeachersPlace,
    ProductVariantFormatIntNameEnum.consultingStudentsPlace,
    ProductVariantFormatIntNameEnum.consultingOnline,
  ];

  EditTeacherSubjectCubit({
    required TeacherSubject teacherSubjectClone,
  }) :
      _teacherSubjectClone = teacherSubjectClone
  {
    _bodyTextEditingController.text = markdownToControllerText(teacherSubjectClone.body);
    initialState = EditTeacherSubjectState(
      teacherSubjectClone: teacherSubjectClone,
      productSubject: null,
      canSave: true,
      actionInProgress: null,
      closeScreen: false,
      bodyTextEditingController: _bodyTextEditingController,
    );

    _ensureHaveAllFormats();
    _initProductSubject();
    _pushOutput();
  }

  void _ensureHaveAllFormats() {
    final formats = Map<String, ProductVariantFormatWithPrice>();

    for (final format in _teacherSubjectClone.productVariantFormats) {
      formats[format.intName] = format;
    }

    for (final formatIntName in formatIntNames) {
      if (!formats.containsKey(formatIntName)) {
        final format = ProductVariantFormatWithPrice(
          productVariantId: null,
          intName:          formatIntName,
          title:            tr('models.ProductVariantFormat.' + formatIntName),
          enabled:          false,
          minPrice:         Money.zero(),
          maxPrice:         Money.zero(),
        );
        _teacherSubjectClone.productVariantFormats.add(format);
      }
    }
  }

  void _initProductSubject() {
    _productSubjectsSubscription = _productSubjectsByIdsBloc.outState.listen(_onProductSubjectChange);
    _productSubjectsByIdsBloc.setCurrentIds([_teacherSubjectClone.subjectId]);
  }

  void _onProductSubjectChange(ModelListByIdsState<ProductSubject> state) {
    if (state.objects.length != 1) return;
    _productSubject = state.objects[0];
    _pushOutput();
  }

  void setEnabled(bool value) {
    _teacherSubjectClone.enabled = value;
    _pushOutput();
  }

  void save() async {
    _actionInProgress = EditTeacherSubjectAction.save;
    _pushOutput();

    await _authenticationCubit
        .saveConsultingProduct(_createRequest())
        .then(_onSaveSuccess);

    _actionInProgress = null;
    _pushOutput();
  }

  void _onSaveSuccess(_) {
    _closeScreen = true;
  }

  SaveConsultingProductRequest _createRequest() {
    return SaveConsultingProductRequest(
      subjectId: _teacherSubjectClone.subjectId,
      enabled: _teacherSubjectClone.enabled,
      body: controllerTextToMarkdown(_bodyTextEditingController.text),
      productVariants: _createProductVariantRequests(),
    );
  }

  List<SaveConsultingProductVariantRequest> _createProductVariantRequests() {
    final result = <SaveConsultingProductVariantRequest>[];

    for (final format in _teacherSubjectClone.productVariantFormats) {
      if (format.maxPrice != null && format.maxPrice!.isPositive()) {
        result.add(_createProductVariantRequest(format));
      }
    }
    return result;
  }

  SaveConsultingProductVariantRequest _createProductVariantRequest(ProductVariantFormatWithPrice format) {
    return SaveConsultingProductVariantRequest(
      formatIntName: format.intName,
      enabled: format.enabled,
      price: format.maxPrice!.map,
    );
  }

  void _pushOutput() {
    final state = _createState();
    _outStateController.sink.add(state);
  }

  EditTeacherSubjectState _createState() {
    return EditTeacherSubjectState(
      teacherSubjectClone: _teacherSubjectClone,
      productSubject: _productSubject,
      canSave: _actionInProgress == null,
      actionInProgress: _actionInProgress,
      closeScreen: _closeScreen,
      bodyTextEditingController: _bodyTextEditingController,
    );
  }

  @override
  void dispose() {
    _productSubjectsSubscription.cancel();
    _productSubjectsByIdsBloc.dispose();
    _outStateController.close();
  }
}

class EditTeacherSubjectState {
  final TeacherSubject teacherSubjectClone;
  final ProductSubject? productSubject;
  final bool canSave;
  final EditTeacherSubjectAction? actionInProgress;
  final bool closeScreen;
  final TextEditingController bodyTextEditingController;

  EditTeacherSubjectState({
    required this.teacherSubjectClone,
    required this.productSubject,
    required this.canSave,
    required this.actionInProgress,
    required this.closeScreen,
    required this.bodyTextEditingController,
  });
}

enum EditTeacherSubjectAction {
  save,
}
