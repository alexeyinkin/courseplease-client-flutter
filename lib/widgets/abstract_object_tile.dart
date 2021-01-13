import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/material.dart';

typedef void TileCallback<I, D extends WithId<I>>(D object, int index);
typedef T TileFactory<I, D extends WithId<I>, F extends AbstractFilter, T extends AbstractObjectTile<I, D, F>>({@required D object, @required int index, TileCallback<I, D> onTap});

class AbstractObjectTile<I, D extends WithId<I>, F extends AbstractFilter> extends StatelessWidget {
  final D object;
  final F filter;
  final int index;
  final TileCallback<I, D> onTap;

  AbstractObjectTile({
    this.object,
    this.index,
    this.onTap,
    this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(index.toString()),
      ),
    );
  }
}
