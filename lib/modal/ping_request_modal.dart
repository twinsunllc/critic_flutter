import 'package:flutter/foundation.dart';
import 'package:inventiv_critic_flutter/modal/app.dart';
import 'package:inventiv_critic_flutter/modal/device.dart';

class PingRequest{
  String apiToken;
  App app;
  Device device;

  PingRequest({@required this.apiToken, @required this.app, @required this.device});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'api_token': apiToken,
    'app': app.toJson(),
    'device': device.toJson(),
  };
}