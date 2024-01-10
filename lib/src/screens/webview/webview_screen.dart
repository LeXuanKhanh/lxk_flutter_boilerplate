import 'package:flutter/material.dart';
import 'package:lxk_flutter_boilerplate/src/utils/general_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool isLoading = false;
  WebViewController controller = WebViewController();
  double progressValue = 0;

  @override
  void initState() {
    super.initState();
    initWebViewController();
  }

  void initWebViewController() async {
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
          setState(() {
            progressValue = progress.toDouble();
          });
        },
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final url =
        tryCast<String>(ModalRoute.of(context)!.settings.arguments) ?? '';
    controller.loadRequest(Uri.parse(url));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: [
          Visibility(
            visible: progressValue != 100,
            child: LinearProgressIndicator(
              value: progressValue
            ),
          ),
          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
