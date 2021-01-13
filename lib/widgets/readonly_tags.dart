import 'package:flutter/material.dart';

class ReadonlyTagsWidget extends StatelessWidget {
  final List<String> tags;
  final int selectedIndex;

  ReadonlyTagsWidget({
    @required this.tags,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (var i = 0; i < tags.length; i++) {
      children.add(
        _ReadonlyTagWidget(
          tag: tags[i],
          selected: i == selectedIndex,
        ),
      );
    }

    return Wrap(
      children: children,
      spacing: 5,
    );
  }
}

class _ReadonlyTagWidget extends StatelessWidget {
  final String tag;
  final bool selected;

  _ReadonlyTagWidget({
    @required this.tag,
    @required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Color(0x40808080),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Opacity(
        opacity: .5,
        child: Text(tag),
      ),
    );
  }
}
