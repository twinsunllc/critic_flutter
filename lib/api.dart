import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:battery/battery.dart';
import 'package:http/http.dart' as http;
import 'package:inventiv_critic_flutter/modal/bug_report.dart';
import 'package:inventiv_critic_flutter/modal/ping_request_modal.dart';
import 'package:inventiv_critic_flutter/modal/ping_response.dart';
import 'package:inventiv_critic_flutter/modal/report_request_modal.dart';
import 'package:dio/dio.dart';

final String _apiUrl = 'https://critic.inventiv.io/api/v2';

class Api {
  static Future<AppInstall> ping(PingRequest pingRequest) async {
    return await http.post('$_apiUrl/ping',
        body: json.encode(pingRequest.toJson()),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'}).then((response) {
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
        'device_status[battery_charging]':
            ((await battery.onBatteryStateChanged.first) != BatteryState.discharging).toString(),
        'device_status[battery_level]': (await battery.batteryLevel).toString(),
      });
    } catch (err) {
      print(err);
    }

    return returnVal;
  }

  static Future<BugReport> submitReport(BugReportRequest submitReportRequest) async {
    Dio dio = new Dio();

    var attachments = submitReportRequest.report.attachments?.map((Attachment attachment) async {
          var logFile = File(attachment.path);
          var fileText = await logFile.readAsString();
          print('fileText');
          print(fileText);
          return MultipartFile.fromString(fileText);
        })?.toList() ??
        [];

    print('attachments.length ${attachments.length}');

    FormData formData = new FormData.fromMap({
      'api_token': submitReportRequest.apiToken,
      'app_install[id]': submitReportRequest.appInstall.id.toString(),
      'bug_report[description]': submitReportRequest.report.description,
      'bug_report[steps_to_reproduce]': submitReportRequest.report.stepsToReproduce,
      'bug_report[user_identifier]': submitReportRequest.report.userIdentifier,
      'bug_report[attachments][]': attachments,
    });

    Map<String, String> thing = await Api.deviceStatus();
    formData.fields.addAll(thing.entries);

    Response response = await dio.post('$_apiUrl/bug_reports', data: formData).then((response) {
      print(response.data.toString());
      return response;
    }).catchError((err) {
      print(err.toString());
    });
    print(response.data.toString());
    return BugReport.fromJson(response.data);
  }
}
