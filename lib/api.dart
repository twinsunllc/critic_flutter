import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:http/http.dart' as http;
import 'package:inventiv_critic_flutter/modal/bug_report.dart';
import 'package:inventiv_critic_flutter/modal/ping_request_modal.dart';
import 'package:inventiv_critic_flutter/modal/ping_response.dart';
import 'package:inventiv_critic_flutter/modal/report_request_modal.dart';

final String _apiUrl = 'https://critic.inventiv.io/api/v2';

class Api {
  static Future<AppInstall> ping(PingRequest pingRequest) async {
    return await http.post(Uri.parse('$_apiUrl/ping'),
        body: json.encode(pingRequest.toJson()), headers: {HttpHeaders.contentTypeHeader: 'application/json'}).then((response) {
      if (response.statusCode == 200) {
        return AppInstall.fromJson(json.decode(response.body));
      } else {
        throw Exception('Response code: ' + response.statusCode.toString() + ', ' + response.body);
      }
    });
  }

  static Future<Map<String, String>> deviceStatus() async {
    var connectivity = await Connectivity().checkConnectivity();

    var battery = Battery();

    var returnVal = <String, String>{
      'device_status[network_cell_connected]': (connectivity == ConnectivityResult.mobile).toString(),
      'device_status[network_wifi_connected]': (connectivity == ConnectivityResult.wifi).toString(),
    };

    try {
      returnVal.addAll(<String, String>{
        'device_status[battery_charging]': ((await battery.onBatteryStateChanged.first) != BatteryState.discharging).toString(),
        'device_status[battery_level]': (await battery.batteryLevel).toString(),
      });
    } catch (err) {
      print(err);
    }

    return returnVal;
  }

  static Future<BugReport> submitReport(BugReportRequest submitReportRequest) async {
    final uri = Uri.parse('$_apiUrl/bug_reports');
    final request = http.MultipartRequest('POST', uri)
      ..fields['api_token'] = submitReportRequest.apiToken!
      ..fields['app_install[id]'] = submitReportRequest.appInstall.id.toString()
      ..fields['bug_report[description]'] = submitReportRequest.report.description ?? ''
      ..fields['bug_report[steps_to_reproduce]'] = submitReportRequest.report.stepsToReproduce ?? ''
      ..fields['bug_report[user_identifier]'] = submitReportRequest.report.userIdentifier ?? ''
      ..fields.addAll(await Api.deviceStatus());

    if (submitReportRequest.report.attachments?.isNotEmpty ?? false) {
      await Future.wait(submitReportRequest.report.attachments!.map((attachment) async {
        request.files.add(await http.MultipartFile.fromPath('bug_report[attachments][]', attachment.path!, filename: attachment.name));
      }));
    }

    final Completer<BugReport> completer = Completer<BugReport>();

    request.send().then((response) {
      print('Response: ${response.statusCode}');
      final contents = StringBuffer();
      response.stream.transform(utf8.decoder).listen((data) {
        contents.write(data);
      }, onDone: () {
        print(contents.toString());
        completer.complete(BugReport.fromJson(json.decode(contents.toString())));
      });
    });

    return completer.future;
  }
}
