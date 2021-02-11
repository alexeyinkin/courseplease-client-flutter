import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/material.dart';

typedef void TileCallback<I, O extends WithId<I>>(O object, int index);
typedef T TileFactory<I, O extends WithId<I>, F extends AbstractFilter, T extends AbstractObjectTile<I, O, F>>({@required O object, @required int index, TileCallback<I, O> onTap});

class AbstractObjectTile<I, O extends WithId<I>, F extends AbstractFilter> extends StatelessWidget {
  final O object;
  final F filter;
  final int index;
  final TileCallback<I, O> onTap;

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
