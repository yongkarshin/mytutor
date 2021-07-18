import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:mytutor/tutor.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';

void main() => runApp(PaymentScreen());

class PaymentScreen extends StatefulWidget {
  final User user;
  final Tutor tutor;
  final String bookingid, quantity, val, paystatus;
  PaymentScreen(
      {this.user,
      this.tutor,
      this.bookingid,
      this.quantity,
      this.val,
      this.paystatus});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double screenHeight, screenWidth;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Column(
        children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'http://smileylion.com/mytutor/php/payment.php?userid=' +
                        widget.user.userid +
                        '&mobile=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&bookingid=' +
                        widget.bookingid +
                        '&classid=' +
                        widget.tutor.classid +
                        '&quantity=' +
                        widget.quantity +
                        '&amount=' +
                        widget.val +
                        '&paystatus=' +
                        widget.paystatus,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            ),
          ]),
        
    );
  }
}
