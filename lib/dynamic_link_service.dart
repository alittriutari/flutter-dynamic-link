import 'package:dynamic_link/test_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  Future<Uri> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://testingappkey.page.link/',
        link: Uri.parse('https://appkey.co.id/'),
        androidParameters: AndroidParameters(packageName: 'com.testing.dynamic_link', minimumVersion: 1),
        iosParameters: IosParameters(bundleId: 'com.testing.dynamic_link', minimumVersion: '1'));

    var dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    //When the app is in the background but not shut down, and
    //we open the app by the click of a dynamic link, onLink() will be called.
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      //we check if we received the link successfully
      final Uri deepLink = dynamicLink?.link;
      print('deepLink ' + deepLink.toString());

      if (deepLink != null) {
        // ignore: unawaited_futures
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TestScreen(),
        ));
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    //If the app is not opened, getInitialLink() is called.
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink(); //we call getInitialLink to get the dynamic link if the app was closed
    print('PendingDynamicLinkData ' + data.toString());

    final Uri deepLink = data?.link; //we extract the URI from that deep-link and check if the URI is not null

    if (deepLink != null) {
      // ignore: unawaited_futures
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TestScreen(),
      ));
    }
  }
}
