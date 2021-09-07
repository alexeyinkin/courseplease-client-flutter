import 'package:collection/collection.dart';
import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/editors/checkbox_group.dart';
import 'package:courseplease/blocs/editors/location.dart';
import 'package:courseplease/blocs/editors/price_range.dart';
import 'package:courseplease/models/filters/teacher.dart';
import 'package:courseplease/models/product_variant_format.dart';
import 'package:courseplease/models/shop/enum/currency_alpha3.dart';
import 'package:courseplease/screens/filter/local_blocs/filter.dart';
import 'package:courseplease/widgets/language_list_editor.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class TeacherFilterDialogCubit extends AbstractFilterScreenContentCubit<TeacherFilter> {
  final _statesController = BehaviorSubject<TeacherFilterDialogCubitState>();
  Stream<TeacherFilterDialogCubitState> get states => _statesController.stream;
  late final TeacherFilterDialogCubitState initialState;

  final _formatsController = CheckboxGroupEditorController();
  final _locationController = LocationEditorController();
  final PriceRangeEditorController _priceRangeController;
  final _langsController = LanguageListEditorController();

  TeacherFilterDialogCubit() :
      _priceRangeController = PriceRangeEditorController(cur: _getCur()) // TODO: Listen for changes in AuthenticationBloc.
  {
    initialState = _createState();
  }

  // TODO: Extract
  static String _getCur() {
    final meResponseData = GetIt.instance.get<AuthenticationBloc>().currentState.data;
    if (meResponseData == null) return CurrencyAlpha3Enum.USD;
    return meResponseData.allowedCurs.firstOrNull ?? CurrencyAlpha3Enum.USD;
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  TeacherFilterDialogCubitState _createState() {
    return TeacherFilterDialogCubitState(
      canClear:             true, // TODO
      formatsController:    _formatsController,
      locationController:   _locationController,
      priceRangeController: _priceRangeController,
      langsController:      _langsController,
    );
  }

  void setFilter(TeacherFilter filter) {
    _formatsController.setValue(filter.formats.isEmpty ? ProductVariantFormatIntNameEnum.allForFilter : filter.formats);
    _locationController.setValue(filter.location);
    _priceRangeController.setValue(filter.price);
    _langsController.setIds(filter.langs);

    _pushOutput();
  }

  TeacherFilter getFilter() {
    final formats = _formatsController.getValue();

    return TeacherFilter(
      subjectId:  null,
      formats:    ListEquality().equals(formats, ProductVariantFormatIntNameEnum.allForFilter) ? [] : formats,
      location:   _locationController.getValue(),
      price:      _priceRangeController.getValue(),
      langs:      _langsController.getIds(),
    );
  }

  @override
  void clear() {
    _formatsController.setValue(ProductVariantFormatIntNameEnum.allForFilter);
    _locationController.setValue(null);
    _priceRangeController.setValue(null);
    _langsController.setValue([]);
    _pushOutput();
  }

  @override
  void dispose() {
    _statesController.close();
  }
}

class TeacherFilterDialogCubitState {
  final bool canClear;
  final CheckboxGroupEditorController formatsController;
  final LocationEditorController locationController;
  final PriceRangeEditorController priceRangeController;
  final LanguageListEditorController langsController;

  TeacherFilterDialogCubitState({
    required this.canClear,
    required this.formatsController,
    required this.locationController,
    required this.priceRangeController,
    required this.langsController,
  });
}
