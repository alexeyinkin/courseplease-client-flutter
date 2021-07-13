import 'package:courseplease/models/server_image.dart';
import 'package:courseplease/models/upload/image_upload.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';

class ImageUploadListCubit extends Bloc {
  final _outStateController = BehaviorSubject<ImageUploadListCubitState>();
  Stream<ImageUploadListCubitState> get outState => _outStateController.stream;
  ImageUploadListCubitState get currentState => _createState();

  final initialState = ImageUploadListCubitState(
    list: [],
    canUploadMore: true, // TODO: false if constructed with 0 allowed.
  );
  final int maxCount;
  final ImageUploadListCubitMode mode;

  ImageUploadListCubit({
    required this.maxCount,
    this.mode = ImageUploadListCubitMode.limit,
  });

  factory ImageUploadListCubit.single() {
    return ImageUploadListCubit(
      maxCount: 1,
      mode: ImageUploadListCubitMode.revolve,
    );
  }

  var _list = <ServerImage>[];

  void addStream(Stream<ImageUpload> imageUploadStream) {
    imageUploadStream.listen(_onImageStateChange);
  }

  void _onImageStateChange(ImageUpload imageUpload) {
    _list = _addOrReplaceInList(imageUpload);
    _pushOutput();
  }

  List<ServerImage> _addOrReplaceInList(ImageUpload imageUpload) {
    bool found = false;
    final result = <ServerImage>[];

    for (final old in _list) {
      if (old.tempId != imageUpload.tempId) {
        result.add(old);
      } else {
        result.add(imageUpload);
        found = true;
      }
    }

    if (!found) {
      result.add(imageUpload);
    }

    if (result.length > maxCount) {
      _deleteImageNoFire(result[0].tempId);
    }

    return result;
  }

  void _pushOutput() {
    _outStateController.sink.add(_createState());
  }

  ImageUploadListCubitState _createState() {
    return ImageUploadListCubitState(
      list: _list,
      canUploadMore: _canUploadMore(),
    );
  }

  bool _canUploadMore() {
    switch (mode) {
      case ImageUploadListCubitMode.revolve:
        return true;
      case ImageUploadListCubitMode.limit:
        return _list.length < maxCount;
    }
    throw Exception('Unknown mode: ' + mode.toString());
  }

  void clearKeepFiles() {
    _list.clear();
    _pushOutput();
  }

  void clearDeleteFiles() {
    for (final obj in _list) {
      _deleteFileAtServer(obj);
    }
    _list.clear();
    _pushOutput();
  }

  void deleteImage(String tempId) {
    _deleteImageNoFire(tempId);
    _pushOutput();
  }

  void _deleteImageNoFire(String tempId) {
    for (final obj in _list) {
      if (obj.tempId == tempId) {
        _deleteFileAtServer(obj);
      }
    }

    _list = _removeFromList(tempId);
  }

  void _deleteFileAtServer(ServerImage serverImage) {
    final urls = serverImage.urls;

    if (urls.isEmpty) {
      // TODO: Cancel the upload or schedule deletion on upload.
      //throw UnimplementedError();
    }

    // TODO: Delete.
    //throw UnimplementedError();
  }

  List<ServerImage> _removeFromList(String tempId) {
    return _list.where((element) => element.tempId != tempId).toList();
  }

  @override
  void dispose() {
    _outStateController.close();
  }
}

class ImageUploadListCubitState {
  final List<ServerImage> list;
  final bool canUploadMore;

  ImageUploadListCubitState({
    required this.list,
    required this.canUploadMore,
  });
}

enum ImageUploadListCubitMode {
  /// Cannot upload more than the limit.
  limit,

  /// Older images are removed when uploading over the limit.
  revolve,
}
