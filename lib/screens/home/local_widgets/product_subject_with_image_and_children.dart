import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

class ProductSubjectWithImageAndChildren extends StatelessWidget {
  final ProductSubject subject;
  final ValueChanged<int>? onChanged;

  ProductSubjectWithImageAndChildren({
    required this.subject,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getCover(),
        SmallPadding(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getTitle(),
              SmallPadding(),
              Opacity(
                opacity: .5,
                child: _getChildren(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getCover() {
    return Container(
      width: 100,
      height: 100,
      child: _getCoverContent(),
    );
  }

  Widget _getCoverContent() {
    if (subject.coverUrls.isEmpty) return Container();

    return CachedNetworkImage(
      imageUrl: subject.coverUrls.first,
      fadeInDuration: Duration(),
      fit: BoxFit.cover,
    );
  }

  Widget _getTitle() {
    return GestureDetector(
      onTap: () => _onTap(subject.id),
      child: Text(
        subject.title,
        style: AppStyle.h4,
      ),
    );
  }

  Widget _getChildren() {
    final children = <Widget>[];

    for (final childSubject in subject.children) {
      children.add(
        GestureDetector(
          onTap: () => _onTap(childSubject.id),
          child: Text(childSubject.title),
        ),
      );
    }

    return Wrap(
      children: children,
      spacing: 10,
    );
  }

  void _onTap(int subjectId) {
    if (onChanged != null) onChanged!(subjectId);
  }
}
