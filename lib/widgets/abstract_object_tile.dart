import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef void TileCallback<I, O extends WithId<I>>(O object, int index);

typedef T TileFactory<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  T extends AbstractObjectTile<I, O, F>
>({
  @required O object,
  @required int index,
  @required VoidCallback onTap,
  @required bool selected,
  @required ValueChanged<bool> onSelected,
});

class AbstractObjectTile<I, O extends WithId<I>, F extends AbstractFilter> extends StatefulWidget {
  final O object;
  final F filter;
  final int index;
  final VoidCallback onTap;
  final bool selectable;
  final bool selected;
  final ValueChanged<bool> onSelected;

  AbstractObjectTile({
    @required this.object,
    @required this.index,
    this.onTap,
    @required this.filter,
    this.selectable = false,
    this.selected = true,
    this.onSelected,
  });

  @override
  State<AbstractObjectTile> createState() => AbstractObjectTileState<I, O, F>();
}

class AbstractObjectTileState<I, O extends WithId<I>, F extends AbstractFilter> extends State<AbstractObjectTile<I, O, F>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(widget.index.toString()),
      ),
    );
  }

  @protected
  Widget getCheckboxOverlay() {
    if (!this.widget.selectable) return Container();
    return Positioned(
      top: 0,
      left: 0,
      child: Checkbox(
        onChanged: widget.onSelected,
        value: widget.selected,
        activeColor: Colors.black,
      ),
    );
  }
}
