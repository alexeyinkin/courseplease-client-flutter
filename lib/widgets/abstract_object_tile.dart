import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef void TileCallback<I, O extends WithId<I>>(O object, int index);

/// The request generated by abstract grid and list to show models.
/// Whatever is managed by them goes here.
/// Whatever is managed per-object by concrete lists goes separately
/// to concrete tile constructors.
class TileCreationRequest<
  I,
  O extends WithId<I>,
  F extends AbstractFilter
> {
  final O object;
  final int index;
  final F filter;
  final VoidCallback onTap;
  final bool selected;
  final ValueChanged<bool> onSelected;

  TileCreationRequest({
    @required this.object,
    @required this.index,
    @required this.filter,
    @required this.onTap,
    @required this.selected,
    @required this.onSelected,
  });
}

typedef T TileFactory<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  T extends AbstractObjectTile<I, O, F>
>(TileCreationRequest<I, O, F> request);

class AbstractObjectTile<I, O extends WithId<I>, F extends AbstractFilter> extends StatefulWidget {
  final O object;
  final F filter;
  final int index;
  final VoidCallback onTap;
  final bool selectable;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final List<Widget> overlays;

  AbstractObjectTile({
    @required TileCreationRequest<I, O, F> request,
    this.selectable = false,
    this.overlays = const <Widget>[],
  }) :
      object      = request.object,
      index       = request.index,
      filter      = request.filter,
      onTap       = request.onTap,
      selected    = request.selected,
      onSelected  = request.onSelected
  ;

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
      right: 0,
      child: Checkbox(
        onChanged: widget.onSelected,
        value: widget.selected,
        activeColor: Colors.black,
      ),
    );
  }
}
