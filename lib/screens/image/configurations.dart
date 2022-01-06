import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/models/interfaces/with_homogenous_parent_intname.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class ImageConfiguration extends AppConfiguration {
  final GalleryImageFilter filter;
  final ProductSubject productSubject;
  final int id;

  ImageConfiguration({
    required this.filter,
    required this.productSubject,
    required this.id,
  });

  @override
  RouteInformation restoreRouteInformation() {
    final params = filter.toJsonWithoutSubjectAndPurpose().map((key, value) => MapEntry(key, value.toString()));

    final uri = Uri(
      path: '/explore/${productSubject.slashedPath}/images/$id/comments',
      queryParameters: params.isEmpty ? null : params,
    );

    return RouteInformation(
      location: uri.toString(),
    );
  }
}
