import 'dart:async';

import 'package:courseplease/models/server_image.dart';
import 'package:courseplease/models/upload/image_upload.dart';
import 'package:courseplease/models/upload/scale_options.dart';
import 'package:courseplease/services/upload/callback_image_uploader.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';
import 'image_upload_list.dart';

class SingleImageUploadCubit extends Bloc {
  final _outStateController = BehaviorSubject<SingleImageUploadCubitState>();
  Stream<SingleImageUploadCubitState> get outState => _outStateController.stream;

  final _imageUploadListCubit = ImageUploadListCubit.single();
  late final StreamSubscription _imageUploadListCubitSubscription;
  late ImageUploadListCubitState _imageUploadListCubitState;

  final initialState = SingleImageUploadCubitState(
    serverImage: null,
  );

  final ScaleOptions scaleOptions;
  final CallbackImageUploadOptions uploadOptions;

  SingleImageUploadCubit({
    required this.scaleOptions,
    required this.uploadOptions,
  }) {
    _imageUploadListCubitSubscription = _imageUploadListCubit.outState.listen(
      _onImageStateChanged,
    );
    _imageUploadListCubitState = _imageUploadListCubit.initialState;
  }

  void _onImageStateChanged(ImageUploadListCubitState imageUploadListCubitState) {
    _imageUploadListCubitState = imageUploadListCubitState;

    final state = _createState();
    _outStateController.sink.add(state);

    if (state.serverImage is ImageUpload) {
      if ((state.serverImage as ImageUpload).status == ImageUploadStatus.complete) {
        onComplete();
      }
    }
  }

  @protected
  void onComplete() {}

  SingleImageUploadCubitState _createState() {
    return SingleImageUploadCubitState(
      serverImage: _imageUploadListCubitState.list.isEmpty ? null : _imageUploadListCubitState.list.last,
    );
  }

  void pickAndUpload() {
    final uploader = CallbackImageUploader();

    final stream = uploader.pickAndUploadImage(scaleOptions, uploadOptions);
    _imageUploadListCubit.addStream(stream);
  }

  void delete() {
    _imageUploadListCubit.clearDeleteFiles();
  }

  @override
  void dispose() {
    _imageUploadListCubitSubscription.cancel();
    _outStateController.close();
  }
}

class SingleImageUploadCubitState {
  final ServerImage? serverImage;

  SingleImageUploadCubitState({
    @required this.serverImage,
  });
}
