import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/auth/auth_provider.dart';
import 'package:courseplease/screens/sign_in_webview/sign_in_webview.dart';
import 'package:courseplease/utils/auth/oauth_code_http_server.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/auth/auth_providers.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get_it/get_it.dart';

// State is required to use context to navigate to the auth URI.
class SignInWidget extends StatefulWidget {
  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          // Text(
          //   'Continue with:',
          //   style: AppStyle.pageTitle,
          // ),
          Container(
            child: _buildProviderList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderList() {
    return StreamBuilder(
      stream: _authenticationCubit.outProviders,
      builder: (context, snapshot) => _buildProviderListWithState(snapshot.data),
    );
  }

  Widget _buildProviderListWithState(List<AuthProvider> authProviders) { // Nullable
    return authProviders == null
        ? SmallCircularProgressIndicator()
        : _buildProviderListWithList(authProviders);
  }

  Widget _buildProviderListWithList(List<AuthProvider> authProviders) {
    return AuthProvidersWidget(
      providers: authProviders,
      titleTemplate: "Continue with {@title}",
      onTap: _signInWith,
    );
  }

  void _signInWith(AuthProvider provider) async {
    _authenticationCubit.inEvent.add(
      RequestAuthorizationEvent(provider: provider, context: context),
    );
    return;
    //final server = await OAuthCodeHttpServer.setUp(port: AuthProvider.defaultLocalPort);
    //final codeFuture = server.getCodeFuture();

    final oauthTempKey = generatePassword(AuthenticationBloc.oauthTempKeyLength);
    final uri = provider.getOauthUrl(oauthTempKey);
    //final uri = 'http://localhost:8585';

    // final flutterWebviewPlugin = new FlutterWebviewPlugin();
    // flutterWebviewPlugin.launch(uri);
    final routeFuture = Navigator.of(context).pushNamed(
      SignInWebviewScreen.routeName,
      arguments: SignInWebviewArguments(uri: uri),
    );

    // routeFuture.then(
    //   (_) => server.shutdown(),
    //   onError: (_, StackTrace trace) => server.shutdown(),
    // );
    //
    // final code = await codeFuture;
    // final a = code;

    // String url =
    //     "https://api.instagram.com/oauth/authorize?client_id=$appId&redirect_uri=http://localhost:8585&response_type=code";
    // final flutterWebviewPlugin = new FlutterWebviewPlugin();
    // flutterWebviewPlugin.launch(url);
    // final String code = await onCode.first;
    // final http.Response response = await http.post(
    //     "https://api.instagram.com/oauth/access_token",
    //     body: {"client_id": appId, "redirect_uri": "http://localhost:8585", "client_secret": appSecret,
    //       "code": code, "grant_type": "authorization_code"});
    // flutterWebviewPlugin.close();
    // return new Token.fromMap(JSON.decode(response.body));
  }
}
