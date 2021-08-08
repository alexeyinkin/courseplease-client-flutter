import 'package:courseplease/blocs/list_action/link_list_action.dart';
import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/blocs/list_action/move_list_action.dart';
import 'package:courseplease/blocs/list_action/unlink_list_action.dart';
import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/repositories/image.dart';

class ImageListActionCubit extends MediaSortListActionCubit<int, ImageEntity, MyImageFilter, MyImageRepository>
    with
        MoveListActionMixin<int, MyImageFilter>,
        LinkListActionMixin<int, MyImageFilter>,
        UnlinkListActionMixin<int, MyImageFilter>
{
  static const _mediaType = 'image';

  ImageListActionCubit({
    required MyImageFilter filter,
  }) : super (
    filter: filter,
  );

  @override
  String getMediaType() {
    return _mediaType;
  }
}
