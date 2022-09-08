import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String kExamplePage = '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
</head>
<body>

<h1>Local demo page</h1>
<p>
 This is an example page used to demonstrate how to load a local file or HTML
 string using the <a href="https://pub.dev/packages/webview_flutter">Flutter
 webview</a> plugin.
</p>

</body>
</html>
''';

enum _MenuOptions {
  navigationDelegate,
  userAgent,
  javascriptChannel,
  listCookies,
  clearCookies,
  addCookie,
  setCookie,
  removeCookie,
  loadFlutterAsset,
  loadLocalFile,
  loadHtmlString,
}

class Menu extends StatefulWidget {
  const Menu({required this.controller, super.key});

  final Completer<WebViewController> controller;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final CookieManager cookieManager = CookieManager();

  // Load Local File
  Future<void> _onLoadLocalFileExample(
      WebViewController controller, BuildContext context) async {
    final String pathToIndex = await _prepareLocalFile();

    await controller.loadFile(pathToIndex);
  }

  static Future<String> _prepareLocalFile() async {
    final String tmpDir = (await getTemporaryDirectory()).path;
    final File indexFile = File('$tmpDir/www/index.html');

    await Directory('$tmpDir/www').create(recursive: true);
    await indexFile.writeAsString(kExamplePage);

    return indexFile.path;
  }

  // Load HTML String
  Future<void> _onLoadHtmlStringExample(
      WebViewController controller, BuildContext context) async {
    await controller.loadHtmlString(kExamplePage);
  }

  // Load Flutter asset
  Future<void> _onLoadFlutterAssetExample(
      WebViewController controller, BuildContext context) async {
    await controller.loadFlutterAsset('assets/www/index.html');
  }

  // Get list of all cookies
  Future<void> _onListCookies(WebViewController controller) async {
    final String cookies =
        await controller.runJavascriptReturningResult('document.cookie');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cookies.isNotEmpty ? cookies : 'There are no cookies.'),
      ),
    );
  }

  // Clear all cookies
  Future<void> _onClearCookies() async {
    final hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There were no cookies to clear.';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Add a cookie
  Future<void> _onAddCookie(WebViewController controller) async {
    await controller.runJavascript('''var date = new Date();
  date.setTime(date.getTime()+(30*24*60*60*1000));
  document.cookie = "FirstName=Sesha Dwi Lestari; expires=" + date.toGMTString();''');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie added.'),
      ),
    );
  }

  // Set a cookie with the CookieManager
  Future<void> _onSetCookie(WebViewController controller) async {
    await cookieManager.setCookie(
      const WebViewCookie(name: 'foo', value: 'bar', domain: 'flutter.dev'),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie is set.'),
      ),
    );
  }

  // Remove a cookie
  Future<void> _onRemoveCookie(WebViewController controller) async {
    await controller.runJavascript(
        'document.cookie="FirstName=John; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie removed.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: widget.controller.future, // Modify
      builder: (context, controller) {
        return PopupMenuButton<_MenuOptions>(
          onSelected: (value) async {
            switch (value) {
              case _MenuOptions.navigationDelegate:
                await controller.data!.loadUrl('https://youtube.com');
                break;
              // Add from here ...
              case _MenuOptions.userAgent:
                final userAgent = await controller.data!
                    .runJavascriptReturningResult('navigator.userAgent');
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(userAgent),
                ));
                break;
              // ... to here.
              case _MenuOptions.javascriptChannel:
                await controller.data!.runJavascript('''
var req = new XMLHttpRequest();
req.open('GET', "https://api.ipify.org/?format=json");
req.onload = function() {
  if (req.status == 200) {
    let response = JSON.parse(req.responseText);
    SnackBar.postMessage("IP Address: " + response.ip);
  } else {
    SnackBar.postMessage("Error: " + req.status);
  }
}
req.send();''');
                break;
              // Add the CookieManager Menu items
              case _MenuOptions.clearCookies:
                await _onClearCookies();
                break;
              case _MenuOptions.listCookies:
                await _onListCookies(controller.data!);
                break;
              case _MenuOptions.addCookie:
                await _onAddCookie(controller.data!);
                break;
              case _MenuOptions.setCookie:
                await _onSetCookie(controller.data!);
                break;
              case _MenuOptions.removeCookie:
                await _onRemoveCookie(controller.data!);
                break;
              // Load Flutter assets, local file, html string
              case _MenuOptions.loadFlutterAsset:
                await _onLoadFlutterAssetExample(controller.data!, context);
                break;
              case _MenuOptions.loadLocalFile:
                await _onLoadLocalFileExample(controller.data!, context);
                break;
              case _MenuOptions.loadHtmlString:
                await _onLoadHtmlStringExample(controller.data!, context);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.navigationDelegate,
              child: Text('Navigate to YouTube'),
            ),
            // Add from here ...
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.userAgent,
              child: Text('Show user-agent'),
            ),
            // ... to here.
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.javascriptChannel,
              child: Text('Lookup IP Address'),
            ),
            // Add the CookieManager to Menu Items
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.clearCookies,
              child: Text('Clear cookies'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.listCookies,
              child: Text('List cookies'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.addCookie,
              child: Text('Add cookie'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.setCookie,
              child: Text('Set cookie'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.removeCookie,
              child: Text('Remove cookie'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.loadFlutterAsset,
              child: Text('Load Flutter Asset'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.loadHtmlString,
              child: Text('Load HTML String'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.loadLocalFile,
              child: Text('Load Local File'),
            ),
          ],
        );
      },
    );
  }
}
