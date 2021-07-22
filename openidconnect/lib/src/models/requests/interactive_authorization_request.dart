part of openidconnect;

class InteractiveAuthorizationRequest
    extends InteractiveAuthorizationPlatformRequest {
  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  factory InteractiveAuthorizationRequest({
    required String clientId,
    String? clientSecret,
    required String redirectUrl,
    required Iterable<String> scopes,
    required OpenIdConfiguration configuration,
    required bool autoRefresh,
    String? loginHint,
    Iterable<String>? prompts,
    Map<String, String>? additionalParameters,
    int webPopupWidth = 640,
    int webPopupHeight = 480,
  }) {
    final codeVerifier = List.generate(
        128, (i) => _charset[Random.secure().nextInt(_charset.length)]).join();

    final codeChallenge = base64Url
        .encode(sha256.convert(ascii.encode(codeVerifier)).bytes)
        .replaceAll('=', '');

    return InteractiveAuthorizationRequest._(
      clientId: clientId,
      redirectUrl: redirectUrl,
      scopes: scopes,
      configuration: configuration,
      autoRefresh: autoRefresh,
      codeVerifier: codeVerifier,
      codeChallenge: codeChallenge,
      additionalParameters: additionalParameters,
      clientSecret: clientSecret,
      loginHint: loginHint,
      prompts: prompts,
      webPopupHeight: webPopupHeight,
      webPopupWidth: webPopupWidth,
    );
  }

  InteractiveAuthorizationRequest._({
    required String clientId,
    String? clientSecret,
    required String redirectUrl,
    required Iterable<String> scopes,
    required OpenIdConfiguration configuration,
    required bool autoRefresh,
    required String codeVerifier,
    required String codeChallenge,
    String? loginHint,
    Iterable<String>? prompts,
    Map<String, String>? additionalParameters,
    int webPopupWidth = 640,
    int webPopupHeight = 480,
  }) : super(
          configuration: configuration,
          clientId: clientId,
          clientSecret: clientSecret,
          redirectUrl: redirectUrl,
          scopes: scopes,
          prompts: prompts,
          autoRefresh: autoRefresh,
          codeChallenge: codeChallenge,
          codeVerifier: codeVerifier,
          additionalParameters: additionalParameters,
          loginHint: loginHint,
          webPopupHeight: webPopupHeight,
          webPopupWidth: webPopupWidth,
        );
}