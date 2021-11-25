import 'package:collection/collection.dart';
import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/editors/location.dart';
import 'package:courseplease/blocs/editors/price_range.dart';
import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/product_variant_format.dart';
import 'package:courseplease/models/shop/enum/currency_alpha3.dart';
import 'package:courseplease/screens/filter/local_blocs/filter.dart';
import 'package:courseplease/widgets/language_list_editor.dart';
import 'package:get_it/get_it.dart';
import 'package:model_editors/model_editors.dart';
import 'package:rxdart/rxdart.dart';

class GalleryImageFilterDialogCubit extends AbstractFilterScreenContentCubit<GalleryImageFilter> {
  final _statesController = BehaviorSubject<GalleryImageFilterDialogCubitState>();
  Stream<GalleryImageFilterDialogCubitState> get states => _statesController.stream;
  late final GalleryImageFilterDialogCubitState initialState;

  final _formatsController = CheckboxGroupEditingController<String>();
  final _locationController = LocationEditorController(geocode: false);
  final PriceRangeEditorController _priceRangeController;
  final _langsController = LanguageListEditorController();

  GalleryImageFilterDialogCubit() :
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

  GalleryImageFilterDialogCubitState _createState() {
    return GalleryImageFilterDialogCubitState(
      canClear:             true, // TODO
      formatsController:    _formatsController,
      locationController:   _locationController,
      priceRangeController: _priceRangeController,
      langsController:      _langsController,
    );
  }

  void setFilter(GalleryImageFilter filter) {
    _formatsController.value = filter.formats.isEmpty ? ProductVariantFormatIntNameEnum.allForFilter : filter.formats;
    _locationController.value = filter.location;
    _priceRangeController.value = filter.price;
    _langsController.setIds(filter.langs);

    _pushOutput();
  }

  GalleryImageFilter getFilter() {
    final formats = _formatsController.value;

    return GalleryImageFilter(
      subjectId:  null,
      purposeId:  ImageAlbumPurpose.portfolio,
      formats:    ListEquality().equals(formats, ProductVariantFormatIntNameEnum.allForFilter) ? [] : formats,
      location:   _locationController.value,
      price:      _priceRangeController.value,
      langs:      _langsController.getIds(),
    );
  }

  @override
  void clear() {
    _formatsController.value = ProductVariantFormatIntNameEnum.allForFilter;
    _locationController.value = null;
    _priceRangeController.value = null;
    _langsController.value = [];
    _pushOutput();
  }

  @override
  void dispose() {
    _statesController.close();
  }
}

class GalleryImageFilterDialogCubitState {
  final bool canClear;
  final CheckboxGroupEditingController<String> formatsController;
  final LocationEditorController locationController;
  final PriceRangeEditorController priceRangeController;
  final LanguageListEditorController langsController;

  GalleryImageFilterDialogCubitState({
    required this.canClear,
    required this.formatsController,
    required this.locationController,
    required this.priceRangeController,
    required this.langsController,
  });
}
