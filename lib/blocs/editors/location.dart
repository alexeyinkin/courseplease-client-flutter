import 'dart:async';

import 'package:courseplease/blocs/editors/with_id_title.dart';
import 'package:courseplease/models/enum/location_privacy.dart';
import 'package:courseplease/models/geo/city_name.dart';
import 'package:courseplease/models/location.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class LocationEditorController extends AbstractValueEditorController<Location> {
  double? _latitude;
  double? _longitude;
  String? _countryCode;
  final cityNameController = WithIdTitleEditorController<int, CityName>();
  final streetAddressController = TextEditingController();
  String _privacy = LocationPrivacyEnum.fuzzyVisible;

  final _apiClient = GetIt.instance.get<ApiClient>();
  Timer? _streetAddressEditingDebounce;
  static const _streetAddressDebounceDuration = Duration(milliseconds: 500);

  LocationEditorController() {
    cityNameController.addListener(_onCityChanged);
    streetAddressController.addListener(_onStreetAddressChanged);
  }

  @override
  Location? getValue() {
    if (_countryCode == null) return null;

    final cityName = cityNameController.getValue();

    return Location(
      latitude: _latitude ?? 0,
      longitude: _longitude ?? 0,
      countryCode: _countryCode!,
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
    fireChange();
  }

  void _setNull() {
    _latitude = null;
    _longitude = null;
    _countryCode = null;
    cityNameController.setValue(null);
    streetAddressController.text = '';
    _privacy = LocationPrivacyEnum.fuzzyVisible;
  }

  void _setNotNull(Location location) {
    _latitude = location.latitude;
    _longitude = location.longitude;
    _countryCode = location.countryCode;

    if (location.cityId == null) {
      cityNameController.setValue(null);
    } else {
      cityNameController.setValue(
        CityName.fromCityIdAndTitle(location.cityId!, location.cityTitle)
      );
    }

    streetAddressController.text = location.streetAddress;
    _privacy = location.privacy;
  }

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  String? get countryCode => _countryCode;

  void setCountryCode(String? countryCode) {
    if (countryCode == _countryCode) return;
    _countryCode = countryCode;
    cityNameController.setValue(null);
    streetAddressController.text = '';
    _geoCode();
    fireChange();
  }

  void _onCityChanged() {
    _geoCode();
    fireChange();
  }

  void _onStreetAddressChanged() {
    if (_streetAddressEditingDebounce?.isActive ?? false) _streetAddressEditingDebounce!.cancel();
    _streetAddressEditingDebounce = Timer(_streetAddressDebounceDuration, () {
      _geoCode();
    });
  }

  String get privacy => _privacy;

  void setPrivacy(String? privacy) {
    if (privacy == null || privacy == _privacy) return;
    _privacy = privacy;
    fireChange();
  }

  void _geoCode() async {
    if (_countryCode == null) return;

    final cityName = cityNameController.getValue();
    if (cityName == null) return;

    final request = GeoCodeRequest(
      countryCode: _countryCode!,
      cityTitle: cityName.title,
      streetAddress: streetAddressController.text,
    );

    final response = await _apiClient.geoCode(request);

    if (response.latitude != _latitude || response.longitude != _longitude) {
      _latitude = response.latitude;
      _longitude = response.longitude;
      fireChange();
    }
  }
}
