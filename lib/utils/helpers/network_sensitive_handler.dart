// This variable can be used to respond to changes in network connection
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../index.dart';

netSensitiveCall(
    {required BuildContext context, required Function callback}) {
  ConnectionStatus _connectionStatus =
      Provider.of<ConnectionStatus>(context, listen: false);

  // If no internet is available then display a message
  if (_connectionStatus == ConnectionStatus.Offline)
    displaySnackbar(context, 'Internet Connection is required');

  // If internet is available execure callback5
  else
    callback();
}
