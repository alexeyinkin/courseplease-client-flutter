import 'dart:async';
import 'dart:convert';

import 'package:courseplease/blocs/editors/with_id_title.dart';
import 'package:courseplease/models/enum/location_privacy.dart';
import 'package:courseplease/models/geo/city_name.dart';
import 'package:courseplease/models/geo/country.dart';
import 'package:courseplease/models/location.dart';
import 'package:courseplease/repositories/country.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../model_by_id.dart';
import 'abstract.dart';

// TODO: Cut repeated fireChange() when multiple fields change together.
class LocationEditorController extends AbstractValueEditorController<Location> {
  final bool geocode;
  double? _latitude;
  double? _longitude;
  final countryController = WithIdTitleEditorController<String, Country>();
  final cityNameController = WithIdTitleEditorController<int, CityName>();
  final streetAddressController = TextEditingController();
  String _privacy = LocationPrivacyEnum.fuzzyVisible;

  final _apiClient = GetIt.instance.get<ApiClient>();
  final _countryByIdBloc = ModelByIdBloc<String, Country>(
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<String, Country, CountryRepository>(),
  );
  Timer? _streetAddressEditingDebounce;
  static const _streetAddressDebounceDuration = Duration(milliseconds: 500);

  // TODO: Cache more than one.
  String? _lastGeocoded;

  bool _countrySet = false;
  bool _cityNameSet = false;

  LocationEditorController({
    required this.geocode,
  }) {
    _countryByIdBloc.outState.listen(_onCountryLoaded);
    countryController.addListener(_onCountryChanged);
    cityNameController.addListener(_onCityNameChanged);
    streetAddressController.addListener(_onStreetAddressChanged);
  }

  void _onCountryLoaded(ModelByIdState<String, Country> state) {
    countryController.setValue(state.object);
  }

  @override
  Location? getValue() {
    final country = countryController.getValue();
    if (country == null) return null;

    final cityName = cityNameController.getValue();

    return Location(
      latitude: _latitude ?? 0,
      longitude: _longitude ?? 0,
      countryCode: country.id,
      cityId: cityName?.cityId,
      cityTitle: cityName?.title ?? '',
      streetAddress: streetAddressController.text,
      publicLine: '',
      privacy: _privacy,
      subwayStations: [],
    );
  }

  @override
  void setValue(Location? location) {
    if (location == null) {
      _setNull();
    } else {
      _setNotNull(location);
    }
  }

  void _setNull() {
    _latitude = null;
    _longitude = null;
    countryController.setValue(null);
    cityNameController.setValue(null);
    streetAddressController.text = '';
    _privacy = LocationPrivacyEnum.fuzzyVisible;
    fireChange();
  }

  void _setNotNull(Location location) {
    _latitude = location.latitude;
    _longitude = location.longitude;

    if (location.countryCode == '') {
      countryController.setValue(null);
    } else {
      _setCountryCode(location.countryCode);
    }

    if (location.cityId == null) {
      cityNameController.setValue(null);
    } else {
      cityNameController.setValue(
        CityName.fromCityIdAndTitle(location.cityId!, location.cityTitle)
      );
    }

    streetAddressController.text = location.streetAddress;
    _privacy = location.privacy;

    fireChange();
  }

  void _setCountryCode(String countryCode) {
    _countryByIdBloc.setCurrentId(countryCode);
  }

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  void _onCountryChanged() {
    if (_countrySet) {
      cityNameController.setValue(null);
      streetAddressController.text = '';
    }
    if (countryController.getValue() != null) {
      _countrySet = true;
    }

    _geoCodeIfNeed();
    fireChange();
  }

  void _onCityNameChanged() {
    if (_cityNameSet) {
      streetAddressController.text = '';
    }
    if (cityNameController.getValue() != null) {
      _cityNameSet = true;
    }

    _geoCodeIfNeed();
    fireChange();
  }

  void _onStreetAddressChanged() {
    if (_streetAddressEditingDebounce?.isActive ?? false) _streetAddressEditingDebounce!.cancel();
    _streetAddressEditingDebounce = Timer(_streetAddressDebounceDuration, () {
      _geoCodeIfNeed();
      fireChange();
    });
  }

  String get privacy => _privacy;

  void setPrivacy(String? privacy) {
    if (privacy == null || privacy == _privacy) return;
    _privacy = privacy;
    fireChange();
  }

  void _geoCodeIfNeed() {
    if (!geocode) return;
    _geoCode();
  }

  void _geoCode() async {
    final country = countryController.getValue();
    if (country == null) return;

    final cityName = cityNameController.getValue();
    final request = GeoCodeRequest(
      countryTitle: country.title,
      cityTitle: cityName?.title,
      streetAddress: streetAddressController.text,
    );

    final json = jsonEncode(request);
    if (json == _lastGeocoded) return;
    _lastGeocoded = json;

    final response = await _apiClient.geoCode(request);

    if (response.latitude != _latitude || response.longitude != _longitude) {
      _latitude = response.latitude;
      _longitude = response.longitude;
      fireChange();
    }
  }
}
