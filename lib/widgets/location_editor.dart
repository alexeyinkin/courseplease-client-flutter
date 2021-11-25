import 'dart:async';

import 'package:courseplease/blocs/editors/location.dart';
import 'package:courseplease/models/enum/location_privacy.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'city_name_autocomplete.dart';
import 'geo/country_dropdown.dart';

class LocationEditorWidget extends StatefulWidget {
  final LocationEditorController controller;
  final bool showStreetAddress;
  final bool showMap;
  final bool showPrivacy;

  LocationEditorWidget({
    required this.controller,
    required this.showStreetAddress,
    required this.showMap,
    required this.showPrivacy,
  });

  @override
  _LocationEditorWidgetState createState() => _LocationEditorWidgetState();
}

class _LocationEditorWidgetState extends State<LocationEditorWidget> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();

  static const _topPadding = EdgeInsets.only(top: 10);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  void _onChanged() async {
    final mapController = await _mapControllerCompleter.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(_getCameraPosition()));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, value, child) => _buildOnChange(),
    );
  }

  Widget _buildOnChange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountryDropdown(
          controller: widget.controller.countryController,
        ),
        SmallPadding(),
        CityNameAutocomplete(
          countryCode: widget.controller.countryController.value?.id,
          controller: widget.controller.cityNameController,
        ),
        _buildStreetAddressIfNeed(),
        _buildMapIfNeed(),
        _buildPrivacyControlIfNeed(),
      ],
    );
  }

  Widget _buildStreetAddressIfNeed() {
    if (!widget.showStreetAddress) return Container();

    return Container(
      padding: _topPadding,
      child: AppTextField(
        controller: widget.controller.streetAddressController,
        labelText: tr('LocationEditorWidget.streetAddress'),
      ),
    );
  }

  Widget _buildMapIfNeed() {
    if (!widget.showMap) return Container();

    // TODO: Dark mode.
    // TODO: Handle theme changes:
    //       https://medium.com/swlh/switch-to-dark-mode-in-real-time-with-flutter-and-google-maps-f0f080cd72e9
    return Container(
      padding: _topPadding,
      height: 200,
      child: GoogleMap(
        initialCameraPosition: _getCameraPosition(),
        onMapCreated: (GoogleMapController controller) {
          _mapControllerCompleter.complete(controller);
        },
        markers: _getMarkers(),
      ),
    );
  }

  CameraPosition _getCameraPosition() {
    return CameraPosition(
      target: _getLatLng(),
      zoom: _getZoom(),
    );
  }

  double _getZoom() {
    if (!_isValid()) return 0;

    if (widget.controller.streetAddressController.text != '') return 15;
    if (widget.controller.cityNameController.value != null) return 6;
    return 2;
  }

  bool _isValid() {
    return ((widget.controller.latitude ?? 0) != 0 || (widget.controller.longitude ?? 0) != 0);
  }

  Set<Marker> _getMarkers() {
    if (!_isValid()) return Set.of([]);

    return Set.of([
      Marker(
        markerId: MarkerId('center'),
        position: _getLatLng(),
      ),
    ]);
  }

  LatLng _getLatLng() {
    return LatLng(widget.controller.latitude ?? 0, widget.controller.longitude ?? 0);
  }

  Widget _buildPrivacyControlIfNeed() {
    if (!widget.showPrivacy) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallPadding(),
        Text(tr('LocationEditorWidget.showTo')),
        RadioListTile(
          value: LocationPrivacyEnum.exactVisible,
          groupValue: widget.controller.privacy,
          onChanged: widget.controller.setPrivacy,
          title: Text(tr('LocationEditorWidget.privacy.' + LocationPrivacyEnum.exactVisible)),
          subtitle: Text(tr('LocationEditorWidget.bestFor.' + LocationPrivacyEnum.exactVisible)),
        ),
        RadioListTile(
          value: LocationPrivacyEnum.fuzzyVisible,
          groupValue: widget.controller.privacy,
          onChanged: widget.controller.setPrivacy,
          title: Text(tr('LocationEditorWidget.privacy.' + LocationPrivacyEnum.fuzzyVisible)),
          subtitle: Text(tr('LocationEditorWidget.bestFor.' + LocationPrivacyEnum.fuzzyVisible)),
        ),
        RadioListTile(
          value: LocationPrivacyEnum.hidden,
          groupValue: widget.controller.privacy,
          onChanged: widget.controller.setPrivacy,
          title: Text(tr('LocationEditorWidget.privacy.' + LocationPrivacyEnum.hidden)),
          subtitle: Text(tr('LocationEditorWidget.bestFor.' + LocationPrivacyEnum.hidden)),
        ),
      ],
    );
  }
}
