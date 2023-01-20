part of openidconnect;

class OpenIdConnectAndroidiOS {
  static Future<String> authorizeInteractive({
    required BuildContext context,
    required String title,
    required String authorizationUrl,
    required String redirectUrl,
    required int popupWidth,
    required int popupHeight,
  }) async {
    final result = await showGeneralDialog<String?>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (dialogContext, _, __) {
        final NavigationDelegate _navigationDelegate = NavigationDelegate(
          onPageFinished: (url) {
            print('###############################################');
            print(url);
            print('###############################################');
            if (url.startsWith(redirectUrl)) {
              Navigator.pop(dialogContext, url);
            }
          },
          onPageStarted: (url) {
            if (url.startsWith(redirectUrl)) {
              Navigator.pop(dialogContext, url);
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(redirectUrl)) {
              Navigator.of(context, rootNavigator: true).pop(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        );
        late final WebViewController controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(_navigationDelegate)
          ..loadRequest(Uri.parse(authorizationUrl));
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [WebViewWidget(controller: controller)],
            ),
          ),
        );
      },
    );

    if (result == null) throw AuthenticationException(ERROR_USER_CLOSED);

    return result;
  }
}
