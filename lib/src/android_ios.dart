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
            if (request.url.startsWith(redirectUrl) && Platform.isIOS) {
              Navigator.pop(dialogContext, request.url);
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
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFF56CCF2),
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(0xFF05A1CF),
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light),
            backgroundColor: Color(0xFFFFFFFF),
            elevation: 0,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/images/arrow-left.svg',
                color: Color(0xFF5A647C),
              ),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  controller.goBack();
                } else {
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ),
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
