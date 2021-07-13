import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/upload/single_image_upload.dart';
import 'package:courseplease/models/upload/scale_options.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/upload/callback_image_uploader.dart';
import 'package:get_it/get_it.dart';

class UserpicEditorWidgetCubit extends SingleImageUploadCubit {
  static const _scaleOptions = ScaleOptions(
    maxLength: 20 * 1024 * 1024,
    width: 1000,
    height: 1000,
  );

  UserpicEditorWidgetCubit() : super(
    scaleOptions: _scaleOptions,
    uploadOptions: CallbackImageUploadOptions(
      callback: (bytes) => GetIt.instance.get<ApiClient>().uploadUserpic(bytes),
    ),
  );

  @override
  void onComplete() {
    GetIt.instance.get<AuthenticationBloc>().reloadCurrentActor();
  }
}
