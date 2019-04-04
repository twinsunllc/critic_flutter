import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:battery/battery.dart';
import 'package:http/http.dart' as http;
import 'package:inventiv_critic_flutter/modal/bug_report.dart';
import 'package:inventiv_critic_flutter/modal/ping_request_modal.dart';
import 'package:inventiv_critic_flutter/modal/ping_response.dart';
import 'package:inventiv_critic_flutter/modal/report_request_modal.dart';
import 'package:dio/dio.dart';
import "package:system_info/system_info.dart";

final String _apiUrl = 'https://critic.inventiv.io/api/v2';

class Api {
  static Future<AppInstall> ping(PingRequest pingRequest) async {
    return await http.post('$_apiUrl/ping',
        body: json.encode(pingRequest.toJson()), headers: {HttpHeaders.contentTypeHeader: 'application/json'}).then((response) {
      if (response.statusCode == 200) {
        return AppInstall.fromJson(json.decode(response.body));
      } else {
        throw Exception('Response code: ' + response.statusCode.toString() + ', ' + response.body);
      }
    });
  }

  static Future<Map<String, dynamic>> deviceStatus() async {
    var connectivity = await Connectivity().checkConnectivity();

    var battery = Battery();

    var returnVal = <String, dynamic>{
      'device_status[network_cell_connected]': connectivity == ConnectivityResult.mobile,
      'device_status[network_wifi_connected]': connectivity == ConnectivityResult.wifi,
    };

    try {
      returnVal.addAll(<String, dynamic>{
        'device_status[battery_charging]': (await battery.onBatteryStateChanged.first) != BatteryState.discharging,
        'device_status[battery_level]': await battery.batteryLevel,
      });
    } catch (err) {
      print(err);
    }

    return returnVal;
  }

  static Future<BugReport> submitReport(BugReportRequest submitReportRequest) async {
    Dio dio = new Dio();

    var attachments =
        submitReportRequest.report.attachments?.map((Attachment attachment) => UploadFileInfo(File(attachment.path), attachment.name))?.toList() ??
            [];

    FormData formData = new FormData.from({
      'api_token': submitReportRequest.apiToken,
      'app_install[id]': submitReportRequest.appInstall.id.toString(),
      'bug_report[description]': submitReportRequest.report.description,
      'bug_report[steps_to_reproduce]': submitReportRequest.report.stepsToReproduce,
      'bug_report[user_identifier]': submitReportRequest.report.userIdentifier,
      'bug_report[attachments][]': attachments,
    });

    formData.addAll(await Api.deviceStatus());

    Response response = await dio.post('$_apiUrl/bug_reports', data: formData).then((response) {
      print(response.data.toString());
      return response;
    }).catchError((err) {
      print(err.toString());
    });
    print(response.data.toString());
    return BugReport.fromJson(response.data);

    // return await http.post('$_apiUrl/bug_reports', body: json.encode(submitReportRequest.toJson()), headers: { HttpHeaders.contentTypeHeader: 'application/json' })
    //   .then((response){
    //     return BugReport.fromJson(json.decode(response.body));
    //   });
  }
}
