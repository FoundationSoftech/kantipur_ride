import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EsewaApp extends StatefulWidget {
  const EsewaApp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EsewaApp> createState() => _EsewaAppState();
}

class _EsewaAppState extends State<EsewaApp> {
  String refId = '';
  String hasError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                final result = await Esewa.i.init(
                    context: context,
                    eSewaConfig: ESewaConfig.dev(
                      su: 'https://www.success.com/success', // Success URL
                      fu: 'https://www.failure.com/failure', // Failure URL
                      amt: 10.0, // Payment amount
                      pid: '9806800001', // Payment ID
                      scd: 'EPAYTEST', // Merchant ID / Service Code from credentials
                    ));

                if (result.hasData) {
                  final response = result.data!;
                  setState(() {
                    refId = response.refId!;
                    hasError = '';
                  });
                  if (kDebugMode) {
                    print(response.toJson());
                  }
                } else {
                  setState(() {
                    refId = '';
                    hasError = result.error!;
                  });
                  if (kDebugMode) {
                    print(result.error);
                  }
                }
              },
              child: const Text('Pay with Esewa'),
            ),
            if (refId.isNotEmpty)
              Text('Console: Payment Success, Ref Id: $refId'),
            if (hasError.isNotEmpty)
              Text('Console: Payment Failed, Message: $hasError'),
          ],
        ),
      ),
    );
  }
}
