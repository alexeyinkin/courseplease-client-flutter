import 'dart:async';

import 'package:courseplease/blocs/editors/location.dart';
import 'package:courseplease/models/enum/location_privacy.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'city_name_autocomplete.dart';
import 'geo/country_dropdown.dart';

class LocationEditorWidget extends StatefulWidget {
  final LocationEditorController controller;

  LocationEditorWidget({
    required this.controller,
  });

  @override
  _LocationEditorWidgetState createState() => _LocationEditorWidgetState();
}

class _LocationEditorWidgetState extends State<LocationEditorWidget> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  late final StreamSubscription _changesSubscription;

  @override
  void initState() {
    super.initState();
    _changesSubscription = widget.controller.changes.listen(_onChanged);
  }

  void _onChanged(_) async {
    final mapController = await _mapControllerCompleter.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(_getCameraPosition()));
  }

  @override
  void dispose() {
    _changesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: widget.controller.changes,
      builder: (context, snapshot) => _buildOnChange(),
    );
  }

  Widget _buildOnChange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountryDropdown(
          countryCode: widget.controller.countryCode,
          onChanged: widget.controller.setCountryCode,
        ),
        SmallPadding(),
        CityNameAutocomplete(
          countryCode: widget.controller.countryCode,
          controller: widget.controller.cityNameController,
        ),
        SmallPadding(),
        AppTextField(
          controller: widget.controller.streetAddressController,
          labelText: tr('LocationEditorWidget.streetAddress'),
        ),
        SmallPadding(),
        _buildMap(),
        SmallPadding(),
        _buildPrivacyControl(),
      ],
    );
  }

  Widget _buildMap() {
    // TODO: Dark mode.
    // TODO: Handle theme changes:
    //       https://medium.com/swlh/switch-to-dark-mode-in-real-time-with-flutter-and-google-maps-f0f080cd72e9
    return Container(
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
    return _isValid() ? 15 : 0;
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

  Widget _buildPrivacyControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
