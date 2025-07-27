import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymobPaymentView extends StatefulWidget {
  const PaymobPaymentView({super.key, required this.paymentKey});

  final String paymentKey;

  @override
  State<PaymobPaymentView> createState() => _PaymobPaymentViewState();
}

class _PaymobPaymentViewState extends State<PaymobPaymentView> {
  final GlobalKey webViewKey = GlobalKey();
  late final InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(
            url: WebUri(
              'https://accept.paymob.com/api/acceptance/iframes/940321?payment_token=${widget.paymentKey}',
            ),
          ),
          initialSettings: InAppWebViewSettings(
            transparentBackground: true,
            safeBrowsingEnabled: true,
            isFraudulentWebsiteWarningEnabled: true,
          ),
          onWebViewCreated: (controller) => webViewController = controller,
        ),
      ),
    );
  }
}
